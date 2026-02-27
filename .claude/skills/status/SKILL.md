---
name: status
description: Check overall project status and progress
---

# Project Status Check

## Objective

Provide a comprehensive overview of the current project status across all phases.

## Check Process

### Phase 1: Vision Status
Check `01-vision/` for:

✅ **Complete** if all exist:
- contexto-cliente.md
- escopo.md
- stakeholders.md
- mapeamento-dados.md
- hipotese.md

⚠️ **In Progress** if some exist but not all

❌ **Not Started** if folder doesn't exist or is empty

### Phase 2: Validate Status
Check `02-validate/` for:

✅ **Complete** if all exist:
- analise-dados.md
- validacao-numeros.md
- wireframe.md
- riscos.md
- tecnica.md
- Go/No-Go decision documented

⚠️ **In Progress** if some exist but not all

❌ **Not Started** if folder doesn't exist or is empty

### Phase 3: Build Status
Check `03-build/` for:

✅ **Complete** if:
- PBIP project exists and opens without errors
- All documentation exists (tecnica, negocio, usuario)
- Checklist-entrega.md is complete

⚠️ **In Progress** if:
- PBIP project exists but incomplete
- Some documentation exists

❌ **Not Started** if folder doesn't exist or is empty

### Action Items Status
Check `05-atividades/` for:

- Total items: [count]
- By status:
  - Pending: [count]
  - In Progress: [count]
  - Completed: [count]
  - Blocked: [count]

- Overdue items: [list]
- High priority items: [list]

### Recent Meetings
Check `04-reunioes/` for:

- Last meeting date: [date]
- Total meetings: [count]
- Open action items from meetings: [count]

### Decisions Log
Check `06-decisoes/` for:

- Recent decisions: [list last 5]
- Pending decisions: [list]

## Output Format

```markdown
# Project Status Report

**Generated**: [YYYY-MM-DD HH:MM]
**Project**: [Name]

## Overall Status: [On Track / At Risk / Off Track]

## Phase Status

### Vision Phase
**Status**: ✅ Complete / ⚠️ In Progress / ❌ Not Started
**Progress**: [X% complete]

Completed:
- [x] Document 1
- [x] Document 2

Remaining:
- [ ] Document 3
- [ ] Document 4

### Validate Phase
**Status**: ✅ Complete / ⚠️ In Progress / ❌ Not Started
**Progress**: [X% complete]

Completed:
- [ ] Document 1
- [ ] Document 2

### Build Phase
**Status**: ✅ Complete / ⚠️ In Progress / ❌ Not Started
**Progress**: [X% complete]

Completed:
- [ ] Component 1
- [ ] Component 2

## Action Items

### High Priority
- [ ] [Item] - @Owner - Due: [Date] - [Status]

### Overdue
- [ ] [Item] - @Owner - Due: [Date] - OVERDUE

### Blocked
- [ ] [Item] - @Owner - Blocked by: [Blocker]

## Recent Activity

### Last Meeting
**Date**: [Date]
**Key Decisions**: [List]
**Action Items**: [Count]

### Recent Decisions
- [Decision 1] - [Date]
- [Decision 2] - [Date]

## Risks and Issues

### High Priority Risks
- [Risk] - [Mitigation] - [Owner]

### Active Blockers
- [Blocker] - [Impact] - [Owner]

## Next Steps

### This Week
1. [Step 1] - @Owner
2. [Step 2] - @Owner

### Next Sprint
1. [Step 1] - @Owner
2. [Step 2] - @Owner
```

## Recommendations

Based on status, provide:

1. **What's Working Well**
   - Positive observations
   - Milestones achieved

2. **Areas Needing Attention**
   - Bottlenecks identified
   - Risks materializing

3. **Immediate Actions Required**
   - Critical items
   - This week priorities

4. **Timeline Assessment**
   - On track?
   - Adjustments needed?

---

**Run this weekly** to keep project on track and stakeholders informed.
