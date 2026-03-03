# Documentation Validator Hook

## Type
Pre-write (for .md files)

## Description
Ensures all markdown documents follow project documentation standards.

## Requirements

### All Documents Must Have
```yaml
---
Última atualização: YYYY-MM-DD
Responsável: Nome do responsável
Versão: X.X
---
```

### Vision Documents
- contexto-cliente.md: All sections filled
- escopo.md: Approved by client
- stakeholders.md: All stakeholders mapped
- mapeamento-dados.md: All data sources listed

### Validate Documents
- analise-dados.md: Data quality assessed
- validacao-numeros.md: Business sign-off
- wireframe.md: Visual mockup included
- riscos.md: All risks have mitigations
- tecnica.md: Feasibility confirmed

### Build Documents
- documentacao-tecnica.md: Complete architecture
- documentacao-negocio.md: Clear business language
- manual-usuario.md: Step-by-step instructions
- rls.md (if applicable): Roles defined
- gateway.md (if applicable): Configuration documented
- checklist-entrega.md: All items checked

## Configuration

```json
{
  "documentation_standards": {
    "require_metadata": true,
    "metadata_fields": [
      "Última atualização",
      "Responsável",
      "Versão"
    ],
    "min_content_length": 50,
    "language": "pt-BR",
    "formatting": {
      "headers": true,
      "lists": true,
      "tables": true
    }
  }
}
```

## Checks

### 1. Metadata Check
```markdown
✓ Última atualização: YYYY-MM-DD
✓ Responsável: Nome
✓ Versão: X.X
```

### 2. Structure Check
- Document has clear sections
- Headers follow hierarchy (H1 → H2 → H3)
- Lists and tables formatted correctly

### 3. Content Quality Check
- Not empty or placeholder text
- meaningful descriptions
- no TODO/FIXME in production docs
- links and references work

### 4. Phase-Specific Checks
Based on document type (Vision/Validate/Build)

## Implementation

```python
# Pseudocode
def validate_document(file_path):
    doc = read_file(file_path)

    # Check metadata
    if not has_metadata(doc):
        return error("Missing metadata header")

    # Check required fields
    for field in required_fields:
        if not doc.has(field):
            return error(f"Missing field: {field}")

    # Check structure
    if not has_proper_structure(doc):
        return warning("Document needs better structure")

    # Check phase-specific requirements
    phase = detect_phase(file_path)
    if not meets_phase_requirements(doc, phase):
        return error(f"Missing {phase} requirements")

    return success("Document validated")
```

## Example

### ✅ Valid
```markdown
# Contexto do Cliente

**Última atualização**: 2026-02-27
**Responsável**: João Silva
**Versão**: 1.0

## Visão Geral
[Complete content]
```

### ❌ Invalid
```markdown
# Contexto do Cliente

[No metadata]
[Empty sections]
```

Error:
```
❌ Document validation failed:
- Missing metadata: Última atualização, Responsável, Versão
- Empty section: "Visão Geral"
- Placeholder text: TODO
```

## Usage

Runs automatically when .md files are saved.
Can be bypassed with explicit flag for draft documents.
