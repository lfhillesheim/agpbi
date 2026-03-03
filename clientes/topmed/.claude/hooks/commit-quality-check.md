# Commit Quality Check Hook

## Type
Pre-commit

## Description
Ensures commit messages follow project conventions and files are properly documented.

## Configuration

```json
{
  "commit_conventions": {
    "allowed_types": [
      "vision",
      "validate",
      "build",
      "docs",
      "fix",
      "refactor",
      "test",
      "chore"
    ],
    "require_ai_tag": true,
    "ai_tags": ["[AI]", "[AI-minor]", "[AI-review]"],
    "min_description_length": 10
  },
  "file_checks": {
    ".pbip": {
      "require_description": "Power BI files should have descriptions",
      "check_measures": true
    },
    ".md": {
      "require_metadata": true,
      "metadata_fields": ["Última atualização", "Responsável"]
    }
  }
}
```

## Commit Message Template

```
<tipo>: <descrição> [tag-AI]

[Corpo detalhado opcional]

[AI] - Assistência IA significativa (>50% código)
[AI-minor] - Assistência IA menor (<50%)
[AI-review] - IA usada apenas para code review
```

## Implementation

The hook should:
1. Check commit message format
2. Verify AI tag is present if AI was used
3. Check that modified files have proper documentation
4. For Power BI files, verify measures have descriptions
5. Provide specific feedback on what's wrong

## Usage

Runs automatically before every commit.

## Example

Good commit:
```
vision: documentar stakeholders do cliente [AI]

Mapeado todos os stakeholders com papéis e responsabilidades.

AI-assisted: Estrutura gerada pela IA, conteúdo validado por humano.
```

Bad commit (blocked):
```
update stuff
```

Error:
```
❌ Commit message não segue o padrão.
Esperado: <tipo>: <descrição> [tag-AI]
Tipos permitidos: vision, validate, build, docs, fix, refactor, test, chore
Tags obrigatórias: [AI], [AI-minor], ou [AI-review]
```
