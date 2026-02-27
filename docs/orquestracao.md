# Guia de Orquestração AGPBI

> Como os agentes trabalham juntos automaticamente

## 🎯 Visão Geral

O AGPBI Framework usa **orquestração automática** onde agentes chamam skills e delegam tarefas sem que o usuário precise coordenar manualmente.

## Hierarquia de Agentes

```
┌─────────────────────────────────────┐
│  ORCHESTRATOR (Main Coordinator)    │
│  - Gerencia todo o projeto          │
│  - Delega para especialistas         │
│  - Garante gates de qualidade        │
└────────────┬────────────────────────┘
             │
    ┌────────┼────────┐
    │        │        │
┌───▼───┐ ┌─▼────┐ ┌─▼─────────┐
│Vision │ │Valid │ │  Build    │
│Agent  │ │Agent │ │Implementer│
└───────┘ └──────┘ └───────────┘
    │        │            │
    └────────┴────────────┘
         Skills chamadas
         automaticamente
```

## Fluxo Automático

### 1. Usuário solicita: "Criar dashboard vendas"

```
Orchestrator
  ↓
[Verifica estado]
  Vision: ❌ Vazio
  Validate: ❌ Vazio
  Build: ❌ Bloqueado
  ↓
[Nega request]
  "Precisamos começar pelo Vision"
  ↓
[Oferece]
  "Posso iniciar Vision agora? (/vision)"
```

### 2. Usuário aceita: "/vision"

```
Orchestrator
  ↓
[Delega] → Vision Discovery Agent
  ↓
Vision Agent
  ↓
[Executa] → Skill /vision
  ↓
  1. Interview com usuário
  2. Coleta informações
  3. Cria 5 documentos obrigatórios
  ↓
  ✅ Vision completo
  ↓
[Retorna] → Orchestrator
  ↓
Orchestrator
  ↓
[Verifica]
  Vision: ✅ Completo
  ↓
[Próximo passo]
  "Vision completo! Pronto para Validate.
   Posso iniciar Validate agora? (/validate)"
```

### 3. Usuário aceita: "/validate"

```
Orchestrator
  ↓
[Verifica gate]
  Vision documents: 5/5 ✅
  Escopo aprovado: ✅
  ↓
[Delega] → Validate POC Agent
  ↓
Validate Agent
  ↓
[Executa] → Skill /validate
  ↓
  1. Conecta nas fontes de dados
  2. Explora dados
  3. Valida números com negócio
  4. Cria wireframe
  5. Testa viabilidade técnica
  ↓
  ✅ Validate completo
  ↓
[Retorna] → Orchestrator
  ↓
Orchestrator
  ↓
[Verifica gate]
  Validate documents: 5/5 ✅
  Go decision: ✅
  ↓
[Próximo passo]
  "Validate completo! Go decision obtida.
   Pronto para Build.
   Posso iniciar Build agora? (/build)"
```

### 4. Usuário aceita: "/build dashboard_vendas"

```
Orchestrator
  ↓
[Verifica gate]
  Vision: ✅ Completo
  Validate: ✅ Completo
  Go decision: ✅
  ↓
[Delega] → Build Implementer Agent (TÉCNICO)
  ↓
Build Agent
  ↓
[Lê requisitos]
  - 02-validate/wireframe.md
  - 02-validate/analise-dados.md
  - 02-validate/tecnica.md
  ↓
[Executa 10 passos AUTOMATICAMENTE]
  ↓
  Passo 1: /inicializar-pbip dashboard_vendas
  Passo 2: /conectar-fonte (5x) + /criar-query-m (5x) + /otimizar-query (5x)
  Passo 3: /classificar-tabela (4x) + /criar-relacionamento (3x) + /esconder-colunas-tecnicas
  Passo 4: /criar-medida (15x)
  Passo 5: /criar-visual-bar (4x) + /criar-visual-line (2x) + /criar-visual-card (4x)
  Passo 6: /aplicar-tema
  Passo 7: /configurar-refresh
  Passo 8: (pula se não precisar RLS)
  Passo 9: /gerar-doc-tecnica + /gerar-doc-negocio + /gerar-manual-usuario
  Passo 10: /validar-modelo + /testar-medidas + /completar-checklist
  ↓
  ✅ Build completo
  ↓
[Retorna] → Orchestrator
  ↓
Orchestrator
  ↓
[Verifica gate]
  PBIP criado: ✅
  Documentação: ✅
  Checklist: ✅
  ↓
[Sucesso!]
  "Dashboard pronto! 🎉

   Localização: 03-build/projects/comercial/dashboard_vendas.pbip/

   Próximos passos:
   1. Abrir no Power BI Desktop
   2. Publicar no Service
   3. Treinar usuários"
```

## Skills Chamadas Automaticamente

### Durante Vision
O Vision Agent chama:
- `/vision` - Workflow principal
- Não usa outras skills (é um skill em si)

### Durante Validate
O Validate Agent chama:
- `/validate` - Workflow principal
- Skills internas para conectar, explorar, etc.

### During Build (ONDE A MÁGICA ACONTECE)

O Build Implementer Agent chama **automaticamente**:

| Skill | Quando | Quantas vezes |
|-------|--------|---------------|
| `/inicializar-pbip` | Passo 1 | 1x |
| `/conectar-fonte` | Passo 2 | Por cada fonte (3-10x) |
| `/criar-query-m` | Passo 2 | Por cada query (3-10x) |
| `/otimizar-query` | Passo 2 | Por cada query (3-10x) |
| `/classificar-tabela` | Passo 3 | Por cada tabela (4-8x) |
| `/criar-relacionamento` | Passo 3 | Por cada relacionamento (3-6x) |
| `/configurar-date-table` | Passo 3 | 1x |
| `/esconder-colunas-tecnicas` | Passo 3 | 1x |
| `/criar-medida` | Passo 4 | Por cada medida (10-30x) |
| `/criar-medida-ytd` | Passo 4 | Para YTD (3-5x) |
| `/criar-visual-bar` | Passo 5 | Por cada visual bar (3-5x) |
| `/criar-visual-line` | Passo 5 | Por cada visual line (2-4x) |
| `/criar-visual-card` | Passo 5 | Por cada card (3-6x) |
| `/criar-visual-matrix` | Passo 5 | Por cada matriz (1-3x) |
| `/configurar-drillthrough` | Passo 5 | Se necessário (2-4x) |
| `/aplicar-tema` | Passo 6 | 1x |
| `/configurar-refresh` | Passo 7 | 1x |
| `/configurar-gateway` | Passo 7 | Se necessário (0-1x) |
| `/configurar-rls` | Passo 8 | Se necessário (1-3x) |
| `/gerar-doc-tecnica` | Passo 9 | 1x |
| `/gerar-doc-negocio` | Passo 9 | 1x |
| `/gerar-manual-usuario` | Passo 9 | 1x |
| `/validar-modelo` | Passo 10 | 1x |
| `/testar-medidas` | Passo 10 | 1x |
| `/completar-checklist` | Passo 10 | 1x |

**Total típico**: 50-100 skills chamadas automaticamente em um único build!

## O Usuário Precisa Saber Disso?

**NÃO!** Essa é a beleza da orquestração.

### Usuário vê:
```
Você: /build dashboard_vendas

AGPBI: Vou construir o dashboard de vendas.
       [Trabalhando...]

       ✅ PBIP criado
       ✅ Dados carregados (5 fontes)
       ✅ Star Schema construído (4 tabelas)
       ✅ Medidas criadas (15 medidas)
       ✅ Visuais criados (12 visuais)
       ✅ Documentação completa

       Pronto! 🎉

       Local: 03-build/projects/comercial/dashboard_vendas.pbip/
```

### Por trás dos panos:
```
Build Agent:
  → /inicializar-pbip
  → /conectar-fonte (x5)
  → /criar-query-m (x5)
  → /otimizar-query (x5)
  → /classificar-tabela (x4)
  → /criar-relacionamento (x3)
  → /criar-medida (x15)
  → /criar-visual-bar (x4)
  → /criar-visual-line (x2)
  → /criar-visual-card (x4)
  → /aplicar-tema
  → /configurar-refresh
  → /gerar-doc-tecnica
  → /gerar-doc-negocio
  → /gerar-manual-usuario
  → /validar-modelo
  → /completar-checklist

Total: 60+ operações automáticas!
```

## Comandos Disponíveis

### Nível Orquestrador (Usuário usa)
- `/start` - Inicia novo projeto
- `/vision` - Fase Vision
- `/validate` - Fase Validate
- `/build` - Fase Build
- `/status` - Ver status
- `/transcrever-reuniao` - Processar reunião
- `/help` - Ajuda

### Nível Técnico (Agentes usam automaticamente)
- `/inicializar-pbip` - Iniciar PBIP
- `/conectar-fonte` - Conectar dados
- `/criar-query-m` - Criar transformação
- `/otimizar-query` - Otimizar M
- `/classificar-tabela` - Marcar fato/dimensão
- `/criar-relacionamento` - Criar relacionamento
- `/criar-medida` - Criar medida DAX
- `/criar-visual-*` - Criar visual
- `/configurar-rls` - Configurar segurança
- `/validar-modelo` - Validar qualidade
- E mais...

**Usuário pode chamar técnicas diretamente SE estiver na fase Build**, mas geralmente não precisa - o Build Agent faz tudo.

## Exemplo Completo de Conversa

```
Você: Preciso criar um dashboard de vendas para a Acme

AGPBI: Vou iniciar o projeto para Acme seguindo nossa metodologia.
       Fase 1: Vision (Discovery)

       [Vision Agent ativado]

       Vision Agent: Olá! Vou entender o contexto do projeto.
       Pergunta 1: Qual é o objetivo principal do dashboard?
       Você: Acompanhar vendas mensais por categoria de produto

       Vision Agent: Pergunta 2: Quais são as áreas de negócio envolvidas?
       Você: Comercial e Marketing

       [... entrevistas continues ...]

       Vision Agent: ✅ Vision completo!
       Criei 5 documentos:
       - 01-vision/contexto-cliente.md
       - 01-vision/escopo.md
       - 01-vision/stakeholders.md
       - 01-vision/mapeamento-dados.md
       - 01-vision/hipotese.md

       Próximo: Validar hipóteses (/validate)

Você: /validate

AGPBI: [Validate Agent ativado]
       Validando hipóteses...

       [Conecta nos dados, valida números, cria wireframe]

       Validate Agent: ✅ Validate completo!
       Validações:
       - Números validados com área de negócio ✅
       - Wireframe aprovado ✅
       - Performance OK ✅
       - GO decision obtida ✅

       Próximo: Construir dashboard (/build)

Você: /build dashboard_vendas

AGPBI: [Build Agent ativado - EXPERT TÉCNICO]

       Build Agent: Lendo requisitos...
       - Wireframe: 12 visuais, 3 páginas
       - Dados: 5 fontes, 4 tabelas
       - Medidas: 15 métricas

       Iniciando construção...

       Passo 1: ✅ PBIP criado
       Passo 2: ✅ Dados carregados (5 fontes)
       Passo 3: ✅ Star Schema (3 dimensões + 1 fato)
       Passo 4: ✅ Medidas criadas (15 medidas DAX)
       Passo 5: ✅ Visuais criados (12 visuais em 3 páginas)
       Passo 6: ✅ Design aplicado
       Passo 7: ✅ Refresh configurado (diário 06:00)
       Passo 8: ⏭️ RLS não necessário
       Passo 9: ✅ Documentação completa
       Passo 10: ✅ Qualidade verificada

       📊 Dashboard pronto!

       Local: 03-build/projects/comercial/dashboard_vendas.pbip/

       Próximos passos:
       1. Abrir no Power BI Desktop
       2. Verificar se tudo está OK
       3. Publicar no Power BI Service
       4. Treinar usuários

Você: Perfeito! Pode abrir no Desktop para mim

AGPBI: Abrindo...
       [Abre Power BI Desktop com o PBIP]

       Tudo funcionando! 🎉
       Model: ✅ Sem erros
       Medidas: ✅ Calculando corretamente
       Visuais: ✅ Renderizando
```

## Conclusão

A orquestração automática significa:
1. **Usuário não coordena** - Diz o que quer, framework cuida do resto
2. **Agentes sabem o que fazer** - Cada um é especialista em sua fase
3. **Skills são chamadas automaticamente** - Build Agent chama 50+ skills
4. **Qualidade garantida** - Gates em cada transição de fase
5. **Produtividade máxima** - 1 comando = dashboard completo

---

**O framework trabalha para você, não o contrário.** 🚀
