---
name: agpbi-vision
description: Run the Vision stage - discovery, scope definition, and stakeholder mapping
parameters:
  - name: client_name
    description: Name of the client
    required: true
  - name: project_name
    description: Name of the project
    required: true
---

# Vision Stage Workflow

You are running the **Vision** stage for: **$client_name** - **$project_name**

## Objective

Conduct rapid discovery to deeply understand the client's problem, map stakeholders, identify data sources, and define clear scope.

## Phase 1: Information Gathering

Use AskUserQuestion to gather:

### 1. Client Context
- What is the client's business?
- Size and industry?
- Current data maturity?
- Strategic objectives?

### 2. Problem Understanding
- What problem are we solving?
- Where does it hurt?
- What's the impact (financial, operational)?
- How do they currently solve this?
- What's the root cause?

### 3. Stakeholders
- Who is the sponsor?
- Who is the main point of contact?
- Who will use the dashboard?
- Who validates the numbers?
- Who handles technical infrastructure?

### 4. Data Sources
- Where does the data live?
- What systems (ERP, CRM, etc.)?
- What format?
- How is data quality?
- Who owns the data?

### 5. Scope & Constraints
- What's in scope?
- What's explicitly out of scope?
- Timeline expectations?
- Budget constraints?
- Technical constraints?
- Risks and concerns?

## Phase 2: Document Creation

Create ALL mandatory documents in `01-vision/`:

1. **contexto-cliente.md** - Client overview and context
2. **escopo.md** - Clear scope definition with timelines
3. **stakeholders.md** - All people involved with roles
4. **mapeamento-dados.md** - Data sources mapping
5. **hipotese.md** - Proposed solution hypothesis

## Phase 3: Validation

Before completing Vision:

- [ ] Interviewed key stakeholders
- [ ] Mapped the end-to-end process
- [ ] Identified all data sources
- [ ] Understood the root problem (not just symptoms)
- [ ] Defined clear boundaries
- [ ] Documented all assumptions
- [ ] Got approval on scope

## Phase 4: Handoff to Validate

Only proceed to Validate when:
✅ All 5 documents are complete
✅ Scope is approved by client
✅ Data sources are mapped
✅ Stakeholders are engaged

---

**Remember**: A weak Vision leads to rework. Take the time to get it right.
