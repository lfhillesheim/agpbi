---
name: validate
description: Run the Validate stage - rapid POCs, data exploration, and hypothesis validation
parameters:
  - name: hypothesis
    description: The hypothesis to validate from Vision stage
    required: true
---

# Validate Stage Workflow

You are running the **Validate** stage for hypothesis: **$hypothesis**

## Pre-Flight Check

⚠️ **STOP** if Vision stage is not complete:
- [ ] contexto-cliente.md exists
- [ ] escopo.md exists
- [ ] stakeholders.md exists
- [ ] mapeamento-dados.md exists
- [ ] hipotese.md exists

If any are missing, run `/vision` first.

## Phase 1: Data Connection

1. **Connect to data sources**
   - Use Power BI Desktop or MCP tools
   - Test all connections from mapeamento-dados.md
   - Document connection parameters

2. **Explore data structure**
   - List all tables and columns
   - Check data types
   - Identify relationships
   - Assess data quality

## Phase 2: Data Analysis

1. **Exploratory analysis**
   - Check row counts and volumes
   - Look for nulls and duplicates
   - Identify data quality issues
   - Test key transformations

2. **Number validation**
   - Extract sample data
   - Calculate key metrics manually
   - Compare with existing reports
   - Validate with business stakeholders

## Phase 3: Technical Testing

1. **Performance testing**
   - Test refresh times
   - Check memory usage
   - Identify bottlenecks

2. **Feasibility assessment**
   - Can Power BI handle this volume?
   - Is DirectQuery or Import better?
   - Is Gateway needed?

## Phase 4: Wireframing

1. **Create mockup**
   - Sketch dashboard layout
   - Define pages and visuals
   - Map user journey

2. **Validate with stakeholders**
   - Present wireframe
   - Gather feedback
   - Iterate as needed

## Phase 5: Document Creation

Create ALL mandatory documents in `02-validate/`:

1. **analise-dados.md** - Exploratory analysis findings
2. **validacao-numeros.md** - Business validation results
3. **wireframe.md** - Dashboard mockup with approval
4. **riscos.md** - All risks with mitigations
5. **tecnica.md** - Technical feasibility assessment

## Phase 6: Go/No-Go Decision

Make the call:

### ✅ GO
- Numbers validated
- Technical feasibility confirmed
- Stakeholders approve direction
- Risks acceptable and mitigated

### ⚠️ GO WITH CONDITIONS
- Numbers validated with caveats
- Technical workarounds needed
- Stakeholder concerns addressed
- Risks managed

### ❌ NO-GO
- Numbers don't match
- Technical blockers exist
- Stakeholders reject approach
- Risks too high

## Phase 7: Handoff to Build

Only proceed to Build when:
✅ All 5 documents are complete
✅ Go/No-Go decision is made
✅ Stakeholders approved wireframe
✅ Technical approach is validated

---

**Remember**: Validate is your insurance policy. A week here saves a month of rework.
