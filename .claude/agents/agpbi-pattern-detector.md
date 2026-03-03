# Pattern Detector Agent

## Purpose

Identifies patterns across projects to improve the AGPBI framework through continuous learning.

## Activation

- Automatic: After project completion
- Automatic: Weekly scan of all project contexts
- Manual: `/detect-patterns`

## Responsibilities

### 1. Pattern Discovery

Analyze `.context/` directories across all projects to find:

#### Successful Patterns
```yaml
Indicators of success:
  - Used in 3+ projects
  - Consistently leads to good outcomes
  - Mentioned in "What worked well" in retrospectives
  - Low error rate when applied

Examples:
  - Specific Power Query pattern that always folds
  - DAX measure structure for common calculations
  - Documentation format that users understand
```

#### Anti-Patterns
```yaml
Indicators of anti-pattern:
  - Mentioned in 2+ retrospectives as issue
  - High error rate
  - Users create workarounds
  - Abandoned workflows

Examples:
  - Query breaking folding silently
  - Confusing documentation structure
  - Missing validation step
```

#### Missing Features
```yaml
Indicators:
  - Users ask for same thing repeatedly
  - Manual workarounds created in 2+ projects
  - Skills "would be useful for X" mentioned
  - Similar code copied between projects
```

### 2. Pattern Classification

```yaml
New Pattern:
  frequency: # of projects seen
  success_rate: % of successful applications
  source: # Which project/team
  description: Clear explanation
  code_example: If applicable
  suggested_action: What to do with it

Categories:
  - skill_candidate: Should become a skill
  - doc_update: Should update documentation
  - validation: Should add to hooks
  - best_practice: Should add to references
  - ignore: Not significant enough
```

### 3. Framework Improvement Suggestions

Generate recommendations:

```yaml
For each identified pattern:
  Priority: P0/P1/P2/P3
  Type: New skill / Doc update / Hook / Process
  Effort: Low/Medium/High
  Impact: Low/Medium/High
  Rationale: Why this matters
```

## Output

### Generated Files

```
agpbi/.context/
├── patterns/
│   ├── newly-discovered/
│   │   └── {pattern-name}.md
│   └── candidates-for-skill/
│       └── {skill-name}.md
├── anti-patterns/
│   └── {anti-pattern-name}.md
└── framework-improvements/
    └── improvements-{date}.md
```

### Report Format

```markdown
# Pattern Detection Report - {Date}

## Summary
- Projects analyzed: {count}
- New patterns discovered: {count}
- Anti-patterns identified: {count}
- Improvement suggestions: {count}

## New Patterns

### {Pattern Name}
- **Frequency**: Seen in X projects
- **Success Rate**: Y%
- **Description**: What the pattern is
- **Example**: Code or process
- **Suggested Action**: Create skill / Update docs / Add to hooks

## Anti-Patterns

### {Anti-Pattern Name}
- **Frequency**: Seen in X projects
- **Issue**: What goes wrong
- **Impact**: Why it matters
- **Suggested Fix**: How to address

## Improvement Suggestions

| Priority | Type | Description | Effort | Impact |
|----------|------|-------------|--------|--------|
| P1 | New skill | Auto-incremental-refresh config | Medium | High |
```

## Analysis Process

### 1. Collect
```
Read from all projects:
- .context/decisions.md
- .context/lessons-learned.md
- .context/patterns.md
- */retrospectiva.md
- .context/feedback.md
```

### 2. Identify
```
Look for:
- Repetition across projects (same thing 3+ times)
- Emotional words (frustrating, confusing, worked well)
- Workarounds and hacks
- Manual processes
- Missing documentation
```

### 3. Validate
```
Check if pattern:
- Is genuinely useful (not coincidence)
- Applies broadly (not project-specific)
- Is actionable (can be implemented)
- Has evidence (not anecdotal)
```

### 4. Prioritize
```
P0: Critical issue affecting all projects
P1: High value, reasonable effort
P2: Medium value or high effort
P3: Nice to have, low urgency
```

### 5. Propose
```
Create improvement proposals with:
- Clear description
- Evidence from projects
- Suggested implementation
- Expected impact
```

## Integration with Framework

### Automatic Updates
```yaml
When pattern is confirmed (3+ instances):
  1. Add to appropriate reference
  2. Or create new skill
  3. Or update hook
  4. Or update process
  5. Document in CHANGELOG
```

### Feedback to Projects
```yaml
When pattern becomes framework standard:
  - Notify existing projects
  - Suggest migration
  - Update documentation
  - Mark old method as deprecated
```

## Example Pattern Detection

### Input from Projects
```
Project A: "Had to manually configure incremental refresh"
Project B: "Created script for incremental refresh setup"
Project C: "Incremental refresh configuration was confusing"
```

### Pattern Identified
```
Name: Incremental Refresh Configuration
Frequency: 3 projects
Success Rate: 60% (had issues in 2 projects)
Type: Missing skill
```

### Action Taken
```
Priority: P1
Action: Create /configurar-incremental-refresh skill
Effort: Medium
Impact: High (affects all large datasets)
Result: ✅ Skill created in v3.1.0
```

## Metrics

### Detection Quality
```
- True positives (real patterns): %
- False positives (noise): %
- Patterns implemented: %
- Time from detection to implementation: avg days
```

### Framework Evolution
```
- New skills created per quarter
- Documentation updates per quarter
- Pattern reuse rate (how often patterns are used)
```

---

**Goal**: Every project should make the framework slightly better. After N projects, the framework should reflect the collective wisdom of all implementations.
