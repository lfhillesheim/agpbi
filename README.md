# AGPBI Framework - Monorepo

> Framework especializado para consultoria de dados com Power BI
> **Metodologia**: Vision → Validate → Build

**Versão**: 3.2.0
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

## 📁 Estrutura Monorepo

```
agpbi/
├── .claude/              # Framework (skills, agents, refs) - CENTRALIZADO
├── _framework/           # Documentação do framework
├── clientes/             # Pastas de cada cliente
│   ├── topmed/          # Cliente existente
│   └── nova-empresa/    # Novos clientes aqui
├── scripts/              # Scripts utilitários
│   └── new-client.sh    # Criar novo cliente
└── README.md
```

### Por que Monorepo?

✅ **Framework centralizado** - uma atualização, todos os clientes beneficiados
✅ **Sem sync manual** - skills e agents são compartilhados
✅ **Simples** - um repo para gerenciar tudo
✅ **Isolamento** - cada cliente tem sua pasta e contexto

---

## 🚀 Criar Novo Cliente

```bash
./scripts/new-client.sh "Nome da Empresa"
```

Isso cria:

```
clientes/nova-empresa/
├── 00-contexto/          # Contexto permanente
├── 01-vision/            # Discovery
├── 02-validate/          # POCs
├── 03-build/             # Implementação
├── 04-reunioes/          # Transcrições
├── 05-atividades/        # Tarefas
├── 06-decisoes/          # Decisões
├── .context/             # SSOT do cliente
└── CLAUDE.md             # Config específica
```

---

## 💼 Trabalhar com Cliente

Navegue até a pasta do cliente:

```bash
cd clientes/topmed
```

Use os comandos AGPBI:

| Comando | Descrição |
|---------|-----------|
| `/agpbi-vision` | Iniciar discovery |
| `/agpbi-validate` | Criar POCs |
| `/agpbi-build` | Implementar |
| `/agpbi-status` | Ver status |
| `/agpbi-retrospectiva` | Retrospectiva |

---

## 💻 Comandos Disponíveis

### Metodologia (5)
| Comando | Descrição |
|---------|-----------|
| `/agpbi-vision` | Iniciar fase Vision |
| `/agpbi-validate` | Iniciar fase Validate |
| `/agpbi-build` | Iniciar fase Build |
| `/agpbi-status` | Ver status do projeto |
| `/agpbi-retrospectiva` | Retrospectiva ao final de fase |

### Técnico Power BI (9)
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
| `/agpbi-powerbi-modeling` | Assistente de modelagem |

### Governança (9)
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
- **Modeling** (1): powerbi-modeling

---

## 🔄 Atualizações do Framework

**Framework centralizado = uma atualização, todos os clientes beneficiados!**

Sempre que você:
- Adiciona uma skill nova
- Melhora um agent
- Atualiza a documentação

Todos os clientes automaticamente têm acesso, sem precisar de sync manual.

---

## 📖 Documentação

| Arquivo | Descrição |
|---------|-----------|
| [CLAUDE.md](CLAUDE.md) | Constituição completa do framework |
| [_framework/](._framework/) | Referências técnicas |

---

## 📊 Versão

### v3.2.0 (2026-03-03)
- ✅ Estrutura Monorepo
- ✅ Prefixo `agpbi-` padronizado
- ✅ 24 skills funcionais
- ✅ 7 agentes especializados
- ✅ Script simplificado para novos clientes

---

**Framework pronto para produção! 🚀**

Para criar um novo cliente: `./scripts/new-client.sh "Nome da Empresa"`
