---
name: agpbi-revisar-modelo
description: Review Power BI model for best practices, performance, and quality
---

# Power BI Model Review

## Objective

Perform comprehensive review of Power BI semantic model following Microsoft best practices.

## Review Process

### Step 1: Connect and Analyze

```javascript
// Connect to model
connection_operations(operation: "ListConnections")
model_operations(operation: "Get")
model_operations(operation: "GetStats")
```

### Step 2: Model Architecture Review

#### Star Schema Assessment
- [ ] **Fact tables contain measures only** (no descriptions)
- [ ] **Dimension tables contain attributes only** (no measures)
- [ ] **Clear fact/dimension classification**
- [ ] **Degenerate dimensions handled properly**
- [ ] **No snowflake** (unnecessary dimension hierarchies)

#### Relationships Review
```javascript
relationship_operations(operation: "List")
```

Check:
- [ ] **Cardinality is correct** (mostly 1:* from dim to fact)
- [ ] **Cross-filter direction is single** (unless bi-directional needed)
- [ ] **No inactive relationships without explanation**
- [ ] **Relationship paths are clear** (no ambiguity)
- [ ] **No circular dependencies**

### Step 3: Table and Column Review

```javascript
table_operations(operation: "List")
column_operations(operation: "List", tableName: "...")
```

For each table:
- [ ] **Proper data types** (Whole number, Text, Date, etc.)
- [ ] **Hidden technical columns** (keys, IDs)
- [ ] **Visible business columns** (descriptions, names)
- [ ] **All columns have descriptions**
- [ ] **No unnecessary columns** (remove if not used)

### Step 4: Measure Review

```javascript
measure_operations(operation: "List")
```

For each measure:
- [ ] **Has description** (what it calculates and why)
- [ ] **Has format string** (currency, percentage, etc.)
- [ ] **Uses proper DAX patterns**
- [ ] **No calculated columns for aggregations**
- [ ] **Error handling** (DIVIDE, IFERROR)
- [ ] **Variables used for clarity** (VAR, RETURN)

Check for anti-patterns:
- ❌ Calculated columns for aggregations
- ❌ FILTER on all tables (use iterator)
- ❌ Complex nested functions (use variables)
- ❌ Duplicate measures
- ❌ Unused measures

### Step 5: Performance Review

```javascript
model_operations(operation: "GetStats")
```

Check:
- [ ] **Model size is reasonable** (< 1GB for Pro)
- [ ] **High cardinality columns removed from fact**
- [ ] **Query folding in Power Query** (check queries)
- [ ] **No excessive bi-directional filters**
- [ ] **Calculated columns minimized**

### Step 6: Documentation Review

Check:
- [ ] **All tables have descriptions**
- [ ] **All columns have descriptions**
- [ ] **All measures have descriptions**
- [ ] **Relationships are documented**
- [ ] **Model has data dictionary**

### Step 7: Security Review (if applicable)

```javascript
security_role_operations(operation: "List")
```

Check:
- [ ] **RLS roles defined** (if needed)
- [ ] **Roles tested** (use GetEffectivePermissions)
- [ ] **No dynamic security vulnerabilities**
- [ ] **Roles documented**

## Scoring System

### Model Quality Score

Calculate score based on:

| Area | Weight | Score (0-100) | Weighted |
|------|--------|---------------|----------|
| Star Schema | 25% | | |
| Relationships | 20% | | |
| Measures | 25% | | |
| Documentation | 15% | | |
| Performance | 15% | | |
| **Total** | **100%** | | |

**Rating**:
- 90-100: Excellent
- 75-89: Good
- 60-74: Fair
- < 60: Needs Improvement

## Output Format

```markdown
# Power BI Model Review Report

**Model**: [Name]
**Date**: [YYYY-MM-DD]
**Reviewer**: [Agent]
**Overall Score**: [X/100] - [Rating]

## Executive Summary
[2-3 sentences on overall quality]

## Detailed Findings

### ✅ Strengths
- Strength 1
- Strength 2

### ⚠️ Issues Found

#### High Priority
1. **Issue Title**
   - **Category**: [Star Schema/Relationships/Measures/etc]
   - **Problem**: [Description]
   - **Impact**: [Why it matters]
   - **Recommendation**: [How to fix]
   - **Location**: [Table/Column/Measure]

#### Medium Priority
[Same format]

#### Low Priority
[Same format]

### 📊 Score Breakdown
| Area | Score | Notes |
|------|-------|-------|
| Star Schema | [X/100] | [Notes] |
| Relationships | [X/100] | [Notes] |
| Measures | [X/100] | [Notes] |
| Documentation | [X/100] | [Notes] |
| Performance | [X/100] | [Notes] |

## Recommendations

### Immediate Actions (This Week)
1. [Action] - [Why it matters]

### Short Term (This Sprint)
1. [Action] - [Why it matters]

### Long Term (Future Iteration)
1. [Action] - [Why it matters]

## Best Practices to Adopt
- Practice 1: [Description]
- Practice 2: [Description]

## References
- [Star Schema Design](../powerbi-modeling/references/STAR-SCHEMA.md)
- [DAX Best Practices](../powerbi-modeling/references/MEASURES-DAX.md)
- [Performance Tips](../powerbi-modeling/references/PERFORMANCE.md)
```

## Common Issues to Look For

### Star Schema Violations
- Fact tables with descriptive text
- Dimension tables with measures
- Multiple fact tables joined directly
- Bridge tables without proper handling

### Relationship Issues
- Many-to-many without bridge table
- Bi-directional filters causing ambiguity
- Inactive relationships without USERELATIONSHIP
- Circular dependency warnings

### Measure Anti-Patterns
```dax
// ❌ Bad: Calculated column for aggregation
Sales Amount = Sales[Quantity] * Sales[UnitPrice]

// ✅ Good: Measure
Total Sales = SUMX(Sales, Sales[Quantity] * Sales[UnitPrice])

// ❌ Bad: Complex without explanation
Total YTD = CALCULATE([Total], DATESYTD('Date'[Date]))

// ✅ Good: Clear with variables
Total YTD =
VAR CurrentDate = MAX('Date'[Date])
VAR YearStart = DATE(YEAR(CurrentDate), 1, 1)
RETURN
    CALCULATE(
        [Total Sales],
        DATESBETWEEN('Date'[Date], YearStart, CurrentDate)
    )
```

### Performance Issues
- High cardinality columns in fact tables
- Excessive bi-directional filters
- Calculated columns instead of measures
- No query folding in Power Query
- Unnecessary table scans

---

**Run this review** before any major release or when performance issues are suspected.
