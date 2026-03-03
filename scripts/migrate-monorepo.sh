#!/bin/bash
# AGPBI - Migrar para estrutura Monorepo Centralizado
# Uso: ./scripts/migrate-monorepo.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== AGPBI - Migrar para Monorepo ===${NC}"
echo ""

# 1. Criar pasta clientes
echo -e "${YELLOW}1. Criando pasta clientes/...${NC}"
mkdir -p clientes

# 2. Mover Topmed para clientes/
if [ -d "Topmed" ]; then
    echo -e "${YELLOW}2. Movendo Topmed para clientes/...${NC}"
    mv Topmed clientes/topmed
else
    echo -e "${YELLOW}2. Topmed já migrado ou não existe${NC}"
fi

# 3. Criar script para novos clientes
echo -e "${YELLOW}3. Criando script de novo cliente...${NC}"
cat > scripts/new-client-mono.sh << 'SCRIPT'
#!/bin/bash
# AGPBI - Criar nova pasta de cliente (Monorepo)
# Uso: ./scripts/new-client-mono.sh <nome-do-cliente>

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Erro: Nome do cliente não fornecido${NC}"
    echo "Uso: ./scripts/new-client-mono.sh <nome-do-cliente>"
    exit 1
fi

CLIENT_NAME=$1
CLIENT_SLUG=$(echo "$CLIENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo -e "${GREEN}=== Criar Cliente: $CLIENT_NAME ===${NC}"
echo ""

mkdir -p "clientes/$CLIENT_SLUG"/{00-contexto,01-vision,02-validate,03-build/projects,04-reunioes,05-atividades,06-decisoes}

# Criar CLAUDE.md específico do cliente
cat > "clientes/$CLIENT_SLUG/CLAUDE.md" << EOF
# $CLIENT_NAME - AGPBI Framework

> **Metodologia**: Vision → Validate → Build
> **Cliente**: $CLIENT_NAME
> **Início**: $(date +%Y-%m-%d)

## Contexto do Cliente

**Setor**: [Preencher]
**Contato Principal**: [Preencher]

## Projetos

Use \`/agpbi-vision\` para iniciar um novo projeto.

## Estrutura

- \`00-contexto/\` - Contexto permanente do cliente
- \`01-vision/\` - Discovery e escopo de projetos
- \`02-validate/\` - Validações e POCs
- \`03-build/\` - Implementação
- \`04-reunioes/\` - Transcrições e resumos
- \`05-atividades/\` - Gestão de tarefas
- \`06-decisoes/\` - Decisões e aprovações

---

Framework AGPBI gerenciado no monorepo principal.
EOF

# Criar .context inicial
mkdir -p "clientes/$CLIENT_SLUG/.context"
echo '{"version":"1.0","created_at":"'$(date -u +%Y-%m-%d)'","client":"'$CLIENT_NAME'","phases":[]}' > "clientes/$CLIENT_SLUG/.context/index.json"
touch "clientes/$CLIENT_SLUG/.context"/{decisions.log,artifacts.log,status.log,changes.log}

echo -e "${GREEN}✓ Cliente criado: clientes/$CLIENT_SLUG${NC}"
echo ""
echo "Próximos passos:"
echo "  1. cd clientes/$CLIENT_SLUG"
echo "  2. Editar CLAUDE.md com dados do cliente"
echo "  3. Usar /agpbi-vision para iniciar o primeiro projeto"
SCRIPT

chmod +x scripts/new-client-mono.sh

# 4. Atualizar README
echo -e "${YELLOW}4. Atualizando README.md...${NC}"
cat > README.md << 'EOF'
# AGPBI Framework - Monorepo

Framework de consultoria de dados Power BI com metodologia Vision → Validate → Build.

## Estrutura

```
agpbi/
├── .claude/          # Framework (skills, agents, referências)
├── _framework/       # Documentação do framework
├── clientes/         # Repositórios de clientes
│   ├── topmed/
│   └── empresa-x/
├── scripts/          # Scripts utilitários
└── README.md
```

## Criar Novo Cliente

```bash
./scripts/new-client-mono.sh "Nome da Empresa"
```

## Trabalhar com Cliente

Navegue até a pasta do cliente e use os comandos AGPBI:

```bash
cd clientes/topmed
/agpbi-vision     # Iniciar discovery
/agpbi-status     # Ver status do projeto
```

## Metodologia

1. **Vision** 🔭 - Discovery rápido, entender o problema
2. **Validate** ✓ - POCs, validar hipóteses
3. **Build** 🔨 - Construção escalável

## Documentação

Ver `_framework/` para documentação completa.
EOF

echo ""
echo -e "${GREEN}=== Migração concluída! ===${NC}"
echo ""
echo "Estrutura criada:"
echo "  clientes/          # Pasta de clientes"
echo "  clientes/topmed/   # Cliente Topmed migrado"
echo ""
echo "Para criar novos clientes:"
echo "  ./scripts/new-client-mono.sh \"Nome da Empresa\""
echo ""
echo "Commit das mudanças:"
echo "  git add ."
echo "  git commit -m \"feat: Migrate to monorepo structure\""
echo "  git push"
