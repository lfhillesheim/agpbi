# SSOT Validator Hook

## Type
Pre-write / Post-write

## Description
Validates that all writes follow SSOT protocol and prevents data loss/duplication.

## Pre-Write Validation

### Checks Before Any Write

```yaml
validate_write(operation, target, data):
  # 1. Check target exists and is writable
  if not writable(target):
    return error("Target not writable")

  # 2. If creating, check for duplicates
  if operation == "create":
    existing = find_by_type_name_phase(data.type, data.name, data.phase)
    if existing:
      return error("Duplicate exists. Use update instead.")

  # 3. If updating, verify reference exists
  if operation == "update":
    if not exists(data.artifact_id):
      return error("Referenced artifact not found")

  # 4. Validate UUID format
  if data.id and not valid_uuid(data.id):
    return error("Invalid UUID format")

  # 5. Validate references exist
  for ref in data.related_to:
    if not exists(ref):
      return error(f"Reference {ref} not found")

  # 6. Check index is valid
  if not valid_index():
    return error("Index is corrupted. Rebuild required.")

  return success("Write validated")
```

## Post-Write Verification

### Checks After Any Write

```yaml
verify_write(operation, result):
  # 1. Verify log entry exists
  if not entry_exists_in_log(result.log_entry):
    return error("Log entry not created")

  # 2. Verify index updated
  if not index_contains(result.artifact_id):
    return error("Index not updated")

  # 3. Verify data integrity
  loaded = load_artifact(result.artifact_id)
  if loaded != result.data:
    return error("Data corruption detected")

  # 4. Verify no duplicates created
  duplicates = find_duplicates(result.artifact_id)
  if duplicates:
    return error(f"{len(duplicates)} duplicates detected!")

  return success("Write verified")
```

## Index Validation

### Rebuild Corrupted Index

```yaml
rebuild_index():
  log("Rebuilding index from logs...")

  index = empty_index()

  # Parse all logs
  for log_file in ["artifacts.log", "decisions.log", "status.log", "changes.log"]:
    entries = parse_log(log_file)
    for entry in entries:
      index_add(entry, index)

  # Save
  save_index(index)

  # Validate
  if not valid_index(index):
    return error("Rebuilt index is still corrupted")

  return success("Index rebuilt")
```

## Duplicate Detection

### Find Duplicates

```yaml
find_duplicates(exclude_id):
  duplicates = []

  # Group by type+name+phase
  grouped = group_by(artifacts, ["type", "name", "phase"])

  # Find groups with >1 entry
  for group in grouped:
    if len(group) > 1:
      # exclude_id is the one we just created
      others = [a for a in group if a.id != exclude_id]
      if others:
        duplicates.extend(others)

  return duplicates
```

## Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| `SSOT_DUPLICATE` | Artifact already exists | Use update instead of create |
| `SSOT_MISSING_REF` | Referenced ID not found | Create reference first |
| `SSOT_INVALID_UUID` | UUID format invalid | Use v4 UUID format |
| `SSOT_INDEX_CORRUPT` | Index.json is invalid | Run rebuild_index() |
| `SSOT_NOT_WRITABLE` | Target file not writable | Check permissions |
| `SSOT_DATA_CORRUPT` | Written data doesn't match | Retry write |

## Configuration

```json
{
  "ssot": {
    "enabled": true,
    "strict_mode": true,
    "auto_rebuild": true,
    "duplicate_check": "strict",
    "validate_refs": true
  }
}
```

## Usage in Hooks

### Pre-Write Hook
```yaml
When: Any file write operation
Check:
  - If writing to .context/ → run validate_write()
  - If creating artifact → check duplicates
  - If updating → verify references exists

Block if:
  - Duplicate detected
  - Invalid reference
  - Corrupted index
```

### Post-Write Hook
```yaml
When: After any file write operation
Check:
  - Log entry created
  - Index updated
  - No duplicates created

Alert if:
  - Verification fails
  - Duplicates detected
  - Index not updated
```

---

**Purpose**: Ensure SSOT protocol is followed. Prevent data loss and duplication.
