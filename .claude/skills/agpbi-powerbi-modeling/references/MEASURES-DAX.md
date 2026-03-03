# DAX Measures and Naming Conventions

## Naming Conventions

### General Rules
- Use human-readable names (spaces allowed)
- Be descriptive: `Total Sales Amount` not `TSA`
- Avoid abbreviations unless universally understood
- Use consistent capitalization (Title Case recommended)
- Avoid special characters except spaces

### Table Naming
| Type | Convention | Example |
|------|------------|---------|
| Dimension | Singular noun | Customer, Product, Date |
| Fact | Business process | Sales, Orders, Inventory |
| Bridge | Combined names | CustomerAccount, ProductCategory |
| Measure Table | Underscore prefix | _Measures, _KPIs |

## ⚠️ CRITICAL: Dedicated Measure Table Required

**ALL Power BI models MUST have a dedicated measures table named `_Measures`:**

### Why a Dedicated Measures Table?
1. **Organization**: All measures in one place
2. **UX**: Users see "Measures" at top of field list
3. **Performance**: No accidental column aggregation
4. **Maintenance**: Easy to find and update measures
5. **Best Practice**: Microsoft recommended pattern

### Creating the _Measures Table
```dax
// In Tabular Editor or Power BI Desktop:
// Create a new calculation table

_Measures =
    UNION(
        ROW("Measure", "Placeholder"),
        ROW("Measure", "Placeholder2")
    )
```

### Best Practices for _Measures Table
```dax
// Then delete the placeholder column
// All measures live in this table with:
// - No columns (except hidden technical column if needed)
// - No relationships
// - All measures organized in display folders
// - IsHidden = false (visible to users)
// - All other table columns hidden if they contain measures
```

### Measure Organization in Display Folders
```
_Measures
├── 01. Revenue
│   ├── Total Sales
│   ├── YTD Sales
│   └── Sales vs Budget
├── 02. Margins
│   ├── Gross Margin %
│   ├── Net Margin %
│   └── Margin vs PY
├── 03. Customers
│   ├── Customer Count
│   ├── Active Customers
│   └── New Customers
├── 04. Time Intelligence
│   ├── Year
│   │   ├── YTD Sales
│   │   └── PY Sales
│   └── Month
│       ├── MTD Sales
│       └── PM Sales
└── 99. Technical
    ├── _Row Count
    └── _Max Date
```

### Hiding Measures in Fact Tables
```
After moving measures to _Measures:
1. Hide measures in fact tables (isHidden: true)
2. Or keep "transition period" measures with underscore prefix
3. Document which measures to migrate
```

### Column Naming
| Type | Convention | Example |
|------|------------|---------|
| Keys | Suffix with "Key" or "ID" | CustomerKey, ProductID |
| Dates | Suffix with "Date" | OrderDate, ShipDate |
| Amounts | Descriptive with unit hint | SalesAmount, QuantitySold |
| Flags | Prefix with "Is" or "Has" | IsActive, HasDiscount |

### Measure Naming
| Type | Convention | Example |
|------|------------|---------|
| Aggregations | Verb + Noun | Total Sales, Count of Orders |
| Ratios | X per Y or X Rate | Sales per Customer, Conversion Rate |
| Time Intelligence | Period + Metric | YTD Sales, PY Total Sales |
| Comparisons | Metric + vs + Baseline | Sales vs Budget, Growth vs PY |

## Explicit vs Implicit Measures

### Always Create Explicit Measures For:
1. Key business metrics users will query
2. Complex calculations with filter manipulation
3. Measures used in MDX (Excel PivotTables)
4. Controlled aggregation (prevent sum of averages)

### Implicit Measures (Column Aggregations)
- Acceptable for simple exploration
- Set correct SummarizeBy property:
  - Amounts: Sum
  - Keys/IDs: None (Do Not Summarize)
  - Rates/Prices: None or Average

## Measure Patterns

### Basic Aggregations
```dax
Total Sales = SUM(Sales[SalesAmount])
Order Count = COUNTROWS(Sales)
Average Order Value = DIVIDE([Total Sales], [Order Count])
Distinct Customers = DISTINCTCOUNT(Sales[CustomerKey])
```

### Time Intelligence (Requires Date Table)
```dax
YTD Sales = TOTALYTD([Total Sales], 'Date'[Date])
MTD Sales = TOTALMTD([Total Sales], 'Date'[Date])
PY Sales = CALCULATE([Total Sales], SAMEPERIODLASTYEAR('Date'[Date]))
YoY Growth = DIVIDE([Total Sales] - [PY Sales], [PY Sales])
```

### Percentage Calculations
```dax
Sales % of Total = 
DIVIDE(
    [Total Sales],
    CALCULATE([Total Sales], REMOVEFILTERS(Product))
)

Margin % = DIVIDE([Gross Profit], [Total Sales])
```

### Running Totals
```dax
Running Total = 
CALCULATE(
    [Total Sales],
    FILTER(
        ALL('Date'),
        'Date'[Date] <= MAX('Date'[Date])
    )
)
```

## Column References

### Best Practice: Always Qualify Column Names
```dax
// GOOD - Fully qualified
Sales Amount = SUM(Sales[SalesAmount])

// BAD - Unqualified (can cause ambiguity)
Sales Amount = SUM([SalesAmount])
```

### Measure References: Never Qualify
```dax
// GOOD - Unqualified measure
YTD Sales = TOTALYTD([Total Sales], 'Date'[Date])

// BAD - Qualified measure (breaks if home table changes)
YTD Sales = TOTALYTD(Sales[Total Sales], 'Date'[Date])
```

## Documentation

### Measure Descriptions
Always add descriptions explaining:
- What the measure calculates
- Business context/usage
- Any important assumptions

```
measure_operations(
  operation: "Update",
  definitions: [{
    name: "Total Sales",
    tableName: "Sales",
    description: "Sum of all completed sales transactions. Excludes returns and cancelled orders."
  }]
)
```

### Format Strings
| Data Type | Format String | Example Output |
|-----------|---------------|----------------|
| Currency | $#,##0.00 | $1,234.56 |
| Percentage | 0.0% | 12.3% |
| Whole Number | #,##0 | 1,234 |
| Decimal | #,##0.00 | 1,234.56 |

## Display Folders

Organize measures into logical groups:
```
measure_operations(
  operation: "Update",
  definitions: [{
    name: "YTD Sales",
    tableName: "_Measures",
    displayFolder: "Time Intelligence\\Year"
  }]
)
```

Common folder structure:
```
_Measures
├── Sales
│   ├── Total Sales
│   └── Average Sale
├── Time Intelligence
│   ├── Year
│   │   ├── YTD Sales
│   │   └── PY Sales
│   └── Month
│       └── MTD Sales
└── Ratios
    ├── Margin %
    └── Conversion Rate
```

## Variables for Performance

Use variables to:
- Avoid recalculating the same expression
- Improve readability
- Enable debugging

```dax
Gross Margin % = 
VAR TotalSales = [Total Sales]
VAR TotalCost = [Total Cost]
VAR GrossProfit = TotalSales - TotalCost
RETURN
    DIVIDE(GrossProfit, TotalSales)
```

## Validation Checklist

### Model Structure
- [ ] **Dedicated `_Measures` table exists** (REQUIRED)
- [ ] All measures organized in `_Measures` table
- [ ] Measures in fact tables hidden or migrated
- [ ] Display folders used for organization

### Measure Quality
- [ ] All key business metrics have explicit measures
- [ ] Measures have clear, descriptive names
- [ ] Measures have descriptions (what and why)
- [ ] Appropriate format strings applied
- [ ] Column references are fully qualified
- [ ] Measure references are NOT qualified
- [ ] Variables used for complex calculations

### DAX Best Practices
- [ ] DIVIDE() used instead of / operator
- [ ] No hardcoded values (use parameters)
- [ ] Error handling implemented (IFERROR, DIVIDE)
- [ ] Time intelligence uses explicit date table
