# Relationships in Power BI

## Relationship Properties

### Cardinality
| Type | Use Case | Notes |
|------|----------|-------|
| One-to-Many (*:1) | Dimension to Fact | Most common, preferred |
| Many-to-One (1:*) | Fact to Dimension | Same as above, direction reversed |
| One-to-One (1:1) | Dimension extensions | Use sparingly |
| Many-to-Many (*:*) | Bridge tables, complex scenarios | Requires careful design |

### Cross-Filter Direction
| Setting | Behavior | When to Use |
|---------|----------|-------------|
| Single | Filters flow from "one" to "many" | Default, best performance |
| Both | Filters flow in both directions | Only when necessary |

## Best Practices

### 1. Prefer One-to-Many Relationships
```
Customer (1) --> (*) Sales
Product  (1) --> (*) Sales
Date     (1) --> (*) Sales
```

### 2. Use Single-Direction Cross-Filtering (STRICT RULE)

**⚠️ CRITICAL: Bidirectional relationships are almost always WRONG.**

```
Bidirectional filtering:
- Impacts performance negatively (2-10x slower queries)
- Can create ambiguous filter paths
- May produce unexpected results
- Makes model harder to understand and maintain
- Reduces query plan optimization
```

**STRICT POLICY: Single-direction ONLY, with documented exceptions.**

**Default behavior:**
```
Dimension (1) --[Single]--> (*) Fact
Filters flow FROM dimension TO fact only
```

**NEVER use bidirectional unless:**
1. You have a documented, approved reason
2. You've tried all alternatives (DAX CROSSFILTER, measure design)
3. You understand the performance impact
4. You've added an AIDEV-QUESTION anchor

**Documented exception process:**
```dax
// AIDEV-QUESTION: Why bidirectional here?
// AIDEV-ANSWER: Required for dimension-to-dimension analysis
// between Customer and Product through Sales. Alternative:
// Create explicit bridge table or use CROSSFILTER in specific measures.
// Performance impact: +30% query time on Customer-Product analysis.
```

**Better alternatives to bidirectional:**

1. **Use CROSSFILTER in specific measures:**
```dax
// Only affects this measure
Countries Sold To =
CALCULATE(
    DISTINCTCOUNT(Customer[Country]),
    CROSSFILTER(Customer[CustomerKey], Sales[CustomerKey], BOTH)
)
```

2. **Create bridge tables for dimension-to-dimension:**
```
Customer (1) --(*)--[CustomerProductBridge]--(*)-- Product (1)
```

3. **Redesign the model:**
```
// Instead of bidirectional, create:
CustomerSales (aggregate by customer)
ProductSales (aggregate by product)
// Then relate these as needed
```

### 3. One Active Path Between Tables
- Only one active relationship between any two tables
- Use USERELATIONSHIP for role-playing dimensions:

```dax
Sales by Ship Date = 
CALCULATE(
    [Total Sales],
    USERELATIONSHIP(Sales[ShipDate], Date[Date])
)
```

### 4. Avoid Ambiguous Paths
Circular references cause errors. Solutions:
- Deactivate one relationship
- Restructure model
- Use USERELATIONSHIP in measures

## Relationship Patterns

### Standard Star Schema
```
     [Date]
       |
[Product]--[Sales]--[Customer]
       |
   [Store]
```

### Role-Playing Dimension
```
[Date] --(active)-- [Sales.OrderDate]
   |
   +--(inactive)-- [Sales.ShipDate]
```

### Bridge Table (Many-to-Many)
```
[Customer]--(*)--[CustomerAccount]--(*)--[Account]
```

### Factless Fact Table
```
[Product]--[ProductPromotion]--[Promotion]
```
Used to capture relationships without measures.

## Creating Relationships via MCP

### List Current Relationships
```
relationship_operations(operation: "List")
```

### Create New Relationship
```
relationship_operations(
  operation: "Create",
  definitions: [{
    fromTable: "Sales",
    fromColumn: "ProductKey",
    toTable: "Product", 
    toColumn: "ProductKey",
    crossFilteringBehavior: "OneDirection",
    isActive: true
  }]
)
```

### Deactivate Relationship
```
relationship_operations(
  operation: "Deactivate",
  references: [{ name: "relationship-guid-here" }]
)
```

## Troubleshooting

### "Ambiguous Path" Error
Multiple active paths exist between tables.
- Check for: Multiple fact tables sharing dimensions
- Solution: Deactivate redundant relationships

### Bidirectional Not Allowed
Circular reference would be created.
- Solution: Restructure or use DAX CROSSFILTER

### Relationship Not Detected
Columns may have different data types.
- Ensure both columns have identical types
- Check for trailing spaces in text keys

## Validation Checklist

- [ ] All relationships are one-to-many where possible
- [ ] Cross-filter is single direction by default
- [ ] Only one active path between any two tables
- [ ] Role-playing dimensions use inactive relationships
- [ ] No circular reference paths
- [ ] Key columns have matching data types
