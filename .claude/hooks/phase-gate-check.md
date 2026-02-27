# Phase Gate Hook

## Type
Pre-write / Pre-bash

## Description
Validates that all required documents exist before allowing transition to next project phase.

## Configuration

```json
{
  "phase_gates": {
    "vision_to_validate": {
      "required_documents": [
        "01-vision/contexto-cliente.md",
        "01-vision/escopo.md",
        "01-vision/stakeholders.md",
        "01-vision/mapeamento-dados.md",
        "01-vision/hipotese.md"
      ],
      "required_approvals": [
        "Escopo aprovado pelo cliente"
      ],
      "error_message": "❌ Não é possível ir para Validate sem completar o Vision. Documentos faltando: {missing}"
    },
    "validate_to_build": {
      "required_documents": [
        "02-validate/analise-dados.md",
        "02-validate/validacao-numeros.md",
        "02-validate/wireframe.md",
        "02-validate/riscos.md",
        "02-validate/tecnica.md"
      ],
      "required_approvals": [
        "Go/No-Go decision: GO"
      ],
      "error_message": "❌ Não é possível ir para Build sem completar o Validate. Documentos faltando: {missing}"
    }
  }
}
```

## Implementation

The hook should:
1. Check which phase the user is trying to transition from/to
2. Verify all required documents exist
3. Verify all required approvals are documented
4. Block the transition if requirements aren't met
5. Provide helpful error message with what's missing

## Usage

This hook automatically runs when:
- User runs `/validate` (checks Vision completeness)
- User runs `/build` (checks Validate completeness)
- User tries to create files in later phases without completing earlier ones
