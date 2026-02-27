---
name: criar-medida
description: Create a DAX measure with proper formatting and documentation
parameters:
  - name: table_name
    description: Target table name
    required: true
  - name: measure_name
    description: Measure name
    required: true
  - name: expression
    description: DAX expression
    required: true
  - name: format_string
    description: Format string (e.g., "$#,##0.00")
    required: false
    default: "#,##0"
  - name: description
    description: Business description
    required: false
---

# Create DAX Measure

Create a DAX measure following best practices.

## Best Practices
- Use explicit measures (not calculated columns)
- Use VAR for clarity
- Handle errors with DIVIDE
- Add descriptions
- Format properly

## MCP Usage

```javascript
measure_operations(
  operation: "Create",
  definitions: [{
    name: "$measure_name",
    tableName: "$table_name",
    expression: "$expression",
    formatString: "$format_string",
    description: "$description"
  }]
)
```

## Example

**Input**:
```
table_name: FactSales
measure_name: Total Sales
expression: SUM(FactSales[SalesAmount])
format_string: "$#,##0.00"
description: Sum of all sales amounts
```

**Output**:
```dax
Total Sales = SUM(FactSales[SalesAmount])
// Format: $#,##0.00
// Description: Sum of all sales amounts
```

## Validation
- Measure created without errors
- Format string applied
- Description added
