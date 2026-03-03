# Gestão de Branches - AGPBI Framework

## Estrutura

```
main          = Template puro do framework (NUNCA trabalhar aqui)
topmed        = Cliente Topmed
empresa-x     = Cliente Empresa X
```

---

## Criar Novo Cliente

```bash
# 1. Estar na main
git checkout main

# 2. Criar branch do cliente
git checkout -b topmed

# 3. Criar primeiro projeto
/scripts/new-project.bat topmed-financeiro "Dashboard Financeiro"

# 4. Commit e push
git add .
git commit -m "feat: Add topmed-financeiro project"
git push -u origin topmed
```

---

## Tipos de Mudança

### 🌍 MELHORIA GERAL (Vai para MAIN)

**São mudanças que beneficiam TODOS os clientes:**

| Tipo | Exemplo | Para onde vai |
|------|---------|---------------|
| Nova skill | `/agpbi-xxx` novo | `main` |
| Melhoria de skill | `/agpbi-vision` melhor | `main` |
| Novo agente | Novo agente XYZ | `main` |
| Bug no framework | Correção de erro | `main` |
| Novo script | Script útil para todos | `main` |
| Documentação | Atualização de README | `main` |

**Fluxo:**
```bash
# 1. Ir para main
git checkout main

# 2. Fazer a mudança
# ... editar arquivos ...

# 3. Commit e push
git add .
git commit -m "feat: Add nova feature para todos clientes"
git push

# 4. Merge para cada cliente
git checkout topmed
git merge main
git push

git checkout empresa-x
git merge main
git push
```

---

### 🏢 MELHORIA ISOLADA (Fica no BRANCH do cliente)

**São mudanças ESPECÍFICAS daquele cliente:**

| Tipo | Exemplo | Para onde vai |
|------|---------|---------------|
| Dados do cliente | Info sobre Topmed | Branch `topmed` |
| Projetos | `topmed-financeiro` | Branch `topmed` |
| Customização | Cores da marca Topmed | Branch `topmed` |
| Dados específicos | URLs, APIs do cliente | Branch `topmed` |
| Docs do cliente | Contexto de Topmed | Branch `topmed` |

**Fluxo:**
```bash
# Já estar no branch do cliente
git checkout topmed

# Fazer mudança específica
# ... editar arquivos ...

# Commit e push
git add .
git commit -m "feat: Add customizacao para Topmed"
git push
```

---

## Checklist: MAIN ou CLIENTE?

### Pergunta: Esta mudança beneficia TODOS os clientes?

- **SIM** → Vai para `main`
- **NÃO** → Vai para branch do cliente

### Exemplos Práticos

| Mudança | Para onde vai? |
|---------|---------------|
| Criar `/agpbi-criar-grafico` | `main` ✅ |
| Corrigir bug no `/agpbi-vision` | `main` ✅ |
| Adicionar logo Topmed | `topmed` ❌ |
| Criar projeto `topmed-vendas` | `topmed` ❌ |
| Melhorar script `new-project.bat` | `main` ✅ |
| Atualizar `clientes.md` | `main` ✅ |
| Documentação específica Topmed | `topmed` ❌ |

---

## Atualizar Clientes com Mudanças da Main

```bash
# Script para atualizar todos clientes
#!/bin/bash

CLIENTES="topmed empresa-x outro-cliente"

git checkout main
git pull

for cliente in $CLIENTES; do
    echo "Atualizando $cliente..."
    git checkout $cliente
    git merge main
    git push
done

git checkout main
```

---

## Resumo Visual

```
┌─────────────────────────────────────────────────────────┐
│  MAIN (Template Puro)                                    │
│  ┌─────────────────────────────────────────────────┐   │
│  │ .claude/          (skills, agents)              │   │
│  │ scripts/          (new-project.bat, etc)        │   │
│  │ README.md                                      │   │
│  │ clientes.md                                    │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
            │ merge (framework updates)
            ▼
┌─────────────────────────────────────────────────────────┐
│  TOPMED (Branch)                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │ .claude/          (herdado da main)             │   │
│  │ scripts/          (herdado da main)             │   │
│  │ 01-vision/topmed-financeiro/  (ESPECÍFICO)      │   │
│  │ 02-validate/topmed-financeiro/ (ESPECÍFICO)     │   │
│  │ 03-build/topmed-financeiro/    (ESPECÍFICO)     │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Comandos Úteis

```bash
# Ver branch atual
git branch --show-current

# Ver todos os branches
git branch -a

# Criar novo cliente
git checkout main
git checkout -b novo-cliente

# Atualizar cliente com main
git checkout topmed
git merge main

# Ver diferença entre main e cliente
git diff main..topmed
```
