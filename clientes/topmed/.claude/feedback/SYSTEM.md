# AGPBI Feedback Loop System

## Overview

Este sistema garante que o framework AGPBI se auto-aperfeiçoe continuamente através de retroalimentação estruturada.

```
┌─────────────────────────────────────────────────────────────────┐
│                    FEEDBACK LOOP SYSTEM                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Uso ──▶ Coleta ──▶ Análise ──▶ Decisão ──▶ Ação ──▶ Melhoria   │
│   ▲                                                            │
│   └────────────────────────────────────────────────────────────┘
│                                                                  │
│  Contexto Histórico ──▶ Memória ──▶ Aprendizado ──▶ Evolução    │
└─────────────────────────────────────────────────────────────────┘
```

## Ciclo de Retroalimentação

### 1. COLETA (Collection)

#### Durante Execução
```yaml
Agentes registram:
  - Decisões tomadas
  - Alternativas consideradas
  - Assunções feitas
  - Bloqueios encontrados
  - Soluções aplicadas
```

#### Após Entrega
```yaml
Retrospectiva captura:
  - O que funcionou bem
  - O que poderia melhorar
  - Surpresas/inesperados
  - Lições aprendidas
  - Sugestões de mudanças
```

#### De Usuários
```yaml
Feedback direto:
  - Bugs encontrados
  - Confusões na documentação
  - Sugestões de features
  - Casos de uso não cobertos
```

### 2. ANÁLISE (Analysis)

#### Padrões de Uso
```yaml
Métricas coletadas:
  - Skills mais usados
  - Erros frequentes
  - Arquivos mais modificados
  - Tempo por etapa
  - Taxa de sucesso/falha
```

#### Anomalias
```yaml
Detectado quando:
  - Mesmo erro ocorre 3+ vezes
  - Workflow é abandonado
  - Documentação é insuficiente
  - Hook bloqueia sem motivo claro
```

#### Lacunas
```yaml
Identificado quando:
  - Usuário pede recurso não existente
  - Workaround é necessário
  - Documentação não cobre cenário
  - Skill não existe para necessidade
```

### 3. DECISÃO (Decision)

#### Categorias de Mudança

| Prioridade | Tipo | Exemplo |
|------------|------|---------|
| P0-Crítica | Bug fix | Hook bloqueando trabalho válido |
| P1-Alta | Missing feature | Skill necessário não existe |
| P2-Média | Documentation | Confusion on how to use X |
| P3-Baixa | Enhancement | Nice-to-have improvement |

#### Processo de Decisão
```yaml
1. Triagem:
   - Categorizar feedback
   - Avaliar impacto
   - Estimar esforço

2. Priorização:
   - P0: Imediato (bloqueia trabalho)
   - P1: Próxima sprint
   - P2: Backlog
   - P3: Quando possível

3. Aprovação:
   - Mudanças P0/P1: Auto-aprovadas
   - Mudanças P2: Revisão rápida
   - Mudanças P3: Discussão em retrospectiva
```

### 4. AÇÃO (Action)

#### Tipos de Ação

**Imediata (Hotfix)**
```yaml
Trigger: P0 bug
Timeline: < 24 horas
Examples:
  - Corrigir hook bloqueando
  - Fixar skill quebrado
  - Atualizar documentação errada
```

**Curto Prazo (Sprint)**
```yaml
Trigger: P1 feature
Timeline: 1-2 semanas
Examples:
  - Adicionar skill solicitado
  - Melhorar validação
  - Adicionar referência técnica
```

**Longo Prazo (Evolução)**
```yaml
Trigger: P2/P3
Timeline: Planejado
Examples:
  - Refatorar arquitetura
  - Adicionar nova metodologia
  - Melhorias de UX
```

### 5. MELHORIA (Improvement)

#### Atualização de Artefatos
```yaml
Quando mudança ocorre:
  1. Atualizar arquivo principal
  2. Atualizar referências
  3. Atualizar CHANGELOG
  4. Incrementar versão
  5. Notificar agentes (via system prompt)
```

#### Propagação de Conhecimento
```yaml
Aprendizado vira padrão quando:
  - Mesma solução aplicada 3+ vezes
  - Documentado em referência técnica
  - Skill criado para automatizar
  - Hook adiciona validação
```

## Gestão de Contexto

### 1. Contexto por Projeto
```
cliente-x/
├── .context/                # Contexto acumulado do projeto
│   ├── decisions.md         # Decisões tomadas
│   ├── lessons-learned.md   # Lições aprendidas
│   ├── patterns.md          # Padrões descobertos
│   └── feedback.md          # Feedback coletado
```

### 2. Contexto Global do Framework
```
agpbi/.context/
├── patterns/                # Padrões trans-projetos
├── anti-patterns/           # O que evitar
├── success-stories/         # Casos de sucesso
└── edge-cases/              # Casos especiais
```

### 3. Memória de Agentes
```yaml
Agents mantêm:
  session_context:
    project: cliente atual
    phase: Vision/Validate/Build
    decisions_recentes: []
    patterns_identificados: []
    issues_encontrados: []

  persistent_context:
    skills_que_falharam: []
    skills_que_sucederam: []
    documentação_confusa: []
    melhorias_sugeridas: []
```

## Sistema de Métricas

### Métricas de Qualidade
```yaml
Framework Health:
  - % de tarefas concluídas sem assistência extra
  - Tempo médio por etapa
  - % de retrospectivas com action items
  - % de feedback implementado

Documentation Health:
  - % de docs referenciados durante uso
  - Tempo para encontrar informação
  - % de perguntas sem resposta na doc

Skill Effectiveness:
  - % de uso sem erro
  - Tempo médio de execução
  - % de usuários que usariam novamente
```

### Métricas de Adoção
```yaml
Usage Patterns:
  - Skills mais usados por fase
  - Comandos mais frequentes
  - Arquivos mais acessados
  - Workflow típico

Anti-Patterns:
  - Hacks que as pessoas criam
  - Workarounds comuns
  - Features ignoradas
  - Documentação não lida
```

## Automatização da Retroalimentação

### Hooks de Feedback
```yaml
# .claude/hooks/feedback-collector.md
Tipo: Post-command

Coleta:
  - Command usado
  - Tempo de execução
  - Sucesso/Falha
  - Erros ocorridos
  - Sugestões do usuário

Salva em:
  - .context/metrics/usage.json
  - .context/patterns/identified.json
```

### Retrospectiva Automática
```yaml
# .claude/skills/retrospectiva/SKILL.md
Trigger: Fim de fase (Vision→Validate→Build)

Coleta:
  - O que deu certo
  - O que deu errado
  - O que melhorar
  - Action items

Gera:
  - build/retrospectiva-{fase}.md
  - Atualiza .context/lessons-learned.md
  - Sugere mudanças no framework
```

### Detecção de Padrões
```yaml
# .claude/agents/pattern-detector.md
Analisa:
  - .context/ de múltiplos projetos
  - Identifica padrões repetidos
  - Detecta anti-padres
  - Sugere criação de skill/referência

Output:
  - Proposta de melhoria do framework
  - Novo skill sugerido
  - Atualização de documentação
```

## Checklist de Implementação

### Fase 1: Fundamentos (P0)
- [ ] Estrutura .context/ criada
- [ ] Retrospectiva ao fim de cada fase
- [ ] Coleta de erros e bloqueios
- [ ] CHANGELOG.md implementado

### Fase 2: Coleta Ativa (P1)
- [ ] Hook de feedback-collector
- [ ] Skill de retrospectiva
- [ ] Métricas básicas coletadas
- [ ] Sistema de tickets/issues

### Fase 3: Análise Inteligente (P2)
- [ ] Pattern detector agent
- [ ] Análise de métricas
- [ ] Detecção de lacunas
- [ ] Recomendações automáticas

### Fase 4: Evolução Contínua (P3)
- [ ] Auto-atualização de documentação
- [ ] Geração de skills a partir de padrões
- [ ] Integração com referências externas
- [ ] Sistema de versão semântica

## Exemplo de Ciclo Completo

```
1. USO: Usuário usa /criar-medida em 5 projetos diferentes
   └─ Coletado em .context/metrics/usage.json

2. PADRÃO: Pattern detector identifica que 80% das vezes
   o usuário esquece de adicionar descrição
   └─ Gerada alerta em .context/patterns/missing-description.md

3. DECISÃO: Triagem classifica como P1 (alta prioridade)
   └─ Adicionado ao backlog

4. AÇÃO: Skill atualizado para requisitar descrição
   └─ Hook adicionado para validar

5. MELHORIA: CHANGELOG.md atualizado, versão incrementada
   └─ Próximos projetos beneficiam
```

---

**Princípio**: O framework deve ficar melhor a cada projeto, não apenas através de manutenção manual, mas através de aprendizado contínuo do uso real.
