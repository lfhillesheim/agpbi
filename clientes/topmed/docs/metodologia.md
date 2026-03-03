# Metodologia Vision-Validate-Build

> Guia completo da metodologia AGPBI

## 📖 Índice

1. [Visão Geral](#visão-geral)
2. [Philosophy](#philosophy)
3. [Vision](#vision)
4. [Validate](#validate)
5. [Build](#build)
6. [Ciclos e Iterações](#ciclos-e-iterações)
7. [Governança](#governança)
8. [Métricas de Sucesso](#métricas-de-sucesso)

---

## Visão Geral

### O Problema que Resolvemos

Projetos de BI falham quando:
- Escopo não é claro
- Suposições não são validadas
- Build começa sem entender os dados
- Stakeholders não são engajados
- Documentação é feita depois (ou nunca)

### Nossa Solução

Uma metodologia em 3 fases que:
- **Força entendimento profundo** antes de construir
- **Valida hipóteses** rapidamente
- **Entrega qualidade** através de processos estruturados
- **Mantém governança** através de documentação obrigatória

### As 3 Fases

```
Vision          Validate        Build
  ↓               ↓               ↓
Entender      Validar        Construir
Definir        Testar         Documentar
Mapear         Decidir        Entregar
```

---

## Philosophy

### 1. Errar Rápido, Corrigir Mais Rápido

> "O fracasso é uma opção. Fazer errado é parte do processo."

- Não tenha medo de estar errado
- Tenha medo de descobrir tarde demais
- Valide cedo, valide sempre
- Documente o que não funcionou

### 2. Agilidade com Qualidade

> "Rápido não significa descuidado."

- Processos enxutos, não ausentes
- Documentação essencial, não exaustiva
- Iterações curtas, não impulsivas
- Entregas completas, não perfeitas

### 3. Humanos no Comando

> "IA é uma ferramenta, não um substituto."

- Humanos definem escopo
- Humanos validam números
- Humanos tomam decisões
- IA acelera, não substitui

### 4. Documentação é Código

> "Se não está documentado, não existe."

- Documente enquanto constrói
- Documentação serve para humanos
- Template > criatividade em documentação
- Manter documentação é manter código

---

## Vision

### Objetivo

Entender profundamente o problema, o contexto, as pessoas e os dados antes de propor solução.

### Duração Típica

1-2 semanas (dependendo da complexidade)

### Atividades Principais

#### 1. Entrevistas com Stakeholders

**Quem entrevistar**:
- Sponsor (patrocinador)
- Ponto de contato principal
- Usuários finais
- Donos dos dados
- TI/Infraestrutura

**O que perguntar**:
- "Qual problema você está tentando resolver?"
- "Como você resolve isso hoje?"
- "Onde dói mais?"
- "Como o sucesso se parece?"
- "Quem mais precisamos envolver?"

#### 2. Mapeamento de Processos

**Como mapear**:
1. Sente com quem faz o trabalho
2. Observe o processo em ação
3. Documente passo a passo
4. Identifique where quebra
5. Mapeie as exceções

**O que documentar**:
- Entradas e saídas
- Sistemas utilizados
- Pessoas envolvidas
- Frequência e volume
- Dores e gargalos

#### 3. Inventário de Dados

**Fontes primárias**:
- ERP (SAP, Totvs, etc)
- CRM (Salesforce, etc)
- Planilhas
- Outros sistemas

**Para cada fonte**:
- O que contém
- Quem é o dono
- Qualidade dos dados
- Como acessar
- Frequência de atualização

#### 4. Definição de Escopo

**O que está IN**:
- Entregáveis claros
- Departamentos incluídos
- Fontes de dados
- Funcionalidades

**O que está OUT** (explicitamente):
- Deixar claro o que NÃO será feito
- Explicar por quê
- Definir quando pode ser incluído

#### 5. Análise de Stakeholders

**Mapeamento**:
- Interesse x Influência
- Papéis e responsabilidades
- Canais de comunicação
- Plano de engajamento

### Documentos Obrigatórios

#### contexto-cliente.md
- Visão geral do cliente
- Objetivos estratégicos
- Stack tecnológico
- Cultura de dados

#### escopo.md
- Deliverables
- Prazos
- Cronograma
- Riscos
- Critérios de sucesso

#### stakeholders.md
- Sponsor e time
- Pontos de contato
- Usuários finais
- Responsabilidades

#### mapeamento-dados.md
- Fontes de dados
- Qualidade
- Acessos
- Donos

#### hipotese.md
- Problema a resolver
- Solução proposta
- Arquitetura de alto nível
- Valor esperado

### Critérios de Saída

Vision está completo quando:
- [x] Todos os 5 documentos existem e estão completos
- [x] Escopo está aprovado pelo cliente
- [x] Stakeholders estão mapeados e engajados
- [x] Fontes de dados estão identificadas
- [x] Riscos estão documentados com mitigações
- [x] Hipótese está clara e testável

---

## Validate

### Objetivo

Validar rapidamente se a hipótese é viável através de POCs e testes.

### Duração Típica

1-2 semanas (rapid prototyping)

### Atividades Principais

#### 1. Conexão aos Dados

**Tarefas**:
- Estabelecer conexões
- Testar credenciais
- Configurar gateway (se necessário)
- Documentar parâmetros

**Validações**:
- Conexão funciona?
- Dados são acessíveis?
- Performance é aceitável?
- Limitações identificadas?

#### 2. Análise Exploratória

**O que fazer**:
- Listar todas as tabelas
- Verificar volumes
- Checar tipos de dados
- Identificar qualidade
- Encontrar problemas

**O que documentar**:
- Estrutura das tabelas
- Colunas e tipos
- Relacionamentos possíveis
- Problemas de qualidade
- Transformações necessárias

#### 3. Validação de Números

**Processo**:
1. Extraia amostra de dados
2. Calcule métricas chave manualmente
3. Compare com relatórios existentes
4. Valide com área de negócio
5. Documente discrepâncias

**Perguntas chave**:
- "Este número está correto?"
- "Como você sabe que está correto?"
- "O que significa este número?"
- "Como você usa este número?"

#### 4. Wireframe

**Como criar**:
- Comece simples (papel/caneta está OK)
- Foque no layout principal
- Defina páginas e visuais
- Mapeie a jornada do usuário

**Validação**:
- Apresente para stakeholders
- Colete feedback
- Itere se necessário
- Obtenha aprovação

#### 5. Testes Técnicos

**O que testar**:
- Performance de consulta
- Volume de dados
- Tempo de refresh
- Viabilidade de transformações
- Limitações do Power BI

### Documentos Obrigatórios

#### analise-dados.md
- Fontes conectadas
- Estrutura explorada
- Qualidade identificada
- Transformações necessárias

#### validacao-numeros.md
- Métricas validadas
- Aprovações obtidas
- Ajustes necessários

#### wireframe.md
- Layout proposto
- Visuais definidos
- Fluxo de navegação
- Feedback documentado
- Aprovação obtida

#### riscos.md
- Riscos técnicos
- Riscos de dados
- Riscos de adoção
- Mitigações propostas

#### tecnica.md
- Conexões testadas
- Viabilidade confirmada
- Stack definida
- Pré-requisitos identificados

### Go/No-Go Decision

### ✅ GO
- Números validados
- Viabilidade confirmada
- Stakeholders aprovam
- Riscos aceitáveis

### ⚠️ GO com Condições
- Validação com ressalvas
- Workarounds necessários
- Riscos gerenciáveis
- Plano de contingência

### ❌ NO-GO
- Números não batem
- Bloqueio técnico
- Stakeholders rejeitam
- Riscos muito altos

### Critérios de Saída

Validate está completo quando:
- [x] Todos os 5 documentos existem
- [x] Números foram validados com negócio
- [x] Wireframe foi aprovado
- [x] Viabilidade técnica está confirmada
- [x] Go/No-Go decision foi tomada

---

## Build

### Objetivo

Construir a solução final com qualidade, escalabilidade e documentação completas.

### Duração Típica

2-6 semanas (dependendo da complexidade)

### O Ciclo de 10 Passos

#### Passo 1: Conexão 🔌
- Configurar todas as fontes
- Testar credenciais
- Configurar gateway
- Documentar tudo

#### Passo 2: ETL (Power Query) 🔄
- Construir transformações
- Lidar com qualidade de dados
- Otimizar query folding
- Documentar passos

#### Passo 3: Modelagem Dimensional ⭐
- Criar Star Schema
- Definir fatos e dimensões
- Configurar tipos
- Esconder colunas técnicas

#### Passo 4: Relacionamentos 🔗
- Configurar cardinalidade
- Definir cross-filter direction
- Ativar/desativar
- Documentar lógica

#### Passo 5: Cálculos DAX 📊
- Criar todas as medidas
- Formatar tudo
- Documentar cada medida
- Lidar com erros

#### Passo 6: Visuais 📈
- Construir do wireframe
- Usar tipos apropriados
- Garantir acessibilidade
- Testar interações

#### Passo 7: Design UI/UX 🎨
- Aplicar tema consistente
- Seguir hierarquia visual
- Testar usabilidade
- Mobile se necessário

#### Passo 8: Orquestração ⏰
- Configurar refresh
- Setar incremental refresh
- Configurar monitoramento
- Documentar processo

#### Passo 9: Documentação 📚
- documentacao-tecnica.md
- documentacao-negocio.md
- manual-usuario.md
- rls.md (se necessário)
- gateway.md (se necessário)

#### Passo 10: Segurança 🔒
- Implementar RLS
- Testar roles
- Documentar setup
- Treinar usuários

### Documentos Obrigatórios

#### documentacao-tecnica.md
- Arquitetura do modelo
- Relacionamentos
- Medidas DAX
- Power Query
- Performance
- Configurações

#### documentacao-negocio.md
- Visão geral
- Como usar
- Métricas
- FAQ
- Glossário

#### manual-usuario.md
- Primeiro acesso
- Navegação
- Filtros
- Funcionalidades
- Troubleshooting

#### rls.md (se aplicável)
- Roles configuradas
- Gerenciamento
- Auditoria

#### gateway.md (se aplicável)
- Gateway setup
- Fontes de dados
- Refresh
- Monitoramento
- Manutenção

#### checklist-entrega.md
- Modelo
- Medidas
- Dados
- Visuais
- Documentação
- Testes
- Treinamento

### Critérios de Saída

Build está completo quando:
- [x] PBIP abre sem erros
- [x] Todas as medidas validadas
- [x] Performance aceitável
- [x] Documentação completa
- [x] Usuários treinados
- [x] Sign-off obtido

---

## Ciclos e Iterações

### Micro-iterações (Dentro de cada fase)

**Vision**:
- Entrevista → Documenta → Valida → Ajusta

**Validate**:
- Teste → Mede → Ajusta → Retesta

**Build**:
- Implementa → Testa → Refina → Documenta

### Macro-iterações (Entre fases)

**Vision → Validate**:
- Feedback do Validate ajusta Vision

**Validate → Build**:
- Aprendizados do Build alimentam próximos Validates

**Build → Próximo Projeto**:
- Lições aprendidas documentadas
- Templates melhorados
- Processos otimizados

### Quando Voltar Fase Anterior

**De Validate para Vision**:
- Escopo está incorreto
- Hipótese não é testável
- Stakeholders errados envolvidos

**De Build para Validate**:
- Números não batem
- Performance inaceitável
- Viabilidade técnica não confirmada

---

## Governança

### Gates (Portões)

**Vision → Validate**:
- 5 documentos obrigatórios
- Escopo aprovado
- Stakeholders engajados

**Validate → Build**:
- 5 documentos obrigatórios
- Números validados
- Go/No-Go decision

**Build → Entrega**:
- Checklist completo
- Testes passados
- Sign-off obtido

### Documentação Obrigatória

| Fase | Documentos | Status |
|------|------------|--------|
| Vision | 5 documentos | Todos obrigatórios |
| Validate | 5 documentos | Todos obrigatórios |
| Build | 6-7 documentos | Todos obrigatórios |

### Commits Padrão

```
<tipo>: <descrição> [tag-AI]

[Corpo detalhado]

AI-assisted: <descrição>
```

**Tipos**:
- vision
- validate
- build
- docs
- fix
- refactor
- test

### Revisões

**Revisão de Pares**:
- Todo código é reviewado
- Humano aprova, IA sugere
- Documentos também são reviewados

**Revisão com Cliente**:
- Vision: Escopo e hipótese
- Validate: Wireframe e números
- Build: Sistema completo

---

## Métricas de Sucesso

### Métricas de Projeto

**Velocidade**:
- Vision: 1-2 semanas
- Validate: 1-2 semanas
- Build: 2-6 semanas

**Qualidade**:
- Zero bugs críticos em produção
- Documentação 100% completa
- Satisfação do cliente > 4/5

**Previsibilidade**:
- 80% dos projetos dentro do prazo
- 90% dentro do orçamento

### Métricas de Produto

**Adoção**:
- > 80% de usuários ativos
- Uso semanal ou mais frequente

**Performance**:
- Carregamento < 5 segundos
- Refresh dentro da janela

**Valor**:
- KPIs melhoraram conforme meta
- ROI positivo em 6 meses

---

## Próximos Passos

1. **Practice**: Faça um projeto piloto
2. **Learn**: Estude as skills e agentes
3. **Customize**: Adapte para sua realidade
4. **Share**: Contribua com melhorias

**Leia também**:
- [Guia de Início Rápido](guia-inicio-rapido.md)
- [Melhores Práticas](melhores-praticas.md)
- [CLAUDE.md](../CLAUDE.md)
