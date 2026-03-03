# AGPBI Framework - Consultoria de Dados Power BI

> **Metodologia**: Vision → Validate → Build
> **Foco**: Agilidade, Simplicidade, Qualidade

## Sobre Nossa Consultoria

Somos uma consultoria de dados 360° que trabalha com:
- **Dados**: Modelagem, qualidade, governança
- **Dashboards**: Power BI, visualização, storytelling
- **Automações**: Processos, pipelines, orquestração
- **Tecnologia**: Power BI (PBIP), DAX, Power Query, Gateway
- **Desenvolvimento**: Soluções escaláveis e robustas
- **Processos**: Discovery, mapeamento, otimização
- **Estratégia**: KPIs, insights, tomada de decisão
- **IA**: Agentes, automação, productividade

**Filosofia**: Errar rápido e arrumar. Iterações curtas. Feedback constante.

---

## Metodologia Vision-Validate-Build

### Vision 🔭
**Objetivo**: Discovery rápido e eficiente para entender o problema profundamente.

**Atividades**:
- Entender o processo, causa raiz, onde dói, onde impacta
- Identificar KPI financeiro e stakeholders
- Mapear pessoas envolvidas e papéis
- Levantar sistemas, dados, acessos necessários
- Definir escopo, prazos e expectativas
- Identificar cliente final e usuários

**Inputs**:
- Transcrições de reuniões
- Documentos existentes
- Entrevistas com stakeholders

**Outputs** (OBRIGATÓRIOS para ir ao Validate):
- `vision/contexto-cliente.md` - Contexto completo do cliente
- `vision/escopo.md` - Escopo definido e aprovado
- `vision/stakeholders.md` - Pessoas e responsabilidades
- `vision/mapeamento-dados.md` - Fontes de dados mapeadas
- `vision/hipotese.md` - Hipótese do painel/solução

**Regra**: Validate SÓ pode começar quando todos os outputs do Vision estiverem completos.

---

### Validate ✓
**Objetivo**: POCs rápidas para validar hipóteses antes de construir.

**Atividades**:
- Conectar nas fontes de dados
- Explorar dados e identificar problemas
- Validar números com áreas de negócio
- Criar esboço/wireframe do dashboard
- Testar viabilidade técnica
- Identificar riscos e dependências

**Inputs**:
- Todos os documentos do Vision
- Acesso às fontes de dados
- Ambientes de desenvolvimento

**Outputs** (OBRIGATÓRIOS para ir ao Build):
- `validate/analise-dados.md` - Análise exploratória
- `validate/validacao-numeros.md` - Validação com negócio
- `validate/wireframe.md` - Esboço do dashboard
- `validate/riscos.md` - Riscos identificados e mitigados
- `validate/tecnica.md` - Viabilidade técnica confirmada

**Regra**: Build SÓ pode começar quando a hipótese estiver validada.

---

### Build 🔨
**Objetivo**: Construção escalável e técnica do produto final.

**Atividades**:
- Modelagem dimensional (Star Schema)
- ETL e Power Query
- Relacionamentos e DAX
- Visuais e storytelling
- Design UI/UX
- Documentação técnica e de negócio
- RLS (Row-Level Security)
- Gateway e atualização
- Treinamento de usuários

**Ciclo de Vida Power BI**:
1. **Conexão**: Fontes de dados, gateways, credenciais
2. **ETL**: Power Query, limpeza, transformação
3. **Modelagem**: Tabelas, relacionamentos, estrela
4. **Cálculos**: Medidas DAX, colunas calculadas
5. **Visuais**: Gráficos, filtros, interatividade
6. **Design**: Layout, cores, tipografia, UX
7. **Orquestração**: Atualização, monitoramento, alertas
8. **Documentação**: Técnica e de negócio
9. **Segurança**: RLS, permissões, auditoria
10. **Treinamento**: Usuários, adoção, feedback

**Outputs** (OBRIGATÓRIOS para entrega):
- `build/modelo-semantico/` - Arquivos .pbip
- `build/documentacao-tecnica.md` - Documentação completa
- `build/documentacao-negocio.md` - Guia de uso do negócio
- `build/manual-usuario.md` - Manual do usuário final
- `build/rls.md` - Configuração de segurança (se aplicável)
- `build/gateway.md` - Configuração de atualização
- `build/checklist-entrega.md` - Checklist de qualidade

---

## Estrutura de Repositório por Cliente

Cada cliente terá seu próprio repositório, clonado a partir deste template.

```
cliente-x/
├── .claude/              # Configurações específicas do cliente
├── 00-contexto/          # Contexto permanente do cliente
│   ├── cliente.md        # Overview do cliente
│   ├── tecnologia.md     # Stack tecnológico
│   ├── pessoas.md        # Equipe e contatos
│   └── processos.md      # Processos mapeados
├── 01-vision/            # Discovery e escopo
├── 02-validate/          # Validações e POCs
├── 03-build/             # Implementação
│   └── projects/         # Projetos PBIP por departamento
│       ├── financeiro/
│       ├── vendas/
│       └── marketing/
├── 04-reunioes/          # Transcrições e resumos
├── 05-atividades/        # Gestão de tarefas e prazos
├── 06-decisoes/          # Decision points e aprovações
└── docs/                 # Documentação adicional
```

---

## Padrões de Código

### Power BI (PBIP)
- **Modelo**: Star Schema obrigatório
- **Naming**: Human-readable (`Customer Name` não `CUST_NM`)
- **Documentação**: Todas as tabelas, colunas e medidas com descrições (OBRIGATÓRIO)
- **Medidas**: Sempre usar medidas DAX, nunca colunas calculadas para agregações
- **Tabela _Measures**: Tabela dedicada de medidas OBRIGATÓRIA em todos os modelos
- **Relacionamentos**: One-to-many, **SINGLE direction obrigatório** (bi-direcional requer AIDEV-QUESTION)
- **Esconder**: Chaves técnicas e IDs (isHidden: true)
- **Tabela de Data**: Sempre explícita, marcada como Date Table
- **Auto Date/Time**: SEMPRE desabilitado (todos os modelos!)

### DAX
- **Formatação**: Sempre format string definido
- **Descrição**: O que a medida calcula e por quê
- **Performance**: Evitar medidas iterativas quando possível
- **DIVIDE**: Sempre usar DIVIDE() em vez de /
- **Variáveis**: Usar VAR para clareza e performance

### Power Query (M)
- **Query Folding**: Otimização MAIS importante - sempre verificar
- **Nomes**: Passos descritivos
- **Comentários**: Para transformações complexas
- **Filtros**: Aplicar o mais cedo possível (primeiro passo)
- **Colunas**: Remover não utilizadas imediatamente

---

## Anchor Comments

Use esses comentários no código para orientar agentes IA:

```dax
// AIDEV-NOTE: performance-critical; avoid iterators
// AIDEV-TODO: implement variable after POC approval
// AIDEV-QUESTION: why bidirectional here?
// AIDEV-ANSWER: historical: multiple fact tables need it
// AIDEV-FOLDING: Verify this step folds to source SQL
// AIDEV-LINEAGE: Source column is SourceTable.ColumnX
```

**Regras**:
- Sempre grep por `AIDEV-*` antes de editar
- Atualizar anchors ao modificar código
- NUNCA remover `AIDEV-NOTE` sem aprovação humana

---

## O Que Agentes IA NUNCA Devem Fazer

1. ❌ **Modificar arquivos de teste** - Testes codificam intenção humana
2. ❌ **Alterar contratos de API** - Quebra aplicações reais
3. ❌ **Modificar migrations** - Risco de perda de dados
4. ❌ **Fazer commit de secrets** - Use environment variables
5. ❌ **Assumir lógica de negócio** - Sempre perguntar
6. ❌ **Remover comentários AIDEV-*** - Eles existem por um motivo
7. ❌ **Alterar campos de RLS sem aprovação** - Segurança crítica
8. ❌ **Usar bi-direcional sem AIDEV-QUESTION** - Strict rule
9. ❌ **Criar modelo sem tabela _Measures** - Obrigatória
10. ❌ **Deixar Auto Date/Time habilitado** - Desligar SEMPRE

---

## Transcrições de Reunião

Quando colar uma transcrição no chat, use:

```
/transcrever-reuniao

Data: YYYY-MM-DD
Participantes: [lista]
Objetivo: [breve descrição]

[Transcrição colada aqui]
```

O agente vai:
1. Extrair action items
2. Identificar decisões tomadas
3. Mapear processos mencionados
4. Identificar gargalos
5. Criar resumo estruturado
6. Salvar em `04-reunioes/YYYY-MM-DD-resumo.md`

---

## Gestão de Atividades

Use `/status` para ver o status atual do projeto.

Atividades devem ter:
- **Título**: Claro e específico
- **Etapa**: Vision/Validate/Build
- **Responsável**: Quem está fazendo
- **Prazo**: Data prevista
- **Status**: pending/in_progress/completed/blocked
- **Dependências**: O que precisa estar pronto antes

---

## Sistema de Retroalimentação e Aprendizado

O framework AGPBI possui um sistema completo de feedback loop que garante melhoria contínua:

### Feedback Loop
```
Uso → Coleta → Análise → Decisão → Ação → Melhoria
```

### Retrospectiva Obrigatória
Ao final de cada fase (Vision/Validate/Build):
- Use `/retrospectiva` para documentar aprendizados
- Captura: o que funcionou, o que melhorar, lições, action items
- Gera: arquivos de retrospectiva + sugestões para o framework

### Pattern Detector
Analisa projetos para identificar:
- Padrões de sucesso (viram best practices)
- Anti-padrões (evitar em futuros projetos)
- Features faltantes (viram novos skills)

### Contexto Acumulado
```
projeto/.context/
├── lessons-learned.md    # Lições do projeto
├── decisions.md          # Decisões tomadas
└── patterns.md           # Padrões descobertos
```

### Evolução do Framework
- CHANGELOG.md rastreia todas as mudanças
- Versão semântica (Major.Minor.Patch)
- Action items de retrospectivas alimentam melhorias

**Princípio**: Cada projeto deve deixar o framework ligeiramente melhor do que foi encontrado.

---

## Versionamento

### Padrão de Commits

```
<tipo>: <descrição> [AI]

[opcional: descrição detalhada]

[AI] - Significa assistência IA significativa (>50% código)
[AI-minor] - Assistência IA menor (<50%)
[AI-review] - IA usada apenas para code review
```

**Tipos**:
- `vision` - Atividades de Discovery/escopo
- `validate` - Validações e POCs
- `build` - Implementação
- `docs` - Documentação
- `fix` - Bug fix
- `refactor` - Refatoração
- `test` - Testes (human-written only!)

### Branches

- `main` - Produção
- `vision/<nome>` - Discovery em andamento
- `validate/<nome>` - Validação em andamento
- `build/<nome>` - Implementação em andamento
- `hotfix/<nome>` - Correções urgentes

---

## Ferramentas MCP

### Power BI Modeling
- Conectar: `connection_operations(operation: "ListConnections")`
- Tabelas: `table_operations(operation: "List")`
- Medidas: `measure_operations(operation: "Create")`
- Relacionamentos: `relationship_operations(operation: "Create")`

### Sempre:
1. Listar antes de modificar
2. Analisar estado atual
3. Verificar best practices
4. Documentar mudanças

---

## Qualidade e Governança

### Checklist de Entrega

Antes de entregar qualquer projeto:

#### Requisitos OBRIGATÓRIOS
- [ ] Escopo aprovado e fechado
- [ ] Números validados com negócio

#### Modelo de Dados
- [ ] Modelo segue Star Schema
- [ ] Tabela _Measures existe (OBRIGATÓRIO)
- [ ] Todas as medidas em _Measures com display folders
- [ ] Auto Date/Time desabilitado (OBRIGATÓRIO)
- [ ] Tabela de Data explícita e marcada
- [ ] Relacionamentos single-direction (bi-direcional requer AIDEV-QUESTION)
- [ ] Chaves técnicas ocultas
- [ ] Query folding verificado para tabelas de origem

#### Documentação
- [ ] Todas as tabelas têm descrição
- [ ] Todas as medidas têm descrição
- [ ] Todas as colunas visíveis têm descrição
- [ ] Data lineage documentado para fact tables
- [ ] Documentação técnica completa
- [ ] Documentação de negócio clara

#### Performance e Operação
- [ ] Performance testada com dados representativos
- [ ] Incremental refresh configurado (se aplicável)
- [ ] RLS configurado (se necessário)
- [ ] Gateway configurado
- [ ] Atualização automatizada
- [ ] Deploy automatizado (CI/CD)

#### Usuário
- [ ] Manual do usuário final
- [ ] Usuários treinados
- [ ] Feedback coletado

### Code Review

Todo código deve ser reviewado:
- IA gera código
- Humano review e testa
- IA ajusta se necessário
- Humano aprova

---

## Referências

### Internas
- `_framework/methodology/` - Metodologia detalhada
- `_framework/governance/` - Regras e processos
- `_framework/references/` - Referências técnicas Power BI

### Externas
- [Best Practices Claude Code](https://code.claude.com/docs/en/best-practices)
- [Field Notes Vibe Coding](https://diwank.space/field-notes-from-shipping-real-code-with-claude)
- [Power BI Modeling Skill](https://skills.sh/github/awesome-copilot/powerbi-modeling)

---

## Comandos Principais

### Metodologia
- `/vision` - Iniciar etapa Vision
- `/validate` - Iniciar etapa Validate
- `/build` - Iniciar etapa Build
- `/status` - Ver status do projeto

### Técnico Power BI
- `/inicializar-pbip` - Criar estrutura PBIP
- `/criar-medida` - Criar medida DAX
- `/criar-relacionamento` - Criar relacionamento
- `/criar-calculation-group` - Criar calculation group (NOVO)
- `/configurar-rls` - Configurar RLS
- `/configurar-incremental-refresh` - Configurar incremental refresh (NOVO)
- `/otimizar-query` - Otimizar Power Query (query folding)
- `/deploy-pbip` - Deploy para Power BI Service (NOVO)

### Governança
- `/transcrever-reuniao` - Processar transcrição
- `/revisar-modelo` - Revisar modelo Power BI
- `/validar-modelo` - Validar modelo completo
- `/verificar-estrutura` - Validar estrutura de arquivos
- `/organizar-arquivos` - Organizar projeto
- `/auditoria-arquivos` - Auditoria completa

---

## A Regra de Ouro

**Quando não souber, SEMPERE pergunte.**

É melhor fazer 3 perguntas "boas" do que assumir algo errado e ter que refazer dias de trabalho.

Nossa consultoria preza por qualidade, confiança e transparência. Errar rápido é permitido. Entregar bugado não.

---

**Última atualização**: 2026-03-02
**Versão**: 3.1.0
**Framework**: AGPBI

---

## Novidades v3.1

### Novas Referências Técnicas
- **INCREMENTAL-REFRESH.md** - Configuração de atualização incremental
- **CALCULATION-GROUPS.md** - Calculation groups para DAX reutilizável
- **COMPOSITE-MODELS.md** - Modelos híbridos Import/DirectQuery
- **CICD-DEPLOYMENT.md** - CI/CD e deployment automatizado
- **PERSPECTIVES.md** - Perspectivas para organizar modelos
- **DATA-LINEAGE.md** - Rastreabilidade de dados

### Novos Skills
- `/configurar-incremental-refresh` - Configurar incremental refresh
- `/criar-calculation-group` - Criar calculation group
- `/deploy-pbip` - Deploy para Power BI Service

### Regras Atualizadas
- **Auto Date/Time**: Desabilitar SEMPRE (não só DirectQuery)
- **Bi-direcional**: Requer AIDEV-QUESTION obrigatório
- **Tabela _Measures**: OBRIGATÓRIA em todos os modelos
- **Query Folding**: Verificar folding para todas as fontes
- **Documentação**: Validada em hooks automaticamente
