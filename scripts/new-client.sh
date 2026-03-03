#!/bin/bash
# AGPBI - Criar nova pasta de cliente (Monorepo)
# Uso: ./scripts/new-client.sh <nome-do-cliente>

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Erro: Nome do cliente não fornecido${NC}"
    echo "Uso: ./scripts/new-client.sh <nome-do-cliente>"
    exit 1
fi

CLIENT_NAME="$1"
CLIENT_SLUG=$(echo "$CLIENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr '/' '-')

CLIENT_DIR="clientes/$CLIENT_SLUG"

if [ -d "$CLIENT_DIR" ]; then
    echo -e "${RED}Erro: Cliente já existe em $CLIENT_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}=== AGPBI - Novo Cliente ===${NC}"
echo "Cliente: $CLIENT_NAME"
echo "Slug: $CLIENT_SLUG"
echo ""

# Criar estrutura
echo -e "${YELLOW}Criando estrutura...${NC}"
mkdir -p "$CLIENT_DIR"/{00-contexto,01-vision,02-validate,03-build/projects,04-reunioes,05-atividades,06-decisoes,.context}

# Criar CLAUDE.md específico do cliente
cat > "$CLIENT_DIR/CLAUDE.md" << CLIENTEOF
# $CLIENT_NAME - AGPBI Framework

> **Metodologia**: Vision → Validate → Build
> **Cliente**: $CLIENT_NAME
> **Início**: $(date +%Y-%m-%d)

## Contexto do Cliente

**Setor**: [Preencher]
**Contato Principal**: [Preencher]
**Stack Tecnológico**: [Preencher]

## Comandos Principais

### Metodologia
- \`/agpbi-vision\` - Iniciar etapa Vision (discovery)
- \`/agpbi-validate\` - Iniciar etapa Validate (POCs)
- \`/agpbi-build\` - Iniciar etapa Build (implementação)
- \`/agpbi-status\` - Ver status do projeto
- \`/agpbi-retrospectiva\` - Retrospectiva ao final de fase

### Técnico Power BI
- \`/agpbi-inicializar-pbip\` - Criar estrutura PBIP
- \`/agpbi-criar-medida\` - Criar medida DAX
- \`/agpbi-criar-relacionamento\` - Criar relacionamento
- \`/agpbi-otimizar-query\` - Otimizar Power Query
- \`/agpbi-deploy-pbip\` - Deploy para Power BI Service

### Governança
- \`/agpbi-transcrever-reuniao\` - Processar transcrição
- \`/agpbi-organizar-arquivos\` - Organizar projeto
- \`/agpbi-validar-modelo\` - Validar modelo completo

## Estrutura de Pastas

- \`00-contexto/\` - Contexto permanente do cliente
- \`01-vision/\` - Discovery e escopo de projetos
- \`02-validate/\` - Validações e POCs
- \`03-build/\` - Implementação (projetos PBIP)
- \`04-reunioes/\` - Transcrições e resumos
- \`05-atividades/\` - Gestão de tarefas
- \`06-decisoes/\` - Decisões e aprovações

## Projetos

Use \`/agpbi-vision\` para iniciar um novo projeto.

---

**Framework AGPBI** gerenciado no monorepo principal.
CLIENTEOF

# Criar .context inicial
echo '{"version":"1.0","created_at":"'$(date -u +%Y-%m-%d)'","client":"'$CLIENT_NAME'","phases":[]}' > "$CLIENT_DIR/.context/index.json"
touch "$CLIENT_DIR/.context"/{decisions.log,artifacts.log,status.log,changes.log,lessons-learned.md}

# Criar contexto inicial do cliente
cat > "$CLIENT_DIR/00-contexto/cliente.md" << CONTEXTEOF
# $CLIENT_NAME - Contexto do Cliente

## Overview

**Nome**: $CLIENT_NAME
**Setor**: [Preencher]
**Porte**: [Preencher]
**Início do Relacionamento**: $(date +%Y-%m-%d)

## Equipe

| Nome | Papel | Email |
|------|-------|-------|
| [Nome] | [Cargo] | [email] |

## Stack Tecnológico

- **ERP**: [Preencher]
- **Database**: [Preencher]
- **BI**: Power BI
- **Outros**: [Preencher]

## Objetivos Estratégicos

1. [Preencher]
2. [Preencher]
3. [Preencher]

## Histórico de Projetos

Nenhum projeto ainda.

---

*Atualizado em: $(date +%Y-%m-%d)*
CONTEXTEOF

echo ""
echo -e "${GREEN}✓ Cliente criado: $CLIENT_DIR${NC}"
echo ""
echo "Próximos passos:"
echo "  1. cd $CLIENT_DIR"
echo "  2. Editar CLAUDE.md e 00-contexto/cliente.md com dados do cliente"
echo "  3. Usar /agpbi-vision para iniciar o primeiro projeto"
echo ""
