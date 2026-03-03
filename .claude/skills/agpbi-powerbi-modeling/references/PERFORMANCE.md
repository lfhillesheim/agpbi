# Performance Optimization for Power BI Models

## Data Reduction Techniques

### 1. Remove Unnecessary Columns
- Only import columns needed for reporting
- Remove audit columns (CreatedBy, ModifiedDate) unless required
- Remove duplicate/redundant columns

```
column_operations(operation: "List", filter: { tableNames: ["Sales"] })
// Review and remove unneeded columns
```

### 2. Remove Unnecessary Rows
- Filter historical data to relevant period
- Exclude cancelled/void transactions if not needed
- Apply filters in Power Query (not in DAX)

### 3. Reduce Cardinality
High cardinality (many unique values) impacts:
- Model size
- Refresh time
- Query performance

**Solutions:**
| Column Type | Reduction Technique |
|-------------|---------------------|
| DateTime | Split into Date and Time columns |
| Decimal precision | Round to needed precision |
| Text with patterns | Extract common prefix/suffix |
| High-precision IDs | Use surrogate integer keys |

### 4. Optimize Data Types
| From | To | Benefit |
|------|-----|---------|
| DateTime | Date (if time not needed) | 8 bytes to 4 bytes |
| Decimal | Fixed Decimal | Better compression |
| Text with numbers | Whole Number | Much better compression |
| Long text | Shorter text | Reduces storage |

### 5. Group and Summarize
Pre-aggregate data when detail not needed:
- Daily instead of transactional
- Monthly instead of daily
- Consider aggregation tables for DirectQuery

### 6. Query Folding (CRITICAL - See DirectQuery Section)
Query folding is the MOST important Power Query optimization.
See "Query Folding" section below for detailed guidance.

## Column Optimization

### Prefer Power Query Columns Over Calculated Columns
| Approach | When to Use |
|----------|-------------|
| Power Query (M) | Can be computed at source, static values |
| Calculated Column (DAX) | Needs model relationships, dynamic logic |

Power Query columns:
- Load faster
- Compress better
- Use less memory

### Avoid Calculated Columns on Relationship Keys
DAX calculated columns in relationships:
- Cannot use indexes
- Generate complex SQL for DirectQuery
- Hurt performance significantly

**Use COMBINEVALUES for multi-column relationships:**
```dax
// If you must use calculated column for composite key
CompositeKey = COMBINEVALUES(",", [Country], [City])
```

### Set Appropriate Summarization
Prevent accidental aggregation of non-additive columns:
```
column_operations(
  operation: "Update",
  definitions: [{
    tableName: "Product",
    name: "UnitPrice",
    summarizeBy: "None"
  }]
)
```

## Relationship Optimization

### 1. Minimize Bidirectional Relationships
Each bidirectional relationship:
- Increases query complexity
- Can create ambiguous paths
- Reduces performance

### 2. Avoid Many-to-Many When Possible
Many-to-many relationships:
- Generate more complex queries
- Require more memory
- Can produce unexpected results

### 3. Reduce Relationship Cardinality
Keep relationship columns low cardinality:
- Use integer keys over text
- Consider higher-grain relationships

## DAX Optimization

### 1. Use Variables
```dax
// GOOD - Calculate once, use twice
Sales Growth = 
VAR CurrentSales = [Total Sales]
VAR PriorSales = [PY Sales]
RETURN DIVIDE(CurrentSales - PriorSales, PriorSales)

// BAD - Recalculates [Total Sales] and [PY Sales]
Sales Growth = 
DIVIDE([Total Sales] - [PY Sales], [PY Sales])
```

### 2. Avoid FILTER with Entire Tables
```dax
// BAD - Iterates entire table
Sales High Value = 
CALCULATE([Total Sales], FILTER(Sales, Sales[Amount] > 1000))

// GOOD - Uses column reference
Sales High Value = 
CALCULATE([Total Sales], Sales[Amount] > 1000)
```

### 3. Use KEEPFILTERS Appropriately
```dax
// Respects existing filters
Sales with Filter = 
CALCULATE([Total Sales], KEEPFILTERS(Product[Category] = "Bikes"))
```

### 4. Prefer DIVIDE Over Division Operator
```dax
// GOOD - Handles divide by zero
Margin % = DIVIDE([Profit], [Sales])

// BAD - Errors on zero
Margin % = [Profit] / [Sales]
```

## DirectQuery Optimization

### 1. Minimize Columns and Tables
DirectQuery models:
- Query source for every visual
- Performance depends on source
- Minimize data retrieved

### 2. Avoid Complex Power Query Transformations
- Transforms become subqueries
- Native queries are faster
- Materialize at source when possible

### 3. Keep Measures Simple Initially
Complex DAX generates complex SQL:
- Start with basic aggregations
- Add complexity gradually
- Monitor query performance

### 4. ALWAYS Disable Auto Date/Time (CRITICAL)
**Auto Date/Time MUST be disabled for ALL models - not just DirectQuery:**
- Creates 4 hidden calculated tables per date column
- Significantly increases model size
- Causes ambiguous filter paths
- Hurts query performance
- Confuses users with duplicate date hierarchies

**How to disable:**
```
Power BI Desktop → File → Options and settings → Options
→ Current File → Data Load →
☑ Auto Date/Time (for new files) → UNCHECK
```

**Use explicit date table instead:**
```dax
Date =
ADDCOLUMNS(
    CALENDAR(DATE(2020,1,1), DATE(2030,12,31)),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMMM"),
    "MonthNum", MONTH([Date]),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "WeekDay", FORMAT([Date], "dddd")
)
// Mark as Date Table in Model view
```

### 5. Query Folding (CRITICAL)
**Query Folding is the most important Power Query optimization:**

**What is Query Folding?**
- Power Query translates M operations into source SQL
- Source database does the heavy lifting
- Only filtered/aggregated data is loaded

**Best Practices for Query Folding:**
```m
// GOOD - These operations typically fold:
Table.SelectRows()     // WHERE clause
Table.SelectColumns()  // SELECT specific columns
Table.Sort()           // ORDER BY
Table.Group()          // GROUP BY
Table.Join()           // JOIN/UNION
Table.FirstN()         // TOP N

// BAD - These operations break folding:
Table.TransformRows()  // Custom row transformation
List.Buffer()          // Loads data into memory
Text.Contains()        // On some sources
DateTime.LocalNow()    // Non-deterministic functions
```

**Verify Query Folding:**
```
Power Query Editor → View → Query Dependencies
Right-click query → Native Query
(If empty, folding is not happening)
```

**Best Practices:**
1. Keep transformations simple and source-friendly
2. Filter early (first step if possible)
3. Remove unused columns immediately
4. Avoid custom M functions when native operations exist
5. Test with "View Native Query" regularly

## Aggregations

### User-Defined Aggregations
Pre-aggregate fact tables for:
- Very large models (billions of rows)
- Hybrid DirectQuery/Import
- Common query patterns

```
table_operations(
  operation: "Create",
  definitions: [{
    name: "SalesAgg",
    mode: "Import",
    mExpression: "..."
  }]
)
```

## Performance Testing

### Use Performance Analyzer
1. Enable in Power BI Desktop
2. Start recording
3. Interact with visuals
4. Review DAX query times

### Monitor with DAX Studio
External tool for:
- Query timing
- Server timings
- Query plans

## Validation Checklist

### Power Query
- [ ] Query folding verified (Native Query exists)
- [ ] Filters applied early in the query
- [ ] Unused columns removed immediately
- [ ] Unnecessary rows filtered at source
- [ ] Data types optimized (Date vs DateTime, etc.)
- [ ] No List.Buffer or Table.TransformRows when folding needed

### Data Model
- [ ] Auto Date/Time disabled (ALL models, not just DirectQuery)
- [ ] Unnecessary columns removed
- [ ] Appropriate data types used
- [ ] High-cardinality columns addressed
- [ ] Explicit date table created and marked

### Relationships
- [ ] Bidirectional relationships minimized (ideally zero)
- [ ] One active path between any two tables
- [ ] Single-direction cross-filtering by default

### DAX
- [ ] DAX uses variables for repeated expressions
- [ ] No FILTER on entire tables
- [ ] DIVIDE used instead of division operator
- [ ] KEEPFILTERS used appropriately

### Testing
- [ ] Performance tested with representative data
- [ ] Performance Analyzer used to identify bottlenecks
- [ ] Query plans reviewed for large measures
