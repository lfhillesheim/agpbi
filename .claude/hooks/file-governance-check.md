# File Governance Hook

## Type
Pre-write / Pre-commit

## Description
Monitors file creation and ensures files are created in correct locations.

## Triggers

### When a file is created
1. **Check file name** and expected location
2. **Verify if location is correct**
3. **Warn if not** with suggestion
4. **Option to auto-move**

### When committing
1. **Check for temporary files** being committed
2. **Warn about large files**
3. **Check for misplaced files**

## Examples

### Warning on misplaced file

```markdown
⚠️ File Location Warning

You're creating "analise.md" in the root directory.

This appears to be a data analysis document.
Recommended location: 02-validate/analise-dados.md

Options:
1. Create in recommended location
2. Continue anyway (not recommended)
3. Cancel

Type 1, 2, or 3:
```

### Warning on temp file in commit

```markdown
⚠️ Commit Warning

About to commit temporary files:
- _temp/scratch.txt
- ~$documento.docx

These should be cleaned up first.

Run: /limpar-temporarios
Or: Add to .gitignore
```

## Configuration

```json
{
  "file_governance": {
    "enforce_structure": true,
    "warn_on_misplaced": true,
    "block_temp_commits": true,
    "auto_create_folders": true,
    "max_file_size_mb": 100
  }
}
```

## Implementation

The hook should:
1. Check file path against expected structure
2. Detect file type from name/content
3. Suggest correct location
4. Provide options to user
5. Update file location if approved
