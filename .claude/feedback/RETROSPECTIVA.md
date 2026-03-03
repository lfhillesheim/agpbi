---
name: retrospectiva
description: Run retrospective at end of each phase to collect lessons learned
parameters:
  - name: phase
    description: Current phase (vision/validate/build)
    required: true
  - name: project_name
    description: Project/customer name
    required: true
---

# Retrospectiva AGPBI

Skill para conduzir retrospectiva ao final de cada fase, capturando aprendizados e melhorias do framework.

## Quando Usar

OBRIGATÓRIO ao final de cada fase:
- Vision → antes de ir para Validate
- Validate → antes de ir para Build
- Build → antes da entrega final

## Estrutura da Retrospectiva

### 1. O Que Funcionou Bem ✅

Capturar:
- Processos que fluíram
- Skills úteis
- Documentação clara
- Padrões que funcionaram
- Ferramentas eficazes

### 2. O Que Poderia Melhorar ⚠️

Capturar:
- Bloqueios encontrados
- Confusões na documentação
- Skills faltantes
- Processos lentos
- Repetições desnecessárias

### 3. Surpresas e Inesperados 🤔

Capturar:
- Coisas não previstas
- Mudanças de escopo
- Problemas técnicos
- Resistência do cliente
- Dados diferentes do esperado

### 4. Lições Aprendidas 💡

Capturar:
- Padrões descobertos
- Anti-padrões identificados
- Conhecimento sobre domínio
- Truques e hacks
- Boas práticas específicas

### 5. Action Items 📋

Para cada item:
- [ ] O que fazer
- [ ] Responsável
- [ ] Prazo
- [ ] Prioridade (P0/P1/P2/P3)

## Template de Retrospectiva

```markdown
# Retrospectiva: {project_name} - {phase}

## Metadata
- **Data**: {YYYY-MM-DD}
- **Fase**: {vision/validate/build}
- **Participantes**: {lista}
- **Duração da fase**: {X dias/semanas}

## 1. O Que Funcionou Bem ✅

### Processos
-

### Skills/Ferramentas
-

### Documentação
-

## 2. O Que Poderia Melhorar ⚠️

### Bloqueios
-

### Confusões
-

### Faltas
-

## 3. Surpresas 🤔
-

## 4. Lições Aprendidas 💡

### Padrões Descobertos
-

### Anti-Padrões
-

### Conhecimento de Domínio
-

## 5. Action Items 📋

| ID | Ação | Responsável | Prazo | Prioridade |
|----|------|-------------|-------|------------|
| R1 | | | | P0 |

## 6. Sugestões para o Framework

### Novos Skills Necessários
-

### Atualizações de Documentação
-

### Mudanças de Processo
-
```

## Ciclo de Retroalimentação

```
Retrospectiva
    │
    ├─▶ .context/lessons-learned.md   # Acumulado do projeto
    │
    ├─▶ {fase}/retrospectiva.md       # Específico da fase
    │
    ├─▶ CHANGELOG.md                  # Se resultou em mudança
    │
    └─▶ Framework feedback            # Para evolução global
```

## Categorias de Action Items

### P0 - Crítico (Imediato)
- Bloqueia trabalho atual
- Bug no framework
- Documentação incorreta
- **Ação**: Corrigir antes de continuar

### P1 - Alto (Próxima fase)
- Falta feature importante
- Documentação confusa
- Processo ineficiente
- **Ação**: Implementar antes da próxima fase

### P2 - Médio (Backlog)
- Melhoria de UX
- Otimização de tempo
- Nice-to-have
- **Ação**: Adicionar ao backlog do framework

### P3 - Baixo (Sugestão)
- Idea para futuro
- Discussão conceitual
- Exploratório
- **Ação**: Registrar para discussão

## Exemplo de Retrospectiva

```markdown
# Retrospectiva: ClienteX Sales Dashboard - Validate

## Metadata
- **Data**: 2026-03-02
- **Fase**: Validate
- **Duração**: 2 semanas

## 1. O Que Funcionou Bem ✅

### Processos
- Wireframe em 1 dia funcionou bem
- Validação com negócio identificou erro cedo

### Skills
- /inicializar-pbip economizou tempo
- /criar-medida foi muito útil

## 2. O Que Poderia Melhorar ⚠️

### Bloqueios
- Query folding quebrou sem aviso claro
- Não sabia como verificar se estava folding

### Faltas
- Skill para configurar incremental refresh não existia
- Tivemos que fazer manualmente

## 3. Surpresas 🤔
- Fonte de dados mudou schema sem aviso
- Cliente queria analysis em tempo real (não estava no escopo)

## 4. Lições Aprendidas 💡

### Padrões
- Verificar query folding SEMPRE como primeira validação
- Testar com 10% dos dados antes de full load

### Anti-Padrões
- Não confiar em documentação de fonte de dados
- Não assumir que dados estão limpos

## 5. Action Items 📋

| ID | Ação | Responsável | Prazo | Prioridade |
|----|------|-------------|-------|------------|
| R1 | Criar skill incremental-refresh | Framework | 1 semana | P1 |
| R2 | Adicionar verificação de folding no validar-modelo | Framework | 1 semana | P1 |
| R3 | Documentar como detectar schema changes | Framework | 2 semanas | P2 |

## 6. Sugestões para o Framework

### Novos Skills
- /configurar-incremental-refresh
- /detectar-schema-change

### Documentação
- Adicionar seção de Query Folding em PERFORMANCE.md com exemplos visuais

### Processos
- Adicionar validação de schema como passo obrigatório no Validate
```

## Integração com o Framework

### Automatic Triggers
```yaml
# Acontece automaticamente:
- Ao finalizar fase Vision
- Ao finalizar fase Validate
- Ao finalizar fase Build
- Quando projeto é arquivado
```

### Manual Trigger
```bash
/retrospectiva phase=validate project=cliente-x
```

## Saída Gerada

### Arquivos Criados
```
{project}/
├── 01-vision/retrospectiva.md      # Ao fim do Vision
├── 02-validate/retrospectiva.md    # Ao fim do Validate
├── 03-build/retrospectiva.md       # Ao fim do Build
└── .context/lessons-learned.md     # Acumulado
```

### Framework Feedback
```
agpbi/.context/
├── feedback/projects/{project}/retrospectiva-{phase}.md
├── patterns/newly-discovered/
└── anti-patterns/identified/
```

## Medição de Sucesso

### KPIs
- % de projetos com retrospectiva completada
- % de action items implementados
- Tempo entre identificação e implementação
- Redução de erros repetidos entre projetos

### Meta
- 100% das fases com retrospectiva
- 80% dos action items P0/P1 implementados
- Zero erros repetidos após identificação

---

**Lembrete**: Retrospectiva sem action items é apenas conversa. Cada item deve ter dono, prazo e prioridade claros.
