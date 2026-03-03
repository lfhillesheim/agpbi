#!/bin/bash
# AGPBI - Criar novo repositório de cliente
# Uso: ./scripts/new-client.sh <nome-do-cliente>

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar argumentos
if [ -z "$1" ]; then
    echo -e "${RED}Erro: Nome do cliente não fornecido${NC}"
    echo "Uso: ./scripts/new-client.sh <nome-do-cliente>"
    exit 1
fi

CLIENT_NAME=$1
CLIENT_SLUG=$(echo "$CLIENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
TEMPLATE_REPO="lfhillesheim/agpbi"

echo -e "${GREEN}=== AGPBI - Criar Novo Cliente ===${NC}"
echo "Cliente: $CLIENT_NAME"
echo "Slug: $CLIENT_SLUG"
echo ""

# 1. Criar repositório
echo -e "${YELLOW}1. Criando repositório...${NC}"
gh repo create "$CLIENT_SLUG" --private --clone || {
    echo -e "${RED}Erro ao criar repositório${NC}"
    echo "O repositório já existe? Use: gh repo clone $CLIENT_SLUG"
    exit 1
}

cd "$CLIENT_SLUG"

# 2. Adicionar template como remote
echo -e "${YELLOW}2. Adicionando template como remote...${NC}"
git remote add template "https://github.com/$TEMPLATE_REPO.git"

# 3. Buscar template
echo -e "${YELLOW}3. Buscando template...${NC}"
git fetch template

# 4. Merge com template
echo -e "${YELLOW}4. Mergeando template...${NC}"
git merge template/main --allow-unrelated-histories -m "feat: Initial from AGPBI template" --no-edit

# 5. Remover remote do template
echo -e "${YELLOW}5. Limpando remote...${NC}"
git remote remove template

# 6. Criar estrutura de pastas
echo -e "${YELLOW}6. Criando estrutura de pastas...${NC}"
mkdir -p 00-contexto 01-vision 02-validate 03-build/projects 04-reunioes 05-atividades 06-decisoes

# 7. Copiar templates de contexto
if [ -d "templates/cliente/00-contexto" ]; then
    cp templates/cliente/00-contexto/*.md 00-contexto/ 2>/dev/null || true
fi

# 8. Criar .context inicial
mkdir -p .context
echo '{"version":"1.0","created_at":"'$(date -u +%Y-%m-%d)'","client":"'$CLIENT_NAME'","phases":[]}' > .context/index.json
touch .context/decisions.log .context/artifacts.log .context/status.log .context/changes.log

# 9. Personalizar CLAUDE.md
echo -e "${YELLOW}7. Personalizando CLAUDE.md...${NC}"
sed -i "s/# AGPBI Framework/# $CLIENT_NAME - AGPBI Framework/" CLAUDE.md
sed -i "/^## Sobre Nossa Consultoria/a\\n**Cliente**: $CLIENT_NAME\\n**Setor**: [Preencher]\\n**Início**: $(date +%Y-%m-%d)\\n" CLAUDE.md

# 10. Remover hooks do settings.json (não suportado no Claude Code 2.1+)
echo -e "${YELLOW}8. Ajustando settings.json...${NC}"
if [ -f ".claude/settings.json" ]; then
    # Criar settings.json limpo sem hooks
    cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allowlist": {
      "bash": [
        "git status",
        "git diff",
        "git log",
        "git add",
        "git commit",
        "git push",
        "git pull",
        "git checkout",
        "git branch",
        "ls",
        "mkdir",
        "cat"
      ],
      "file": {
        "read": true,
        "write": true,
        "edit": true
      }
    }
  },
  "skills": [
    ".claude/skills/agpbi-vision",
    ".claude/skills/agpbi-validate",
    ".claude/skills/agpbi-build",
    ".claude/skills/agpbi-transcrever-reuniao",
    ".claude/skills/agpbi-status",
    ".claude/skills/agpbi-retrospectiva",
    ".claude/skills/agpbi-revisar-modelo",
    ".claude/skills/agpbi-inicializar-pbip",
    ".claude/skills/agpbi-criar-medida",
    ".claude/skills/agpbi-criar-relacionamento",
    ".claude/skills/agpbi-criar-visual",
    ".claude/skills/agpbi-criar-calculation-group",
    ".claude/skills/agpbi-otimizar-query",
    ".claude/skills/agpbi-configurar-rls",
    ".claude/skills/agpbi-configurar-incremental-refresh",
    ".claude/skills/agpbi-deploy-pbip",
    ".claude/skills/agpbi-validar-modelo",
    ".claude/skills/agpbi-verificar-estrutura",
    ".claude/skills/agpbi-organizar-arquivos",
    ".claude/skills/agpbi-limpar-temporarios",
    ".claude/skills/agpbi-resumir-documento",
    ".claude/skills/agpbi-auditoria-arquivos",
    ".claude/skills/agpbi-status-arquivos",
    ".claude/skills/agpbi-powerbi-modeling"
  ]
}
EOF
fi

# 11. Commit inicial
echo -e "${YELLOW}9. Commit inicial...${NC}"
git add .
git commit -m "feat: Initialize $CLIENT_NAME repository from AGPBI template" || true

# 12. Push
echo -e "${YELLOW}10. Push para remoto...${NC}"
git push -u origin main

echo ""
echo -e "${GREEN}=== Cliente criado com sucesso! ===${NC}"
echo ""
echo "Próximos passos:"
echo "  1. cd $CLIENT_SLUG"
echo "  2. Editar 00-contexto/cliente.md com dados do cliente"
echo "  3. Editar CLAUDE.md com mais detalhes se necessário"
echo "  4. Usar /agpbi-vision para iniciar o primeiro projeto"
echo ""
echo "URL do repositório: https://github.com/$(git config github.user)/$CLIENT_SLUG"
