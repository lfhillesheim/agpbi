---
name: limpar-temporarios
description: Clean up temporary and useless files
parameters:
  - name: dry_run
    description: Show what would be deleted without actually deleting
    required: false
    default: false
  - name: older_than_days
    description: Only delete temp files older than N days
    required: false
    default: 7
---

# Clean Temporary Files

Remove temporary, duplicate, and useless files from the project.

## Files to Delete

### Always Safe to Delete
- `*.tmp`, `*.temp`
- `*.bak`, `*.backup`
- `~$*` (Office temporary files)
- `.DS_Store`, `Thumbs.db`
- `*.log` (unless important)
- Files in `_temp/` older than 7 days

### Safe After Confirmation
- `*.swp`, `*.swo` (vim swap files)
- `*.cache`
- `__pycache__/` folders
- `.pytest_cache/`
- `.venv/` caches

### Requires Confirmation
- Duplicate files (same hash)
- Large files in unexpected locations
- Files with suspicious extensions

## Process

1. **Scan for temporary files**
   ```bash
   find . -type f \( -name "*.tmp" -o -name "*.temp" -o -name "*.bak" \)
   ```

2. **Check file age**
   ```bash
   find . -type f -mtime +7 -path "*_temp*"
   ```

3. **Find duplicates**
   ```bash
   fdupes -r . | head -100
   ```

4. **Categorize findings**
   - Delete immediately
   - Ask user
   - Archive instead

5. **Execute cleanup**
   - Delete files
   - Remove empty folders
   - Update .gitignore if needed

## Output

```markdown
# Limpeza de Arquivos Temporários

## 🗑️ Files Deleted (N)
- [file] - [reason]
- [file] - [reason]

## 📦 Files Archived (N)
- [file] → [archive location]

## 💾 Space Saved
- Before: [size]
- After: [size]
- Saved: [size]

## ⚠️ Warnings (if any)
- [warnings about files not deleted]
```

## Safety

- **NEVER** delete in `01-vision/`, `02-validate/`, `03-build/` unless explicit temp pattern
- **ALWAYS** show what will be deleted before deleting
- **ASK** for files over 10MB
- **PRESERVE** .pbip files (never delete)
- **RESPECT** .gitignore patterns
