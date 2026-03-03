---
name: agpbi-validar-modelo
description: Validate Power BI model for quality and best practices
---

# Validate Power BI Model

Run comprehensive quality checks on Power BI model.

## Checks Performed

### 1. Star Schema Compliance
- [ ] Fact tables contain only measures
- [ ] Dimension tables contain only attributes
- [ ] All relationships: 1:* from dimension to fact
- [ ] No circular dependencies

### 2. Measure Quality
- [ ] All measures have descriptions
- [ ] All measures have format strings
- [ ] No calculated columns for aggregations
- [ ] Error handling in place (DIVIDE, IFERROR)

### 3. Relationship Quality
- [ ] Proper cardinality (1:*)
- [ ] Cross-filter: Single direction (default)
- [ ] Bi-directional justified (if used)
- [ ] No inactive relationships without reason

### 4. Column Visibility
- [ ] Technical columns hidden (keys, IDs)
- [ ] Business columns visible
- [ ] No hidden measures (business metrics should show)

### 5. Documentation
- [ ] All tables have descriptions
- [ ] All measures have descriptions
- [ ] All columns have descriptions (where meaningful)

### 6. Performance
- [ ] Model size appropriate for license:
  - Pro: < 1GB
  - Premium Per User: < 100GB
  - Premium Capacity: < 100GB
- [ ] No high-cardinality columns in fact
- [ ] Query folding enabled (check Power Query)

## MCP Usage

```javascript
// Get model stats
model_operations(operation: "GetStats")

// List measures
measure_operations(operation: "List")

// List relationships
relationship_operations(operation: "List")

// List tables
table_operations(operation: "List")
```

## Output Format

```markdown
# Model Validation Report

## Score: X/100 - [Rating]

### ✅ Strengths
- [List]

### ⚠️ Issues Found
#### High Priority
1. [Issue] - [Recommendation]

#### Medium Priority
[Same format]

### 📊 Score Breakdown
| Area | Score | Notes |
|------|-------|-------|
| Star Schema | X/100 | |
| Measures | X/100 | |
| Relationships | X/100 | |
| Documentation | X/100 | |
| Performance | X/100 | |
```

## Critical Errors (Block Delivery)
- No fact tables identified
- Circular dependencies
- Measures without descriptions
- High cardinality in fact (performance risk)
