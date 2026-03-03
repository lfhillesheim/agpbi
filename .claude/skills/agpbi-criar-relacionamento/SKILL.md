---
name: criar-relacionamento
description: Create table relationship following Star Schema
parameters:
  - name: from_table
    description: Dimension table name
    required: true
  - name: from_column
    description: Dimension column (usually key)
    required: true
  - name: to_table
    description: Fact table name
    required: true
  - name: to_column
    description: Fact column (foreign key)
    required: true
  - name: cross_filter_direction
    description: OneDirection or BothDirections
    required: false
    default: OneDirection
---

# Create Relationship

Create a table relationship following Star Schema best practices.

## Star Schema Rule
- **From**: Dimension table (the "one" side)
- **To**: Fact table (the "many" side)
- **Cardinality**: One-to-many (1:*)
- **Cross-filter**: Single direction (default)

## MCP Usage

```javascript
relationship_operations(
  operation: "Create",
  definitions: [{
    fromTable: "$from_table",
    fromColumn: "$from_column",
    toTable: "$to_table",
    toColumn: "$to_column",
    crossFilteringBehavior: "$cross_filter_direction"
  }]
)
```

## Example

**Input**:
```
from_table: DimCustomer
from_column: CustomerKey
to_table: FactSales
to_column: CustomerKey
cross_filter_direction: OneDirection
```

**Creates**:
- Relationship: DimCustomer → FactSales
- Cardinality: One-to-many
- Filter flow: DimCustomer filters FactSales
- Bi-directional: No (single direction)

## Best Practices
- ✅ Always 1:* from dimension to fact
- ✅ Use single direction unless bi-directional is justified
- ✅ Document why if using bi-directional
