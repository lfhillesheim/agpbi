# Gestão de Branches - AGPBI Framework

## Estrutura

```
main          = Template puro do framework (NUNCA trabalhar aqui)
topmed        = Cliente Topmed
empresa-x     = Cliente Empresa X
```

---

# 🚀 NOVO: Sistema Automatizado

## Use o `/agpbi-push-framework`

O framework **detecta automaticamente** se a mudança é geral ou específica:

```
/agpbi-push-framework
→ Descreva o que fez
→ Framework analisa e sugere (main ou branch)
→ Você confirma
→ Framework executa tudo automaticamente
```

### Como Funciona

1. Você faz mudanças (skills, projetos, etc)
2. Chama `/agpbi-push-framework`
3. Descreve: "Criei nova skill agpbi-xxx"
4. Framework pergunta: "Isso beneficia todos? [main] ✅"
5. Você confirma
6. Framework: stasha → vai pra main → commita → atualiza todos clientes

**Pronto!** Sem comandos git manuais.

---

## Tipos de Mudança

### 🌍 MUDANÇA GERAL (Vai para MAIN)

**São mudanças que beneficiam TODOS os clientes:**

| Tipo | Exemplo |
|------|---------|
| Nova skill | `/agpbi-xxx` novo |
| Melhoria de skill | `/agpbi-vision` melhor |
| Novo agente | Novo agente XYZ |
| Bug no framework | Correção de erro |
| Novo script | Script útil para todos |
| Documentação | Atualização de README |

### 🏢 MELHORIA ISOLADA (Fica no BRANCH do cliente)

**São mudanças ESPECÍFICAS daquele cliente:**

| Tipo | Exemplo |
|------|---------|
| Dados do cliente | Info sobre Topmed |
| Projetos | `topmed-financeiro` |
| Customização | Cores da marca Topmed |
| Dados específicos | URLs, APIs do cliente |
| Docs do cliente | Contexto de Topmed |

---

## Criar Novo Cliente

```bash
# 1. Estar na main
git checkout main

# 2. Criar branch do cliente
git checkout -b topmed

# 3. Criar primeiro projeto
scripts\new-project.bat topmed-financeiro "Dashboard Financeiro"

# 4. Commit e push
git add .
git commit -m "feat: Add topmed-financeiro project"
git push -u origin topmed
```

---

## Manual (se preferir)

### Mudança Geral

```bash
git checkout main
# ... mudar ...
git add .
git commit -m "feat: Nova feature"
git push

# Atualizar clientes
scripts\update-clientes.bat
```

### Mudança Específica

```bash
git checkout topmed
# ... mudar ...
git add .
git commit -m "feat: Customizacao"
git push
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
```
