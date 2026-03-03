# AGPBI Framework Changelog

All notable changes to the AGPBI Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Pattern detector agent para identificar padrões de uso
- Auto-sugestão de skills baseado em contexto
- Métricas de uso coletadas automaticamente

## [3.1.0] - 2026-03-02

### Added
- **Novas Referências Técnicas** (6):
  - INCREMENTAL-REFRESH.md - Configuração de atualização incremental
  - CALCULATION-GROUPS.md - Calculation groups para DAX reutilizável
  - COMPOSITE-MODELS.md - Modelos híbridos Import/DirectQuery
  - CICD-DEPLOYMENT.md - CI/CD e deployment automatizado
  - PERSPECTIVES.md - Perspectivas para organizar modelos
  - DATA-LINEAGE.md - Rastreabilidade de dados

- **Novos Skills** (3):
  - /configurar-incremental-refresh - Configurar incremental refresh
  - /criar-calculation-group - Criar calculation group
  - /deploy-pbip - Deploy para Power BI Service

- **Sistema de Retroalimentação** (.claude/feedback/):
  - SYSTEM.md - Sistema de feedback loop
  - RETROSPECTIVA.md - Skill de retrospectiva
  - CHANGELOG.md - Este arquivo

### Changed
- **PERFORMANCE.md**: Auto Date/Time agora é CRITICAL para TODOS os modelos
- **PERFORMANCE.md**: Query Folding adicionado como seção principal
- **RELATIONSHIPS.md**: Bi-direcional agora é STRICT rule com AIDEV-QUESTION obrigatório
- **MEASURES-DAX.md**: Tabela _Measures agora é OBRIGATÓRIA
- **powerbi-quality-check.md**: Validações expandidas para incluir documentação e performance

### Rules (Breaking Changes)
- Auto Date/Time: Deve ser desabilitado SEMPRE (não só DirectQuery)
- Bi-direcional: Requer AIDEV-QUESTION anchor obrigatoriamente
- Tabela _Measures: Obrigatória em todos os modelos (não recomendada)
- Query Folding: Deve ser verificado para todas as fontes

## [3.0.0] - 2026-02-27

### Added
- Metodologia Vision-Validate-Build completa
- 6 Agentes especializados
- 20 Skills/workflows
- 5 Hooks de automação
- Template de estrutura por cliente

### Framework Structure
- .claude/agents/ - Orchestrator, Vision, Validate, Build, Meeting, File Governance
- .claude/skills/ - Skills organizados por categoria
- .claude/hooks/ - Phase gate, commit quality, file governance, PBI quality, docs
- templates/cliente/ - Estrutura padrão para novos projetos

## [2.0.0] - 2026-02-15

### Added
- Power BI Modeling MCP integration
- Referências técnicas (STAR-SCHEMA, MEASURES-DAX, PERFORMANCE, RELATIONSHIPS, RLS)
- Skills para modelagem Power BI

### Changed
- Melhor organização de skills
- Documentação expandida

## [1.0.0] - 2026-02-01

### Added
- Primeira versão do framework
- Metodologia básica
- Estrutura de repositório
- Padrões de código

## Format de Changelog

Cada entrada deve incluir:

### [Versão] - Data
- **Tipo**: Added/Changed/Deprecated/Removed/Fixed/Security
- **Descrição**: O que mudou e por quê
- **Impacto**: Quem é afetado (breaking change?)
- **Feedback**: Se originado de retrospectiva, citar

### Categorias de Mudança

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| Added | Novo recurso | Novo skill, referência, hook |
| Changed | Mudança em existente | Atualização de regra, melhoria |
| Deprecated | Recurso que será removido | Aviso de remoção futura |
| Removed | Recurso removido | Feature eliminada |
| Fixed | Bug corrigido | Correção de erro |
| Security | Issue de segurança | Vulnerabilidade corrigida |

### Níveis de Mudança

| Nível | Impacto | Exemplo |
|-------|---------|---------|
| Major | Breaking changes | Nova regra obrigatória |
| Minor | Novas features, backward compatible | Novo skill |
| Patch | Bug fixes, typos | Correção de documentação |

## Processo de Atualização

### 1. Identificar Necessidade
```
Origens:
- Retrospectiva (action item)
- Feedback de usuário
- Padrão identificado
- Atualização de best practices da Microsoft
```

### 2. Propor Mudança
```
Criar issue/proposta com:
- Descrição do problema
- Solução proposta
- Impacto estimado
- Nível de mudança (Major/Minor/Patch)
```

### 3. Implementar
```
- Fazer mudança
- Atualizar documentação relacionada
- Atualizar este CHANGELOG
- Incrementar versão
```

### 4. Comunicar
```
- Notificar em "Novidades" do CLAUDE.md
- Atualizar agentes sobre mudanças
- Documentar breaking changes
```

## Versionamento Semântico

```
MAJOR.MINOR.PATCH

MAIOR: Mudanças incompatíveis backward
MINOR: Funcionalidades backward-compatible
PATCH: Correções backward-compatible
```

Exemplos:
- 3.0.0 → 3.1.0: Novo skill (Minor)
- 3.1.0 → 4.0.0: Nova regra obrigatória (Major)
- 3.1.0 → 3.1.1: Bug fix (Patch)

---

**Princípio**: Toda mudança deve ser rastreável. Se você mudou algo, documente aqui.
