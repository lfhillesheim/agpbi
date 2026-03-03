---
name: retrospectiva
description: Run retrospective at phase end to collect lessons learned and improve the framework
parameters:
  - name: phase
    description: Current phase (vision/validate/build)
    required: true
  - name: project_name
    description: Project or customer name
    required: true
---

# Retrospectiva de Fase

Conduza uma retrospectiva estruturada ao final de cada fase do projeto.

## Quando Executar

OBRIGATÓRIO ao finalizar cada fase:
- Vision → antes de iniciar Validate
- Validate → antes de iniciar Build
- Build → antes da entrega final

## Estrutura da Retrospectiva

### 1. O Que Funcionou Bem ✅

Liste coisas que:
- Ajudaram a entregar mais rápido
- Facilitaram o trabalho
- Foram surpreendentemente eficazes
- Devem ser repetidas

### 2. O Que Poderia Melhorar ⚠️

Liste coisas que:
- Causaram bloqueios ou delays
- Foram confusas ou complicadas
- Precisaram de workarounds
- Podem ser otimizadas

### 3. Surpresas 🤔

Liste:
- Coisas não previstas no escopo
- Problemas técnicos inesperados
- Mudanças de requisitos
- Dados diferentes do esperado

### 4. Lições Aprendidas 💡

Documente:
- Novos padrões descobertos
- Anti-padrões identificados
- Conhecimento específico do domínio
- Truques e hacks úteis

### 5. Action Items 📋

Para cada melhoria identificada:
| ID | Ação | Prioridade | Responsável |
|----|------|------------|-------------|
| R1 | Criar skill X | P0 | Framework |

## Template de Saída

```markdown
# Retrospectiva: {project} - {phase}

## Metadata
- **Data**: {YYYY-MM-DD}
- **Fase**: {vision/validate/build}
- **Duração**: {X dias/semanas}

## ✅ O Que Funcionou Bem

## ⚠️ O Que Poderia Melhorar

## 🤔 Surpresas

## 💡 Lições Aprendidas

## 📋 Action Items
```

## Arquivos Gerados

1. `{fase}/retrospectiva-{project}.md` - Retrospectiva específica
2. `.context/lessons-learned.md` - Acumulado do projeto
3. `.claude/feedback/patterns/` - Padrões para framework

## Integração com Framework

Os action items alimentam:
- Evolução do framework (novas skills, docs)
- Base de conhecimento (patterns, anti-patterns)
- CHANGELOG.md (mudanças implementadas)
- Próximos projetos (evitar repetir erros)

## Prioridades

| Prioridade | Descrição | Timeline |
|------------|-----------|----------|
| P0 | Crítico - bloqueia trabalho | Imediato |
| P1 | Alto - importante para próxima fase | 1 semana |
| P2 | Médio - melhoria de qualidade | Backlog |
| P3 | Baixo - nice to have | Quando possível |

---

**Lembrete**: Retrospectiva sem action items é apenas conversa. Cada item deve ter prioridade clara.
