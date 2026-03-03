# Criar Novo Repositório de Cliente

Este guia explica como criar um novo repositório para um cliente a partir do template AGPBI.

## Pré-requisitos

- GitHub CLI (`gh`) instalado e autenticado
- Permissões para criar repositórios na organização

## Método 1: GitHub CLI (Recomendado)

```bash
# 1. Criar o novo repositório
gh repo create cliente-nome --private --clone

# 2. Entrar no diretório
cd cliente-nome

# 3. Adicionar o template como remote
git remote add template https://github.com/lfhillesheim/agpbi.git

# 4. Buscar o template
git fetch template

# 5. Merge com o template (histórias não relacionadas)
git merge template/main --allow-unrelated-histories -m "feat: Initial from AGPBI template"

# 6. Remover remote do template (opcional)
git remote remove template

# 7. Push para o novo repo
git push -u origin main
```

## Método 2: Manual (GitHub UI)

1. Acesse https://github.com/lfhillesheim/agpbi
2. Clique em "Use this template" → "Create a new repository"
3. Nomeie como `cliente-nome`
4. Marque como "Private"
5. Clone o novo repositório

```bash
gh repo clone cliente-nome
cd cliente-nome
```

## Após Criar - Configuração Inicial

### 1. Personalizar CLAUDE.md

```bash
# Editar informações do cliente
nano CLAUDE.md
```

Adicione na primeira seção:
```markdown
# Cliente: [Nome do Cliente]

**Setor**: [Indústria do cliente]
**Contato principal**: [Nome e email]
**Início**: [Data de início]

---
```

### 2. Criar estrutura de contexto

```bash
# Criar pastas principais
mkdir -p 00-contexto 01-vision 02-validate 03-build 04-reunioes 05-atividades 06-decisoes

# Copiar templates
cp templates/cliente/00-contexto/*.md 00-contexto/
```

### 3. Inicializar contexto do projeto

```bash
# Usar o skill do AGPBI
/agpbi-inicializar-pbip
```

## Sincronizar com Template (Futuro)

Quando o AGPBI template for atualizado:

```bash
# 1. Adicionar remote do template (se não existir)
git remote add template https://github.com/lfhillesheim/agpbi.git

# 2. Buscar atualizações
git fetch template

# 3. Ver o que mudou
git log HEAD..template/main --oneline

# 4. Merge das mudanças
git merge template/main -m "chore: Sync with AGPBI template vX.X.X"

# 5. Resolver conflitos se houver
# 6. Push
git push
```

## Checklist de Novo Cliente

- [ ] Repositório criado como privado
- [ ] Template AGPBI mergeado
- [ ] CLAUDE.md personalizado com dados do cliente
- [ ] Estrutura de pastas criada (00-06)
- [ ] Contexto inicial preenchido (00-contexto/)
- [ ] Colaboradores adicionados (se necessário)
- [ ] Issues/Projects configurados (opcional)

## Estrutura Final do Repositório do Cliente

```
cliente-nome/
├── .claude/              # Config do AGPBI (pode personalizar)
├── 00-contexto/          # Contexto permanente do cliente
│   ├── cliente.md
│   ├── tecnologia.md
│   ├── pessoas.md
│   └── processos.md
├── 01-vision/            # Descobertas e escopo
├── 02-validate/          # Validações e POCs
├── 03-build/             # Implementação
│   └── projects/         # Projetos PBIP
├── 04-reunioes/          # Transcrições
├── 05-atividades/        # Gestão de tarefas
├── 06-decisoes/          # Decisões e aprovações
├── .context/             # SSOT do projeto
├── CLAUDE.md             # Documentação principal
└── README.md             # Overview do projeto
```

---

**Última atualização**: 2026-03-03
