# Retrospectiva Trigger Hook

## Type
Post-phase (automático ao completar fase)

## Description
Garante que uma retrospectiva seja conduzida ao final de cada fase do projeto.

## Triggers

### Automatic Triggers
```yaml
Vision → Validate:
  - Todos os outputs de Vision completos
  - Documento vision/escopo.md aprovado
  - Trigger: Solicitar retrospectiva antes de Validate

Validate → Build:
  - Todos os outputs de Validate completos
  - Go/No-Go aprovado
  - Trigger: Solicitar retrospectiva antes de Build

Build → Entrega:
  - Checklist de entrega completo
  - Documentação finalizada
  - Trigger: Solicitar retrospectiva final
```

## Checklist de Retrospectiva

Ao trigger ser ativado, verificar:

```yaml
Obrigatórios:
  - [ ] O que funcionou bem documentado
  - [ ] O que poderia melhorar documentado
  - [ ] Lições aprendidas identificadas
  - [ ] Action items criados com prioridade
  - [ ] Sugestões para o framework registradas

Opcionais:
  - [ ] Métricas de tempo coletadas
  - [ ] Bloqueios documentados
  - [ ] Surpresas registradas
```

## Output

### Arquivos Criados
```yaml
{fase}/retrospectiva-{project}.md:
  - Retrospectiva específica da fase
  - Action items com responsáveis
  - Data de conclusão

.context/lessons-learned.md:
  - Lições acumuladas do projeto
  - Padrões descobertos
  - Anti-padrões identificados

.claude/feedback/patterns/{pattern}.md:
  - Padrões que devem virar framework
  - Sugestões de novos skills
  - Melhorias de documentação
```

## Integration

### Com Pattern Detector
```yaml
Retrospectiva completa →
  Pattern detector analisa →
    Identifica padrões repetidos →
      Propõe melhorias do framework
```

### Com CHANGELOG
```yaml
Action items P0/P1 implementados →
  CHANGELOG.md atualizado →
    Versão do framework incrementada
```

## Mensagem ao Usuário

```
═══════════════════════════════════════════════════════════
  FASE {VISION/VALIDATE/BUILD} CONCLUÍDA!
═══════════════════════════════════════════════════════════

Antes de prosseguir, vamos fazer uma rápida retrospectiva.

Use: /retrospectiva phase={fase} project={projeto}

Ou responda:
1. O que funcionou bem nesta fase?
2. O que poderia melhorar?
3. Quais action items você propõe?

═══════════════════════════════════════════════════════════
```

## Exemplo de Fluxo

```
1. Usuário completa fase Vision
   └─ Hook detecta completion

2. Hook solicita retrospectiva
   └─ Mensagem exibida

3. Usuário responde ou usa /retrospectiva
   └─ Conteúdo capturado

4. Retrospectiva salva em 3 locais:
   ├─ vision/retrospectiva-{project}.md
   ├─ .context/lessons-learned.md
   └─ .claude/feedback/patterns/

5. Action items P0/P1 criados
   └─ Framework improved se aplicável

6. Próxima fase pode iniciar
   └─ Gate aberto
```

## Configuração

```json
{
  "retrospectiva": {
    "auto_trigger": true,
    "required_fields": [
      "worked_well",
      "could_improve",
      "lessons_learned",
      "action_items"
    ],
    "action_item_threshold": "P1",
    "pattern_threshold": 3
  }
}
```

---

**Princípio**: Cada fase ensina algo. O framework deve capturar esse aprendizado e aplicá-lo nos próximos projetos.
