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

## 📁 Estrutura Simples

```
agpbi/
├── .claude/              # Framework (skills, agents) - NÃO MEXER
├── 01-vision/            # Projetos em discovery
│   ├── topmed-financeiro/
│   └── empresa-x-vendas/
├── 02-validate/          # Projetos em validação
├── 03-build/             # Projetos em construção
├── scripts/              # Scripts úteis
├── clientes.md           # Lista de clientes
└── README.md
```

---

## 🚀 Criar Novo Projeto

```cmd
scripts\new-project.bat topmed-financeiro "Dashboard Financeiro"
```

Cria:
```
01-vision/topmed-financeiro/
02-validate/topmed-financeiro/
03-build/topmed-financeiro/
```

---

## 💻 Usar o Framework

**Sempre trabalhe na raiz do `agpbi`**

| Comando | Para quê |
|---------|---------|
| `/agpbi-vision` | Iniciar discovery |
| `/agpbi-validate` | Validar dados/POC |
| `/agpbi-build` | Construir solução |
| `/agpbi-status` | Ver status |

**Comandos técnicos:**
- `/agpbi-inicializar-pbip` - Criar projeto Power BI
- `/agpbi-criar-medida` - Criar medida DAX
- `/agpbi-otimizar-query` - Otimizar Power Query
- `/agpbi-deploy-pbip` - Deploy para Power BI Service

---

## 📋 Fluxo Completo

```cmd
# 1. Criar projeto
scripts\new-project.bat topmed-financeiro "Dashboard Financeiro"

# 2. Abrir Claude na pasta agpbi

# 3. Iniciar Vision
/agpbi-vision
# → Responder: cliente=topmed, projeto=financeiro

# 4. Depois de Vision aprovado
/agpbi-validate

# 5. Depois de Validado
/agpbi-build

# 6. Ver status anytime
/agpbi-status
```

---

## ✅ É Só Isso!

- **Sempre na raiz do agpbi**
- **Nome do projeto = cliente-projeto** (ex: topmed-financeiro)
- **Framework centralizado** - skills e agents compartilhados
- **Sem sync manual**

---

**Framework pronto! 🚀**
