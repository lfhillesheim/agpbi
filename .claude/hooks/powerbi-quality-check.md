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
- [ ] Cardinality is correct
- [ ] Cross-filter direction is appropriate
- [ ] No circular dependencies
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
- [ ] Fact tables contain measures only
- [ ] Dimension tables contain attributes only
- [ ] Relationships: 1:* from dimension to fact
- [ ] Single direction cross-filter (by default)
```

## Configuration

```json
{
  "quality_checks": {
    "strict_mode": false,
    "warnings_only": true,
    "auto_fix": {
      "hide_technical_columns": true,
      "add_format_strings": false
    }
  },
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
   → Consider using single direction unless needed

3. Column 'CustomerKey' in Customer table is visible
   → Hide this technical column
```

### ❌ Errors (strict mode)
```
❌ Power BI quality check: 2 critical errors - save blocked

1. Calculated column 'SalesAmount' should be a measure
   → Create measure instead: Total Sales = SUM(Sales[SalesAmount])

2. Circular dependency detected:
   Sales → Customer → Region → Sales
   → Review relationship configuration
```

## Usage

Runs automatically when .pbip files are saved.
