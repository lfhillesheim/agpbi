# AGPBI Framework

> Framework especializado para consultoria de dados Power BI
> **Metodologia**: Vision → Validate → Build

**Versão**: 3.2.0

---

## 🎯 Como Funciona

```
Vision (Descobrir) → Validate (Testar) → Build (Fazer)
```

| Fase | O que faz |
|------|-----------|
| **Vision** | Entende o problema, mapeia dados, define escopo |
| **Validate** | Conecta fontes, valida números, cria POC |
| **Build** | Modela dados, cria DAX, monta dashboard |

---

## 📁 Estrutura de Branches

```
main     = Template puro (framework)
topmed   = Cliente Topmed
empresa-x = Cliente Empresa X
```

**Sempre trabalhe no branch do cliente!**

---

## 💻 Usar o Framework

| Comando | Para quê |
|---------|---------|
| `/agpbi-vision` | Iniciar discovery |
| `/agpbi-validate` | Validar dados/POC |
| `/agpbi-build` | Construir solução |
| `/agpbi-status` | Ver status |
| `/agpbi-push-framework` | **Push mudanças (auto-detecta)** |

---

## 🚀 Como Trabalhar

### 1. Criar Novo Cliente

```bash
git checkout main
git checkout -b nome-cliente
scripts\new-project.bat cliente-projeto "Descrição"
```

### 2. Criar Projeto

```cmd
scripts\new-project.bat topmed-financeiro "Dashboard Financeiro"
```

### 3. Fazer Mudanças e Push

```bash
# Opcao 1: Automático (RECOMENDADO)
/agpbi-push-framework
→ Framework detecta se é geral ou específica
→ Confirma e executa tudo

# Opcao 2: Manual
git commit -am "feat: descricao"
git push
```

---

## 🌍 vs 🏢: Tipos de Mudança

| GERAL (vai para main) | ESPECÍFICA (fica no branch) |
|------------------------|------------------------------|
| Nova skill `/agpbi-xxx` | Projeto `topmed-financeiro` |
| Melhoria de agente | Dados do cliente Topmed |
| Bug no framework | Customizações |
| Documentação | APIs específicas |

**O `/agpbi-push-framework` detecta automaticamente!**

---

## 📋 Fluxo Completo

```cmd
# 1. Ir para branch do cliente
git checkout topmed

# 2. Criar projeto
scripts\new-project.bat topmed-financeiro "Dashboard Financeiro"

# 3. Trabalhar normalmente
/agpbi-vision

# 4. Quando terminar, push
/agpbi-push-framework
```

---

## 📖 Documentação

- **`GESTAO-FRAMEWORK.md`** - Gestão de branches detalhada
- **`clientes.md`** - Lista de clientes

---

**Framework pronto! 🚀**

Use `/agpbi-push-framework` para commits automatizados.
