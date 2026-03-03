# .context/ Template Structure

This is the Single Source of Truth (SSOT) structure for project data.

## ⚠️ CRITICAL RULES

1. **NEVER** modify log entries directly. Only append.
2. **ALWAYS** check index.json before creating anything.
3. **USE** UUIDs for all references, never names.
4. **UPDATE** index.json after every write.

## Directory Structure

```
.context/
├── decisions.log          # All decisions (append-only)
├── status.log             # All status changes (append-only)
├── artifacts.log          # All artifacts created (append-only)
├── changes.log            # All modifications (append-only)
├── lessons-learned.md     # Human-readable synthesis
├── index.json             # Quick lookup index
└── .backup/               # Automatic backups of index
```

## Log File Templates

### decisions.log
```yaml
---
# Decisions Log - Append Only
# NEVER modify existing entries

# Timestamp: ISO 8601
# Format: YAML
- timestamp: "2026-03-02T22:00:00Z"
  decision_id: "uuid-v4-here"
  phase: "vision"
  category: "scope"
  title: "Exclude inventory from initial scope"
  description: |
    Inventory module excluded from MVP. Will be included in Phase 2.
    Reason: Data source not ready, complex business logic not validated.
  made_by: "human"
  rationale: "Focus on sales-first MVP"
  alternatives_considered:
    - "Include partial inventory"
    - "Wait for inventory data"
  impact:
    - "Reduced timeline by 2 weeks"
    - "Simplified data model"
  related_artifacts: []
```

### status.log
```yaml
---
# Status Log - Append Only
# NEVER modify existing entries

- timestamp: "2026-03-02T22:00:00Z"
  event_id: "uuid-v4-here"
  entity_type: "phase"
  entity_id: "vision"
  old_status: "in_progress"
  new_status: "completed"
  reason: "All vision outputs completed"
  changed_by: "orchestrator-agent"
```

### artifacts.log
```yaml
---
# Artifacts Log - Append Only
# NEVER modify existing entries

- timestamp: "2026-03-02T22:00:00Z"
  artifact_id: "uuid-v4-here"
  artifact_type: "measure"
  name: "Total Sales"
  path: "_Measures/Total Sales"
  phase: "build"
  created_by: "criar-medida-skill"
  description: "Sum of all completed sales transactions"
  expression: "SUM(Sales[SalesAmount])"
  format_string: "$#,##0.00"
  related_to: []
  tags: ["revenue", "sales", "kpi"]
```

### changes.log
```yaml
---
# Changes Log - Append Only
# NEVER modify existing entries

- timestamp: "2026-03-02T22:00:00Z"
  change_id: "uuid-v4-here"
  artifact_id: "uuid-of-artifact"
  change_type: "update"
  description: "Updated measure description for clarity"
  old_value: "Sum of sales"
  new_value: "Sum of all completed sales transactions"
  changed_by: "human"
```

### index.json
```json
{
  "metadata": {
    "version": "1.0",
    "last_updated": "2026-03-02T22:00:00Z",
    "project": "project-name"
  },
  "decisions": {
    "by_phase": {
      "vision": ["uuid1", "uuid2"],
      "validate": ["uuid3"],
      "build": []
    },
    "by_category": {
      "scope": ["uuid1"],
      "technical": ["uuid2"],
      "business": []
    }
  },
  "artifacts": {
    "by_type": {
      "document": ["uuid4", "uuid5"],
      "pbip": ["uuid6"],
      "measure": ["uuid7", "uuid8", "uuid9"],
      "relationship": ["uuid10"]
    },
    "by_phase": {
      "vision": ["uuid4"],
      "validate": ["uuid5"],
      "build": ["uuid6", "uuid7", "uuid8", "uuid9", "uuid10"]
    },
    "by_tag": {
      "revenue": ["uuid7"],
      "sales": ["uuid7"],
      "kpi": ["uuid7"]
    }
  },
  "status": {
    "current_phase": "build",
    "phases": {
      "vision": "completed",
      "validate": "completed",
      "build": "in_progress"
    }
  },
  "lookup": {
    "artifacts_by_name": {
      "Total Sales": "uuid7",
      "Customer Count": "uuid8"
    }
  }
}
```

## Quick Start

### Initialize for New Project
```bash
# Create .context/ directory
mkdir -p .context/.backup

# Create empty log files
touch .context/decisions.log
touch .context/status.log
touch .context/artifacts.log
touch .context/changes.log

# Initialize index
cp templates/.context/index.json .context/index.json
```

### Adding to Project
```bash
# Copy this entire .context/ template to project root
cp -r templates/.context/ /path/to/project/.context/
```

## Usage Examples

### Agent: Create Artifact
```python
# 1. Check index for duplicates
index = load_json(".context/index.json")
if name in index["lookup"]["artifacts_by_name"]:
    return error("Already exists")

# 2. Create with UUID
artifact_id = generate_uuid()
artifact = {
    "artifact_id": artifact_id,
    "artifact_type": "measure",
    "name": "Total Sales",
    ...
}

# 3. Append to log
append_yaml(".context/artifacts.log", artifact)

# 4. Update index
index["artifacts"]["by_type"]["measure"].append(artifact_id)
index["lookup"]["artifacts_by_name"]["Total Sales"] = artifact_id
save_json(".context/index.json", index)
```

### Agent: Find Artifact
```python
# 1. Get ID from index
index = load_json(".context/index.json")
artifact_id = index["lookup"]["artifacts_by_name"].get("Total Sales")

if not artifact_id:
    return null

# 2. Get from log (search by ID)
artifact = find_in_log(".context/artifacts.log", artifact_id)
return artifact
```

## Maintenance

### Backup Index
```bash
# Before any major operation
cp .context/index.json .context/.backup/index.$(date +%s).json
```

### Rebuild Index (if corrupted)
```bash
# Parse all logs and rebuild
python -c "
from ssot import rebuild_index
rebuild_index('.context/')
"
```

---

**Remember**: This is the Single Source of Truth. If it's not here, it doesn't exist.
