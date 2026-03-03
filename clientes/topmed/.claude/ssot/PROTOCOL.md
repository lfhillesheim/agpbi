# SSOT Protocol for Agents and Skills

## Mandatory Protocol

ALL agents and skills MUST follow this protocol when reading or writing project data.

## READ Protocol

### 1. Always Start with Index
```javascript
// WRONG - Searching through files
const findMeasure = (name) => {
  // Scan all files... slow, error-prone
}

// RIGHT - Use index first
const findMeasure = (name) => {
  const index = loadContextIndex();
  const measureIds = index.artifacts.by_type.measure || [];
  for (const id of measureIds) {
    const artifact = getArtifact(id);
    if (artifact.name === name) return artifact;
  }
  return null;
}
```

### 2. Use Artifact IDs for References
```yaml
# WRONG - Referencing by name
related_to: ["Total Sales", "Customer Count"]

# RIGHT - Referencing by ID
related_to: ["uuid-1", "uuid-2"]
```

### 3. Parse Logs in Reverse Order
```yaml
# Most recent first - more efficient
# Stop when you find what you need
```

## WRITE Protocol

### 1. Check Before Create
```javascript
// Mandatory pre-write check
function createArtifact(type, name, data) {
  // Step 1: Check if exists
  const existing = findByTypeAndName(type, name);
  if (existing) {
    // Update existing, don't duplicate
    return updateArtifact(existing.id, data);
  }

  // Step 2: Create new with UUID
  const id = generateUUID();
  const artifact = { id, type, name, ...data };

  // Step 3: Append to log
  appendToLog('artifacts.log', artifact);

  // Step 4: Update index
  updateIndex(artifact);

  return artifact;
}
```

### 2. Append-Only, Never Overwrite
```yaml
# WRONG - Modifying log entries
sed -i 's/old/new/g' artifacts.log

# RIGHT - Appending correction
echo "- timestamp: ..., correction: ..." >> artifacts.log
```

### 3. Update Index Immediately
```javascript
// After any log write, update index
function updateIndexForArtifact(artifact) {
  const index = loadContextIndex();

  // Update by_type
  if (!index.artifacts.by_type[artifact.type]) {
    index.artifacts.by_type[artifact.type] = [];
  }
  index.artifacts.by_type[artifact.type].push(artifact.id);

  // Update by_phase
  if (!index.artifacts.by_phase[artifact.phase]) {
    index.artifacts.by_phase[artifact.phase] = [];
  }
  index.artifacts.by_phase[artifact.phase].push(artifact.id);

  // Save
  saveContextIndex(index);
}
```

## Quick Reference

| Action | Protocol |
|--------|----------|
| Find artifact | Check index → Get by ID → Return |
| Create artifact | Check exists → Create with UUID → Append → Update index |
| Update artifact | Get by ID → Append change → Update index |
| Change status | Get by ID → Append status change → Update index |
| Record decision | Generate UUID → Append to decisions.log → Update index |

## Validation

### Before Any Write
```yaml
validate():
  - [ ] .context/ exists and is writable
  - [ ] index.json is valid JSON
  - [ ] All referenced IDs exist
  - [ ] UUID is unique
  - [ ] No duplicate (same type+name+phase)
```

### After Any Write
```yaml
verify():
  - [ ] Log entry written successfully
  - [ ] Index updated successfully
  - [ ] Index is valid JSON
  - [ ] Entry is readable back
```

## Error Handling

```javascript
try {
  createArtifact(...);
} catch (error) {
  // Log error to changes.log
  appendToLog('changes.log', {
    timestamp: now(),
    change_type: 'error',
    description: error.message,
    changed_by: 'system'
  });
  throw error; // Re-throw for caller to handle
}
```

---

**Non-negotiable**: All agents and skills MUST implement this protocol.
