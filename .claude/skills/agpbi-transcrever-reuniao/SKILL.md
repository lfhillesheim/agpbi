---
name: agpbi-transcrever-reuniao
description: Process meeting transcriptions and extract actionable insights
parameters:
  - name: date
    description: Meeting date (YYYY-MM-DD)
    required: true
  - name: participants
    description: List of participants with roles
    required: true
  - name: objective
    description: Meeting objective
    required: true
  - name: transcript
    description: The meeting transcription text
    required: true
---

# Meeting Transcription Processor

Processing meeting from **$date**

## Inputs
- **Date**: $date
- **Participants**: $participants
- **Objective**: $objective
- **Transcript**: $transcript

## Processing Steps

### Step 1: Extract Metadata
- Identify meeting type (Vision/Validate/Build/Status)
- List all participants with roles
- Determine meeting duration
- Capture meeting objective

### Step 2: Create Executive Summary
Write 2-3 paragraphs covering:
- What was discussed
- Key decisions made
- Main outcomes

### Step 3: Extract Action Items
For each action item found:
- What needs to be done
- Who is responsible
- What's the deadline
- What's the priority
- What dependencies exist

### Step 4: Document Decisions
For each decision made:
- What was decided
- Why (rationale)
- What it impacts
- Who approved
- When it takes effect

### Step 5: Map Processes
For each process mentioned:
- Current state
- Participants involved
- Systems used
- Pain points identified
- Improvement opportunities

### Step 6: Identify Bottlenecks
For each bottleneck/blocker:
- Description
- Impact level
- Root cause
- Proposed solution
- Owner
- Timeline to fix

### Step 7: Extract Data Insights
- Data sources mentioned
- KPIs/metrics discussed
- Data quality observations
- New data discovered

### Step 8: Update Stakeholder Info
- Who was present
- Who was absent (and should have been there)
- Interest levels
- Influence levels
- Overall sentiment

### Step 9: Document Risks and Issues
- New risks identified
- Existing issues status
- Proposed mitigations

### Step 10: Define Next Steps
- Short term (this week)
- Medium term (this sprint/month)
- Long term (future)

## Output

Create file: `04-reunioes/$date-resumo.md`

Include all sections from Steps 1-10 with proper formatting.

## Post-Processing Actions

After creating the summary:

1. **Update project files** based on decisions
2. **Create action items** in `05-atividades/`
3. **Update risks** in relevant phase documents
4. **Update scope** if scope changed
5. **Notify team** of critical decisions

---

**Quality Checklist**:
- [ ] All action items have owners and deadlines
- [ ] All decisions have clear rationale
- [ ] All risks have mitigations
- [ ] All stakeholders noted with roles
- [ ] File saved with correct naming
- [ ] Project documents updated
