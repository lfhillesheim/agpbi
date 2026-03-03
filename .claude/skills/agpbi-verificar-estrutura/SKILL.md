---
name: agpbi-verificar-estrutura
description: Verify all files are in correct locations following AGPBI structure
---

# Verify File Structure

Check if all files are in their correct locations according to AGPBI methodology.

## Expected Structure

```bash
00-contexto/          # 4 required files
01-vision/            # 5 required files
02-validate/          # 5 required files
03-build/             # Build phase + projects
04-reunioes/          # Meeting records
05-atividades/        # Activity tracking
06-decisoes/          # Decision log
```

## Process

1. **Scan all files recursively**
2. **Categorize each file by type**
3. **Check if in correct location**
4. **Flag misplaced files**
5. **Check for missing mandatory files**
6. **Generate report**

## Output

```markdown
# Estrutura de Arquivos - Verificação

## ✅ Files Correctly Placed (N)
[All files in correct locations]

## ⚠️ Misplaced Files (N)
- [file.md]
  Current: [location]
  Should be: [correct location]
  Type: [document type]

## ❌ Missing Mandatory Files (N)
- [file] - [why required]

## 🗑️ Temporary Files (N)
- [file] - Safe to delete
```
