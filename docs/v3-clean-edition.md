# AGPBI Framework v3.0 - Estrutura Final Limpa

> Framework especializado para consultoria de dados Power BI - Sem BMAD, 100% focado

**Versão**: 3.0 (Clean Edition)
**Data**: 2026-02-27
**Status**: ✅ Produção

---

## 🎯 O que é o AGPBI Framework

Um conjunto de agentes, skills e processos projetados **exclusivamente** para consultorias de dados que trabalham com Power BI.

### Foco
- **Power BI** - Modelagem, DAX, PBIP, visuais
- **Metodologia** - Vision → Validate → Build
- **Governança** - Arquivos organizados automaticamente
- **Automação** - 50+ operações com 1 comando
- **Qualidade** - Gates, validações, revisões

### O que NÃO é
- ❌ Framework genérico de desenvolvimento de software
- ❌ Scrum, Agile, etc.
- ❌ Criador de agentes genéricos
- ❌ Brainstorming criativo (não é nosso foco)

---

## 📁 Estrutura Final

```
agpbi/
├── CLAUDE.md                           # Constituição do projeto
├── README.md                           # Documentação principal
│
├── .claude/
│   ├── settings.json                   # Configuração (limpa)
│   │
│   ├── agents/                         # 6 AGENTES ESPECIALIZADOS
│   │   ├── orchestrator.md            # ⭐ Coordenador principal
│   │   ├── vision-discovery.md        # Discovery profundo
│   │   ├── validate-poc.md            # Validações e POCs
│   │   ├── build-implementer-v2.md    # ⭐ Desenvolvedor técnico PBIP
│   │   ├── meeting-transcriber.md     # Transcrições de reunião
│   │   └── file-governance-agent.md   # ⭐ Governança de arquivos
│   │
│   ├── skills/                         # 20 SKILLS (WORKFLOWS)
│   │   │
│   │   ├── metodologia/                # Vision-Validate-Build
│   │   │   ├── vision/                 # Fase Vision
│   │   │   ├── validate/               # Fase Validate
│   │   │   ├── build/                  # Fase Build
│   │   │   ├── status/                 # Status do projeto
│   │   │   ├── transcrever-reuniao/   # Reuniões
│   │   │   └── revisar-modelo/         # Revisão Power BI
│   │   │
│   │   ├── tecnicas-pbi/               # Automação Power BI
│   │   │   ├── inicializar-pbip/       # Criar PBIP
│   │   │   ├── criar-medida/           # Medidas DAX
│   │   │   ├── criar-relacionamento/   # Relacionamentos
│   │   │   ├── criar-visual/           # Visuais
│   │   │   ├── otimizar-query/         # Otimizar M
│   │   │   ├── configurar-rls/         # Segurança
│   │   │   └── validar-modelo/         # Qualidade
│   │   │
│   │   ├── powerbi-modeling/           # Skill principal + referências
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       ├── MEASURES-DAX.md
│   │   │       ├── PERFORMANCE.md
│   │   │       ├── RELATIONSHIPS.md
│   │   │       ├── RLS.md
│   │   │       └── STAR-SCHEMA.md
│   │   │
│   │   └── governanca/                 # Organização de arquivos
│   │       ├── verificar-estrutura/   # Verificar localização
│   │       ├── organizar-arquivos/     # Auto-organizar
│   │       ├── limpar-temporarios/     # Limpar temp
│   │       ├── resumir-documento/     # Resumir docs
│   │       ├── auditoria-arquivos/     # Auditoria completa
│   │       └── status-arquivos/        # Status rápido
│   │
│   └── hooks/                          # 5 HOOKS DE QUALIDADE
│       ├── commit-quality-check.md     # Commits padronizados
│       ├── documentation-validator.md  # Docs completas
│       ├── file-governance-check.md    # Arquivos organizados
│       ├── phase-gate-check.md         # Gates entre fases
│       └── powerbi-quality-check.md    # Modelo verificado
│
├── templates/                           # Templates para projetos
│   └── cliente/
│       ├── 00-contexto/                # Contexto permanente
│       ├── 01-vision/                  # Docs Vision
│       ├── 02-validate/                # Docs Validate
│       ├── 03-build/                   # Docs Build
│       ├── 04-reunioes/                # Reuniões
│       ├── 05-atividades/              # Tarefas
│       └── 06-decisoes/                # Decisões
│
├── docs/                                # Documentação do framework
│   ├── metodologia.md                 # Metodologia detalhada
│   ├── guia-inicio-rapido.md          # Comece aqui
│   ├── melhores-praticas.md           # Boas práticas
│   ├── orquestracao.md                # Como orquestração funciona
│   ├── file-governance.md             # Governança de arquivos
│   └── RESUMO-TECNICO-v2.md           # Resumo técnico
│
└── _framework/                          # Core do framework
    ├── methodology/
    ├── governance/
    └── references/
```

---

## 🤖 Agentes (6)

### 1. Orchestrator ⭐ Principal
**Arquivo**: `orchestrator.md`

**Função**: Coordenador principal que sabe tudo sobre o projeto.

**O que faz**:
- Verifica em que fase o projeto está
- Decide qual agente chamar
- Garante que gates sejam respeitados
- Gerencia localização de arquivos

**Quando atua**: SEMPRE - É o ponto de entrada principal

### 2. Vision Discovery
**Arquivo**: `vision-discovery.md`

**Função**: Discovery profundo e definição de escopo.

**O que faz**:
- Entrevistas com stakeholders
- Mapeamento de processos e dados
- Definição de escopo claro
- Criação dos 5 documentos obrigatórios

**Quando atua**: Fase Vision

### 3. Validate POC
**Arquivo**: `validate-poc.md`

**Função**: Validações rápidas e POCs.

**O que faz**:
- Conecta nas fontes de dados
- Explora e valida números
- Cria wireframe
- Testa viabilidade técnica

**Quando atua**: Fase Validate

### 4. Build Implementer v2 ⭐ Técnico
**Arquivo**: `build-implementer-v2.md`

**Função**: Desenvolvedor Power BI sênior automático.

**O que faz**:
- Lê requisitos (wireframe, dados, técnica)
- Executa 10 passos AUTOMATICAMENTE
- Chama 50+ skills técnicas sozinho
- Cria documentação completa

**Quando atua**: Fase Build

**Conhecimento técnico**:
- ONDE: `03-build/projects/[dept]/[proj].pbip/`
- O QUE LER: `02-validate/*.md`
- O QUE CRIAR: PBIP + docs

### 5. Meeting Transcriber
**Arquivo**: `meeting-transcriber.md`

**Função**: Processa transcrições de reunião.

**O que faz**:
- Extrai action items
- Documenta decisões
- Identifica gargalos
- Cria resumos estruturados

**Quando atua**: Quando usuário fornece transcrição

### 6. File Governance ⭐ Novo
**Arquivo**: `file-governance-agent.md`

**Função**: Mantém arquivos organizados automaticamente.

**O que faz**:
- Detecta arquivos fora do lugar
- Move para local correto
- Remove arquivos temporários
- Gera auditorias com score

**Quando ativa**: A pedido ou via hooks

---

## ⚡ Skills (20)

### Metodologia (6)

| Skill | Função | Quando usar |
|-------|--------|-------------|
| `/vision` | Fase Vision completa | Início de projeto |
| `/validate` | Fase Validate completa | Após Vision |
| `/build` | Fase Build completa | Após Validate + GO |
| `/status` | Status do projeto | A qualquer momento |
| `/transcrever-reuniao` | Processar reunião | Pós-reunião |
| `/revisar-modelo` | Revisão Power BI | Qualidade |

### Técnicas Power BI (7)

| Skill | Função | Chamada por |
|-------|--------|------------|
| `/inicializar-pbip` | Criar estrutura PBIP | Build Agent |
| `/criar-medida` | Criar medida DAX | Build Agent |
| `/criar-relacionamento` | Criar relacionamento | Build Agent |
| `/criar-visual` | Criar visual | Build Agent |
| `/otimizar-query` | Otimizar Power Query | Build Agent |
| `/configurar-rls` | Configurar segurança | Build Agent |
| `/validar-modelo` | Validar qualidade | Build Agent |

### Power BI Modeling (1 + 5 referências)

| Skill | Função | Conteúdo |
|-------|--------|----------|
| `powerbi-modeling` | Skill principal MCP | Conexão e análise |
| `references/MEASURES-DAX.md` | Padrões DAX | Medidas e formatação |
| `references/PERFORMANCE.md` | Performance | Otimização |
| `references/RELATIONSHIPS.md` | Relacionamentos | Cardinalidade |
| `references/RLS.md` | Segurança | Row-Level Security |
| `references/STAR-SCHEMA.md` | Star Schema | Dimensões e fatos |

### Governança (6)

| Skill | Função | Quando usar |
|-------|--------|-------------|
| `/verificar-estrutura` | Verificar localização | A qualquer momento |
| `/organizar-arquivos` | Auto-organizar | Quando desordenado |
| `/limpar-temporarios` | Limpar temp | Manutenção |
| `/resumir-documento` | Resumir doc | Para entender |
| `/auditoria-arquivos` | Auditoria completa | Relatório |
| `/status-arquivos` | Status rápido | Check rápido |

---

## 🔗 Hooks (5)

| Hook | Quando | O que faz |
|------|--------|-----------|
| `commit-quality-check` | Pre-commit | Valida commit message |
| `documentation-validator` | Pre-write | Valida docs |
| `file-governance-check` | Pre-write/commit | Verifica localização |
| `phase-gate-check` | Pre-bash | Gates entre fases |
| `powerbi-quality-check` | Pre-write | Valida modelo PBIP |

---

## 🚀 Fluxo de Trabalho Típico

```
USUÁRIO: "/start novo-projeto"

ORCHESTRATOR:
Iniciando Vision Phase...

[Delega para Vision Discovery Agent]

VISION AGENT:
[Entrevista, coleta, cria 5 docs]

✅ Vision completo!

ORCHESTRATOR:
Pronto para Validate?

USUÁRIO: "/validate"

ORCHESTRATOR:
[Verifica gates: Vision ✅]
Delegando para Validate Agent...

VALIDATE AGENT:
[Conecta dados, valida números, wireframe]

✅ Validate completo! GO decision obtida.

ORCHESTRATOR:
Pronto para Build?

USUÁRIO: "/build dashboard_vendas"

ORCHESTRATOR:
[Verifica gates: Vision ✅, Validate ✅]
Delegando para Build Implementer...

BUILD AGENT:
[Lê requisitos, executa 10 passos]

Passo 1: ✅ /inicializar-pbip
Passo 2: ✅ /conectar-fonte (x5)
Passo 3: ✅ /classificar-tabela (x4)
Passo 4: ✅ /criar-medida (x15)
Passo 5: ✅ /criar-visual (x12)
Passo 6: ✅ /aplicar-tema
Passo 7: ✅ /configurar-refresh
Passo 9: ✅ /gerar-doc-* (x3)
Passo 10: ✅ /validar-modelo

🎉 Dashboard completo!

Local: 03-build/projects/comercial/dashboard_vendas.pbip/
```

---

## 📊 Comparativo Antes vs Depois

### Antes (v2.0 - Com BMAD)
- Agents: 7 (1 duplicata)
- Skills: 20 ✅
- Commands: 76 ❌ (BMAD desnecessário)
- Hooks: 5 ✅
- **Total**: 108 arquivos
- **Foco**: Misturado (Power BI + Dev genérico)

### Depois (v3.0 - Clean)
- Agents: 6 ✅
- Skills: 20 ✅
- Commands: 0 ✅ (removido)
- Hooks: 5 ✅
- **Total**: 31 arquivos
- **Foco**: 100% Power BI e BI

**Redução**: 77 arquivos removidos (71% de redução!)

---

## ✅ Benefícios da Limpeza

### 1. Framework Mais Leve
- Menos arquivos para manter
- Carregamento mais rápido
- Mais fácil de entender

### 2. Sem Confusão
- Zero comandos BMAD misturados
- Só tem o que é relevante
- Documentação mais clara

### 3. Foco Total
- 100% orientado a Power BI
- Metodologia Vision-Validate-Build
- Consultoria de dados específica

### 4. Manutenção Simples
- Menos coisas para quebrar
- Atualizações mais fáceis
- Documentação coesa

---

## 🎯 Comandos Principais

### Metodologia
- `/start` - Inicia novo projeto
- `/vision` - Fase Vision
- `/validate` - Fase Validate
- `/build` - Fase Build
- `/status` - Status do projeto

### Técnica
- `/revisar-modelo` - Revisar modelo Power BI
- (Demais skills são chamadas automaticamente)

### Governança
- `/auditoria-arquivos` - Auditoria completa
- `/organizar-arquivos` - Organizar tudo
- `/limpar-temporarios` - Limpar projeto
- `/status-arquivos` - Status rápido

---

## 📚 Documentação

### Para Começar
- [README.md](README.md) - Visão geral
- [CLAUDE.md](CLAUDE.md) - Constituição completa
- [docs/guia-inicio-rapido.md](docs/guia-inicio-rapido.md) - Comece aqui

### Para Aprofundar
- [docs/metodologia.md](docs/metodologia.md) - Metodologia detalhada
- [docs/melhores-praticas.md](docs/melhores-praticas.md) - Boas práticas
- [docs/orquestracao.md](docs/orquestracao.md) - Como orquestração funciona
- [docs/file-governance.md](docs/file-governance.md) - Governança de arquivos

### Técnica
- [docs/RESUMO-TECNICO-v2.md](docs/RESUMO-TECNICO-v2.md) - Resumo técnico

---

## 🚀 Próximos Passos

1. **Testar o framework** - Criar um projeto piloto
2. **Personalizar** - Ajustar para suas necessidades
3. **Contribuir** - Compartilhar melhorias

---

**Framework limpo, focado e pronto para produção! 🎉**

Versão: 3.0 (Clean Edition)
Data: 2026-02-27
Total de arquivos: 31 (era 108)
Redução: 71%
