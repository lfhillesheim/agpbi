---
name: organizar-arquivos
description: Automatically organize misplaced files into correct locations
parameters:
  - name: auto_confirm
    description: Auto-confirm moves without asking (use with caution)
    required: false
    default: false
---

# Organize Files

Automatically move misplaced files to their correct locations.

## Process

1. Run `/verificar-estrutura` to find misplaced files
2. For each misplaced file:
   - Determine correct location based on type
   - Create destination folder if needed
   - Move file
   - Update references if any
3. Rename files to follow naming convention
4. Generate summary

## File Type Detection

### By Name Pattern
- `cliente.md` → `00-contexto/`
- `tecnologia.md` → `00-contexto/`
- `pessoas.md` → `00-contexto/`
- `processos.md` → `00-contexto/`
- `escopo.md` → `01-vision/`
- `hipotese.md` → `01-vision/`
- `stakeholders.md` → `01-vision/`
- `mapeamento-dados.md` → `01-vision/`
- `contexto-cliente.md` → `01-vision/`
- `analise-dados.md` → `02-validate/`
- `validacao-numeros.md` → `02-validate/`
- `wireframe.md` → `02-validate/`
- `riscos.md` → `02-validate/`
- `tecnica.md` → `02-validate/`
- `documentacao-tecnica.md` → `03-build/`
- `documentacao-negocio.md` → `03-build/`
- `manual-usuario.md` → `03-build/`
- `checklist-entrega.md` → `03-build/`
- `ACT-*.md` → `05-atividades/`
- `DEC-*.md` → `06-decisoes/`
- `YYYY-MM-DD-*.md` → `04-reunioes/`

### By Content
- Read first 50 lines of markdown
- Detect document type from headers
- Categorize and move appropriately

## Example

**Input**: File `analise_vendas.txt` in root/

**Detection**:
- Content shows data analysis
- Phase: Validate
- Standard name: `analise-dados.md`

**Action**:
```bash
mv analise_vendas.txt 02-validate/analise-dados.md
```

## Output

```markdown
# Organização de Arquivos Completa

## Arquivos Movidos (N)
1. [source] → [destination]
2. [source] → [destination]

## Arquivos Renomeados (N)
1. [old] → [new]

## Pastas Criadas (N)
1. [folder]

## Score Anterior: XX/100
## Score Atual: YY/100
```
