# AGPBI Framework

> Framework especializado para consultoria de dados com Power BI
> Template principal para criação de repositórios de cliente

**Versão**: 3.2.0
**Última atualização**: 2026-03-03
**Status**: ✅ Produção

---

## 🎯 O que é AGPBI?

O **AGPBI** é um framework completo com agentes, skills e templates projetados especificamente para consultorias de dados Power BI.

### Metodologia: Vision → Validate → Build

| Fase | Objetivo | Entrega |
|------|----------|---------|
| **🔭 Vision** | Discovery rápido e escopo claro | Contexto, stakeholders, hipótese |
| **✓ Validate** | POCs e validação de dados | Wireframe, números validados |
| **🔨 Build** | Construção técnica escalável | PBIP, docs, deploy |

---

## 🚀 Criar Novo Repositório de Cliente

### Opção 1: Script Automatizado (Recomendado)

```bash
# Clonar este template primeiro
git clone https://github.com/lfhillesheim/agpbi.git
cd agpbi

# Executar script
./scripts/new-client.sh "Nome do Cliente"
```

### Opção 2: GitHub CLI

```bash
gh repo create cliente-nome --private --clone
cd cliente-nome
git remote add template https://github.com/lfhillesheim/agpbi.git
git fetch template
git merge template/main --allow-unrelated-histories -m "feat: Initial from AGPBI"
git remote remove template
git push -u origin main
```

### Opção 3: GitHub UI

1. Acesse https://github.com/lfhillesheim/agpbi
2. Clique em **"Use this template"** → **"Create a new repository"**
3. Nomeie como `cliente-nome` e marque como **Private**

> 📖 **Guia completo**: [docs/novo-cliente.md](docs/novo-cliente.md)

---

## 📁 Estrutura do Repositório do Cliente

```
cliente-nome/
├── .claude/              # Config AGPBI (não modificar)
├── 00-contexto/          # Contexto permanente do cliente
├── 01-vision/            # Descobertas e escopo
├── 02-validate/          # Validações e POCs
├── 03-build/             # Implementação PBIP
│   └── projects/         # Projetos Power BI
├── 04-reunioes/          # Transcrições e resumos
├── 05-atividades/        # Gestão de tarefas
├── 06-decisoes/          # Decisões e aprovações
├── .context/             # SSOT do projeto
├── CLAUDE.md             # Documentação principal
└── README.md             # Overview do cliente
```

---

## 💻 Comandos Disponíveis (todos com prefixo `/agpbi-`)

### Metodologia
| Comando | Descrição |
|---------|-----------|
| `/agpbi-vision` | Iniciar fase Vision |
| `/agpbi-validate` | Iniciar fase Validate |
| `/agpbi-build` | Iniciar fase Build |
| `/agpbi-status` | Ver status do projeto |
| `/agpbi-retrospectiva` | Retrospectiva ao final de fase |

### Técnico Power BI
| Comando | Descrição |
|---------|-----------|
| `/agpbi-inicializar-pbip` | Criar estrutura PBIP |
| `/agpbi-criar-medida` | Criar medida DAX |
| `/agpbi-criar-relacionamento` | Criar relacionamento |
| `/agpbi-criar-calculation-group` | Criar calculation group |
| `/agpbi-configurar-rls` | Configurar RLS |
| `/agpbi-configurar-incremental-refresh` | Configurar incremental refresh |
| `/agpbi-otimizar-query` | Otimizar Power Query |
| `/agpbi-deploy-pbip` | Deploy para Power BI Service |
| `/agpbi-powerbi-modeling` | Assistente de modelagem Power BI |

### Governança
| Comando | Descrição |
|---------|-----------|
| `/agpbi-transcrever-reuniao` | Processar transcrição |
| `/agpbi-revisar-modelo` | Revisar modelo Power BI |
| `/agpbi-validar-modelo` | Validar modelo completo |
| `/agpbi-verificar-estrutura` | Validar estrutura de arquivos |
| `/agpbi-organizar-arquivos` | Organizar projeto |
| `/agpbi-auditoria-arquivos` | Auditoria completa |
| `/agpbi-status-arquivos` | Status da organização |
| `/agpbi-limpar-temporarios` | Limpar arquivos temporários |
| `/agpbi-resumir-documento` | Resumir documento |

---

## 🔄 Sincronizar com Template

Quando o AGPBI for atualizado:

```bash
git remote add template https://github.com/lfhillesheim/agpbi.git
git fetch template
git log HEAD..template/main --oneline  # ver mudanças
git merge template/main -m "chore: Sync with AGPBI template vX.X.X"
git push
```

---

## 📖 Documentação

| Arquivo | Descrição |
|---------|-----------|
| [CLAUDE.md](CLAUDE.md) | Constituição completa do framework |
| [docs/novo-cliente.md](docs/novo-cliente.md) | Criar novo repositório de cliente |
| [docs/guia-inicio-rapido.md](docs/guia-inicio-rapido.md) | Comece aqui |
| [docs/metodologia.md](docs/metodologia.md) | Vision-Validate-Build detalhado |
| [docs/melhores-praticas.md](docs/melhores-praticas.md) | Boas práticas Power BI |

---

## 🛠️ Componentes do Framework

### Agentes (7)
- **agpbi-orchestrator** - Coordenador principal
- **agpbi-vision-discovery** - Discovery e escopo
- **agpbi-validate-poc** - Validações e POCs
- **agpbi-build-implementer-v2** - Desenvolvedor PBIP
- **agpbi-meeting-transcriber** - Transcrições de reunião
- **agpbi-file-governance-agent** - Governança de arquivos
- **agpbi-pattern-detector** - Detecta padrões de sucesso

### Skills (24)
- **Metodologia** (5): vision, validate, build, status, retrospectiva
- **Técnicos** (9): pbip, medida, relacionamento, visual, calc-group, RLS, incremental, query, deploy
- **Governança** (9): transcrição, revisão, validação, estrutura, organização, auditoria, status-arquivos, limpar, resumir
- **Modeling** (1): powerbi-modeling + 11 referências

### Hooks (7)
- **Nativos**: pre-write, post-write
- **Custom**: pre-bash, pre-commit, post-phase

---

## 📊 Versão

### v3.2.0 (2026-03-03)
- ✅ Prefixo `agpbi-` padronizado em todos comandos
- ✅ Criados arquivos anti-patterns e improvements
- ✅ Guia e script para criar novos clientes
- ✅ 24 skills funcionais
- ✅ 7 agentes especializados

### Histórico
- **v3.1.0** - Sistema SSOT, novos skills técnicos
- **v3.0.0** - Framework limpo e focado

---

**Template pronto para produção! 🚀**

Para criar um novo cliente: [docs/novo-cliente.md](docs/novo-cliente.md)
