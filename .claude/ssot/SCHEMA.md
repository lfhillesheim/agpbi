# Single Source of Truth (SSOT) System

## Problem Statement

> "How do we ensure artifacts, status changes, and project updates are never duplicated, lost, or stored in non-consultable places?"

## Solution: Unified Data Schema with SSOT Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGPBI SINGLE SOURCE OF TRUTH                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────┐    ┌────────────┐    ┌────────────┐            │
│  │   READ     │───▶│   INDEX    │◀───│   WRITE    │            │
│  │            │    │            │    │  (Validated)│            │
│  └────────────┘    └────────────┘    └────────────┘            │
│         │                 │                  │                   │
│         └─────────────────┴──────────────────┘                   │
│                           │                                      │
│                           ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    STORAGE LAYER                         │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  .context/              │ .framework/                     │  │
│  │  ├─ decisions.log       │ ├─ patterns/                   │  │
│  │  ├─ status.log          │ ├─ anti-patterns/              │  │
│  │  ├─ artifacts.log       │ └─ index/                      │  │
│  │  └─ changes.log         │                                │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Golden Rule

**Every piece of information has ONE and ONLY ONE place where it should be stored.**

## Storage Schema

### 1. PROJECT CONTEXT (.context/)

```
projeto/.context/
├── decisions.log          # ALL decisions (append-only)
├── status.log             # ALL status changes (append-only)
├── artifacts.log          # ALL artifacts created (append-only)
├── changes.log            # ALL changes made (append-only)
├── lessons-learned.md     # Synthesized (for humans)
└── index.json             # Quick lookup index
```

#### decisions.log
```yaml
format: append-only YAML
purpose: Record every decision made

structure:
  - timestamp: ISO 8601
    decision_id: unique_uuid
    phase: vision|validate|build
    category: scope|technical|business
    title: Short description
    description: Full context
    made_by: agent|human
    rationale: Why this decision
    alternatives_considered: []
    impact: What this affects
```

#### status.log
```yaml
format: append-only YAML
purpose: Complete audit trail of status changes

structure:
  - timestamp: ISO 8601
    event_id: unique_uuid
    entity_type: phase|task|artifact
    entity_id: identifier
    old_status: pending|in_progress|completed|blocked
    new_status: pending|in_progress|completed|blocked
    reason: Why changed
    changed_by: agent|human
```

#### artifacts.log
```yaml
format: append-only YAML
purpose: Every artifact created, never deleted

structure:
  - timestamp: ISO 8601
    artifact_id: unique_uuid
    artifact_type: document|pbip|measure|relationship
    name: Artifact name
    path: Full file path
    phase: vision|validate|build
    created_by: skill|agent|human
    related_to: [ids of related artifacts]
    tags: []
```

#### changes.log
```yaml
format: append-only YAML
purpose: Every modification to existing artifacts

structure:
  - timestamp: ISO 8601
    change_id: unique_uuid
    artifact_id: reference to artifacts.log
    change_type: create|update|delete|move
    description: What changed
    diff_summary: Brief summary
    changed_by: skill|agent|human
```

#### index.json
```json
{
  "last_updated": "ISO 8601",
  "decisions": {
    "by_phase": {
      "vision": ["uuid1", "uuid2"],
      "validate": ["uuid3"],
      "build": []
    },
    "by_category": {
      "scope": ["uuid1"],
      "technical": ["uuid2", "uuid3"],
      "business": []
    }
  },
  "artifacts": {
    "by_type": {
      "document": ["uuid1", "uuid2"],
      "pbip": ["uuid3"],
      "measure": ["uuid4", "uuid5", "uuid6"]
    },
    "by_phase": {
      "vision": ["uuid1"],
      "validate": ["uuid2"],
      "build": ["uuid3", "uuid4", "uuid5", "uuid6"]
    }
  },
  "current_status": {
    "phase": "build",
    "tasks": {
      "pending": ["task1", "task2"],
      "in_progress": ["task3"],
      "completed": ["task4", "task5"],
      "blocked": []
    }
  }
}
```

### 2. FRAMEWARE KNOWLEDGE (.framework/)

```
agpbi/.framework/
├── patterns/              # Proven patterns
│   └── {pattern-name}.md
├── anti-patterns/         # Proven anti-patterns
│   └── {anti-pattern}.md
├── index/
│   ├── patterns.index     # Searchable pattern index
│   ├── skills.index       # What each skill does
│   └── decisions.index    # Decision patterns
└── CHANGELOG.md           # Framework evolution
```

## WRITE Protocol

All agents and skills MUST follow this protocol when creating/updating data:

### Step 1: Check Existence
```yaml
Before creating ANY artifact:
  1. Search .context/index.json for similar artifacts
  2. Check if entity already exists
  3. If exists → UPDATE, don't duplicate
  4. If not exists → CREATE new
```

### Step 2: Append to Log
```yaml
Always APPEND, never overwrite:
  - decisions.log: Add new decision entry
  - status.log: Add new status entry
  - artifacts.log: Add new artifact entry
  - changes.log: Add new change entry
```

### Step 3: Update Index
```yaml
After any write:
  1. Update .context/index.json
  2. Update cross-references
  3. Update timestamps
```

## READ Protocol

All agents and skills MUST follow this protocol when reading data:

### Step 1: Check Index First
```yaml
Always start with index.json:
  - Fast lookup without parsing full logs
  - Get specific artifact IDs
  - Then read full details from logs
```

### Step 2: Use Artifact IDs
```yaml
Never search by name/path:
  - Use unique artifact_id from index
  - Prevents ambiguity
  - Survives renames/moves
```

### Step 3: Parse in Order
```yaml
Read logs in reverse chronological order:
  - Most recent first
  - Stop when found needed info
  - More efficient
```

## Anti-Duplication Rules

### Rule 1: Immutable IDs
```yaml
Every entity gets ONE immutable ID:
  - UUID v4 format
  - Assigned at creation
  - Never reused
  - Survives all changes
```

### Rule 2: Append-Only Logs
```yaml
Logs are NEVER modified:
  - New entries appended
  - Old entries never changed
  - Corrections: add new entry noting correction
  - Enables full audit trail
```

### Rule 3: Single Responsibility
```yaml
Each type of information has ONE home:
  - Decisions → decisions.log
  - Status → status.log
  - Artifacts → artifacts.log
  - Changes → changes.log

Never store the same info in two places.
```

### Rule 4: Reference by ID
```yaml
Cross-reference using IDs only:
  - decisions refer to artifact_ids
  - changes refer to artifact_ids
  - artifacts refer to decision_ids

Never duplicate content.
```

## Agent Integration

### When Agent Starts
```yaml
1. Load .context/index.json
2. Get current state
3. Know where everything is
4. Proceed with work
```

### During Agent Work
```yaml
For every action:
  1. Check index first (does this exist?)
  2. If yes → get ID and update
  3. If no → create new with UUID
  4. Append to appropriate log
  5. Update index
```

### When Agent Completes
```yaml
1. Final log entries written
2. Index updated
3. State persisted
4. Next agent can continue seamlessly
```

## Example: Complete Flow

### Scenario: Creating a DAX Measure

```yaml
1. Agent receives request: "Create Total Sales measure"
   └─ Check: Does this measure exist?
      └─ Search .context/index.json → Not found

2. Agent creates measure
   └─ Generate UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890

3. Agent appends to artifacts.log
   - timestamp: 2026-03-02T22:00:00Z
     artifact_id: a1b2c3d4-e5f6-7890-abcd-ef1234567890
     artifact_type: measure
     name: Total Sales
     path: _Measures/Total Sales
     phase: build
     created_by: criar-medida skill
     related_to: []

4. Agent appends to changes.log
   - timestamp: 2026-03-02T22:00:01Z
     change_id: b2c3d4e5-f6a7-8901-bcde-f12345678901
     artifact_id: a1b2c3d4-e5f6-7890-abcd-ef1234567890
     change_type: create
     description: Created DAX measure Total Sales
     changed_by: criar-medida skill

5. Agent updates .context/index.json
   {
     "artifacts": {
       "by_type": {
         "measure": ["a1b2c3d4-e5f6-7890-abcd-ef1234567890"]
       }
     }
   }

6. Next time someone asks for "Total Sales"
   └─ Index returns ID immediately
   └─ No duplicate created
   └─ Full history available
```

## Validation Hooks

### Pre-Write Validation
```yaml
All writes must pass:
  1. UUID is unique in logs
  2. Referenced IDs exist
  3. No duplicate artifacts (same name, same type, same phase)
  4. Index is updateable
  5. File path is writable
```

### Post-Write Verification
```yaml
After every write:
  1. Log entry successfully written
  2. Index successfully updated
  3. No corruption detected
  4. Referenced entries still accessible
```

## Recovery Procedures

### If Index is Corrupted
```yaml
Rebuild from logs:
  1. Parse all .log files
  2. Rebuild index.json
  3. Validate consistency
  4. Log recovery event
```

### If Log is Corrupted
```yaml
Partial recovery:
  1. Identify corrupted segment
  2. Quarantine (don't delete)
  3. Rebuild from other logs
  4. Mark gaps in index
```

## Implementation Checklist

- [ ] Create .context/ template with all log files
- [ ] Create .framework/ structure
- [ ] Implement SSOT validation in hooks
- [ ] Update all skills to use SSOT protocol
- [ ] Create index builder utility
- [ ] Create index validator
- [ ] Document for all agents

---

**Principle**: One place for everything. Everything findable. Nothing lost. No duplicates.
