# Power BI Quality Check Hook

## Type
Pre-write (for .pbip files)

## Description
Validates Power BI model changes follow best practices before saving.

## Checks Performed

### 1. Measure Quality
```javascript
// For each new/modified measure:
- [ ] Has description
- [ ] Has format string
- [ ] Not a calculated column for aggregation
- [ ] Uses proper DAX patterns
```

### 2. Relationship Quality
```javascript
// For each relationship:
- [ ] Cardinality is correct (prefer 1:*)
- [ ] Cross-filter direction is SINGLE by default
- [ ] Bi-directional requires AIDEV-QUESTION anchor (STRICT)
- [ ] No circular dependencies
- [ ] Only one active path between tables
```

### 3. Table Quality
```javascript
// For each table:
- [ ] Proper data types
- [ ] Technical columns hidden (keys, IDs, audit)
- [ ] Business columns visible
- [ ] Table has description
- [ ] _Measures table exists (REQUIRED)
```

### 4. Star Schema Compliance
```javascript
// Check model structure:
- [ ] Fact tables contain measures only (or hidden)
- [ ] Dimension tables contain attributes only
- [ ] Relationships: 1:* from dimension to fact
- [ ] Single direction cross-filter (by default)
- [ ] No bi-directional without documentation
```

### 3. Table Quality
```javascript
// For each table:
- [ ] Proper data types
- [ ] Technical columns hidden
- [ ] Business columns visible
- [ ] Has description
```

### 4. Star Schema Compliance
```javascript
// Check model structure:
- [ ] Fact tables contain measures only (or hidden)
- [ ] Dimension tables contain attributes only
- [ ] Relationships: 1:* from dimension to fact
- [ ] Single direction cross-filter (by default)
- [ ] No bi-directional without documentation
```

### 5. Model Documentation (NEW - STRICT)
```javascript
// Validate all model objects are documented:
- [ ] All tables have descriptions
- [ ] All measures have descriptions
- [ ] All visible columns have descriptions
- [ ] All relationships documented (AIDEV-NOTE if unusual)
- [ ] Data lineage documented for fact tables
```

### 6. Critical Performance Checks (NEW - STRICT)
```javascript
// Performance anti-patterns that MUST be avoided:
- [ ] Auto Date/Time is DISABLED (Critical!)
- [ ] Query folding verified for source tables
- [ ] No bi-directional relationships without AIDEV-QUESTION
- [ ] Date table is explicit and marked
- [ ] No calculated columns on relationship keys
```

## Configuration

```json
{
  "quality_checks": {
    "strict_mode": false,
    "warnings_only": true,
    "critical_blocking": [
      "auto_date_time_enabled",
      "bidirectional_without_anchor",
      "circular_dependency"
    ],
    "auto_fix": {
      "hide_technical_columns": true,
      "add_format_strings": false
    }
  },
  "required_tables": [
    "_Measures"
  ],
  "exceptions": [
    "Technical explanation columns",
    "Legacy compatibility tables"
  ]
}
```

## Implementation

When a .pbip file is modified, the hook:
1. Uses Power BI Modeling MCP to analyze changes
2. Runs all quality checks
3. Reports warnings and errors
4. Optionally fixes minor issues automatically
5. Blocks save if critical issues found (in strict mode)

## MCP Tools Usage

```javascript
// Get model overview
model_operations(operation: "Get")

// Analyze new measures
measure_operations(operation: "List")

// Check relationships
relationship_operations(operation: "List")

// Validate model
// Custom validation logic using MCP tools
```

## Example Output

### ✅ All Good
```
✅ Power BI quality check passed
- 3 new measures with descriptions and formatting
- 2 new relationships configured correctly
- Star Schema maintained
```

### ⚠️ Warnings
```
⚠️ Power BI quality check: 3 warnings

1. Measure 'Total' has no description
   → Add: "Sum of all sales amounts"

2. Relationship 'Sales-Customer' uses bi-directional filter
   → STRICT VIOLATION: Add AIDEV-QUESTION anchor or change to single

3. Column 'CustomerKey' in Customer table is visible
   → Hide this technical column

4. Auto Date/Time is enabled
   → CRITICAL: Disable in File → Options → Data Load

5. _Measures table does not exist
   → REQUIRED: Create dedicated measures table

6. Table 'Sales' has no description
   → Add: "Transactional sales data with order details"
```

### ❌ Errors (strict mode)
```
❌ Power BI quality check: 4 critical errors - save blocked

1. Calculated column 'SalesAmount' should be a measure
   → Create measure instead: Total Sales = SUM(Sales[SalesAmount])

2. Circular dependency detected:
   Sales → Customer → Region → Sales
   → Review relationship configuration

3. Bi-directional relationship without AIDEV-QUESTION anchor
   → STRICT: Add documentation anchor or use CROSSFILTER in DAX

4. Auto Date/Time is enabled
   → CRITICAL: Disable in File → Options → Data Load → Auto Date/Time
```

## Usage

Runs automatically when .pbip files are saved.
