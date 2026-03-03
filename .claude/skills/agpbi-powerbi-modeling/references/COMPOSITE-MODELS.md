# Composite Models for Power BI

## Overview

Composite Models allow you to combine Import mode and DirectQuery in the same Power BI model. This enables scenarios where:
- Large historical data stays in the source (DirectQuery)
- Recent/aggregated data is imported for performance (Import)
- Multiple data sources can be combined

## When to Use Composite Models

| Scenario | Recommendation |
|----------|----------------|
| Small dataset (< 1M rows) | Import mode only |
| Medium dataset (1M-10M rows) | Import or DirectQuery |
| Large dataset (> 10M rows) | Consider composite |
| Real-time requirements | DirectQuery |
| Complex transformations | Import (with incremental refresh) |

## Architecture Patterns

### Pattern 1: Hybrid Import/DirectQuery
```
Historical Data (DirectQuery) ←→ Recent Data (Import) ←→ Dimensions (Import)

Benefits:
- Fast queries on recent data
- Access to full historical data
- Good performance for aggregations
```

### Pattern 2: Aggregation Tables
```
Detail Data (DirectQuery) ←→ Summary Data (Import) ←→ Dimensions (Import)

Benefits:
- Fast summaries from imported aggregations
- Drill-through to detail when needed
- Reduces load on source system
```

### Pattern 3: Dual Storage
```
Hot Data (Import, last 12 months) ←→ Cold Data (DirectQuery, older)

Benefits:
- Best performance on frequently accessed data
- Full historical access
- Manageable model size
```

## Configuration

### Enable Composite Mode
1. Go to File → Options and settings → Options
2. Preview features → Enable "Composite models" (in older versions)
3. In current versions: Automatically enabled when mixing modes

### Set Storage Mode
```
Table Properties → Advanced → Storage Mode options:
- Import
- DirectQuery
- Dual (recommended for dimensions)
```

### Understanding Dual Mode
```
Dual mode tables:
- Act as Import for relationships to Import tables
- Act as DirectQuery for relationships to DirectQuery tables
- Best for shared dimensions
```

## Best Practices

### 1. Dimension Tables: Dual Mode
```dax
-- Dimensions should be Dual when mixing modes:
-- - Fast joins to both Import and DirectQuery
-- - Single copy of dimension data
-- - Consistent filtering behavior

Tables in Dual: Customer, Product, Date, Geography
```

### 2. Fact Tables: Choose Carefully
```
Use Import for:
- Frequently accessed facts
- Data requiring complex transformations
- Data with good compression (low cardinality)

Use DirectQuery for:
- Very large tables (> 100M rows)
- Real-time data requirements
- Data that doesn't fit in memory
```

### 3. Relationship Cardinality
```
With composite models:
- Use Many-to-One (standard)
- Avoid Many-to-Many (use bridge tables)
- Consider Single vs Both directions carefully
```

### 4. Cross-Database Joins
```m
-- Power Query: Merge tables from different sources
-- Performance depends on:
-- - Privacy levels (Organizational vs Public)
-- - Query folding capability
-- - Data volume
```

## Common Patterns

### Pattern 1: Aggregation Tables
```dax
-- Detailed sales (DirectQuery)
-- Daily summary (Import)

-- User Default aggregation table in model
-- Power BI automatically routes queries

-- Manual control with USERELATIONSHIP:
CALCULATE(
    [Total Sales],
    USERELATIONSHIP('Date'[Date], 'SalesDaily'[Date])
)
```

### Pattern 2: Time-Based Split
```m
-- Historical data (older than 1 year) - DirectQuery
= Sql.Database("server", "dbo_Sales_Historical")

-- Recent data (last 12 months) - Import with incremental refresh
= Sql.Database("server", "dbo_Sales_Recent")
```

### Pattern 3: Multi-Source Composite
```m
-- SQL Server (DirectQuery)
= Sql.Database("server", "Sales")

-- Excel/CSV (Import)
= Excel.Workbook(File.Contents("budget.xlsx"))

-- Combine with relationship on common key (e.g., Date)
```

## Performance Considerations

### Query Performance
```
Factor | Impact | Recommendation
-------|--------|----------------
Storage mode | High | Use Import when possible
Aggregation | High | Create summary tables
Relationships | Medium | Minimize chains
DAX complexity | Medium | Optimize measures
Source performance | High | For DirectQuery tables
```

### Data Refresh
```
Import tables:
- Scheduled refresh required
- Faster queries after refresh
- Data may be stale

DirectQuery tables:
- No refresh needed (always current)
- Slower queries (each query hits source)
- Latest data always available
```

## Limitations

### Feature Limitations by Mode

| Feature | Import | DirectQuery | Composite |
|---------|--------|-------------|-----------|
| Calculated Tables | ✅ | ❌ | ✅ (Import only) |
| Calculated Columns | ✅ | ⚠️ Limited | ✅ (Import only) |
| Row-Level Security | ✅ | ✅ | ✅ |
| Q&A | ✅ | ⚠️ Limited | ⚠️ Limited |
| Use Relationships | ✅ | ❌ | ❌ |
| Many-to-Many | ✅ | ❌ | ❌ |
| Bidirectional | ✅ | ⚠️ Limited | ⚠️ Limited |

### Known Limitations
```
- Cannot use USERELATIONSHIP with DirectQuery
- Limited DAX functions in DirectQuery
- No calculated columns in DirectQuery tables
- Cannot change mode after publishing (without re-publish)
- Some visuals not supported (e.g., Decomposition tree)
```

## Implementation Steps

### Step 1: Design the Model
```
1. Identify fact tables (size, update frequency)
2. Identify dimension tables (shared across facts)
3. Decide storage mode for each table
4. Plan relationships and cross-filter direction
```

### Step 2: Configure Storage Modes
```
1. Import data sources
2. Set storage mode per table
3. Use Dual for shared dimensions
4. Test relationships
```

### Step 3: Optimize Performance
```
1. Create aggregation tables for DirectQuery facts
2. Implement user-defined aggregations if needed
3. Test query performance
4. Monitor refresh times
```

### Step 4: Validate
```
1. Test all measures work with mixed modes
2. Verify data accuracy (Import vs DirectQuery)
3. Check performance with Power BI Performance Analyzer
4. Test with realistic user queries
```

## Code Examples

### Setting Storage Mode (Tabular Editor)
```c#
// Set table to Import
model.Tables["Sales"].Partition.DataView = DataViewMode.Import;

// Set table to DirectQuery
model.Tables["SalesHistorical"].Partition.DataView = DataViewMode.DirectQuery;

// Set table to Dual
model.Tables["Customer"].Partition.DataView = DataViewMode.Import;
model.Tables["Customer"].IsQueryOrphan = false; // Enables dual behavior
```

### Aggregation Table Setup
```dax
-- Create aggregation table in Power Query
let
    Source = Sql.Database("server", "Sales"),
    GroupedRows = Table.Group(
        Source,
        {"DateKey", "ProductKey", "CustomerKey"},
        {{"SalesAmount", each List.Sum([Amount]), type number}}
    )
in
    GroupedRows

-- Set up relationship and aggregation
-- Power BI automatically uses aggregation when possible
```

## Monitoring

### Performance Analyzer
```
Use Performance Analyzer in Power BI Desktop to:
- Measure query times
- Identify DirectQuery vs Import queries
- Find bottlenecks
- Test different scenarios
```

### DMV Queries
```sql
-- Check storage mode of tables
SELECT [ID], [Name], [DataView]
FROM $SYSTEM.TMSCHEMA_TABLES

-- Query statistics
SELECT * FROM $SYSTEM.DISCOVER_DMVS
WHERE [CATEGORY] = 'Query Processing'
```

## Validation Checklist

- [ ] Business requirements documented
- [ ] Data sources identified and accessible
- [ ] Storage mode decision made per table
- [ ] Relationships configured correctly
- [ ] Dual mode applied to dimensions
- [ ] Aggregation tables created (if needed)
- [ ] Performance tested with realistic data
- [ ] DirectQuery source performance validated
- [ ] Refresh schedule configured
- [ ] Documentation completed

## Troubleshooting

### Issue: Slow Queries
```
Diagnosis:
- Check Performance Analyzer for DirectQuery queries
- Verify source database indexes
- Consider more aggregation tables

Solution:
- Increase Import data volume
- Create additional aggregations
- Optimize source database
```

### Issue: Data Inconsistency
```
Diagnosis:
- Different data between Import and DirectQuery
- Time zone differences
- Refresh timing issues

Solution:
- Standardize time zones
- Align refresh schedules
- Use consistent data sources
```

### Issue: Relationships Not Working
```
Diagnosis:
- Storage mode incompatibility
- Missing keys
- Incorrect cardinality

Solution:
- Check storage mode compatibility
- Verify relationship keys exist
- Use single-direction cross-filter
```

## Comparison: Pure Import vs Composite

| Aspect | Import Only | Composite |
|--------|-------------|-----------|
| Query Performance | Best | Mixed |
| Data Freshness | Scheduled | Real-time (DQ) |
| Model Size | Limited by memory | Can exceed memory |
| Complexity | Simple | Complex |
| Maintenance | Low | Medium |
| Best For | < 10M rows | > 10M rows + real-time needs |

---

**AIDEV-NOTE**: Composite models add complexity. Only use when necessary (large datasets or real-time requirements). Start with Import mode and add DirectQuery only if needed.
