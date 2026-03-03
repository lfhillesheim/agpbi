# Incremental Refresh for Power BI

## Overview

Incremental refresh allows you to refresh only the data that has changed, rather than the entire dataset. This is critical for:
- Large datasets (millions/billions of rows)
- Frequently updated data
- Limited refresh windows
- Reducing load on data sources

## When to Use Incremental Refresh

| Dataset Size | Refresh Frequency | Recommendation |
|--------------|-------------------|----------------|
| < 1M rows | Daily | Full refresh is fine |
| 1M-10M rows | Hourly/Daily | Consider incremental |
| 10M-100M rows | Hourly/Daily | Incremental recommended |
| > 100M rows | Any | Incremental required |

## Prerequisites

### 1. Power Query Parameters
You must define these parameters in your model:

```m
// RangeStart - DateTime parameter
// RangeEnd - DateTime parameter
```

### 2. Filter on DateTime Column
Apply a filter in Power Query:

```m
= Table.SelectRows(
    Source,
    each [TransactionDate] >= DateTime.Localize(RangeStart, "UTC")
        and [TransactionDate] < DateTime.Localize(RangeEnd, "UTC")
)
```

### 3. Requirements
- **DateTime column** must exist in the fact table
- Column must have **unique values per row** (or use a key column)
- Column must be **deterministic** (no volatility like NOW())
- Table must use **Import mode** (not DirectQuery)

## Configuration

### Using Power BI Desktop
1. Select the table
2. Go to Table options → Incremental refresh
3. Configure:
   - **Refresh the last**: Period to incrementally refresh
   - **Archive data starting from**: Historical data to keep

### Using Tabular Editor (TMSL)
```xml
<RefreshPolicy>
    <IncrementalGranularity>Day</IncrementalGranularity>
    <RollingWindow>365</RollingWindow>
    <SourceExpression />
</RefreshPolicy>
```

## Refresh Strategies

### 1. Rolling Window (Most Common)
Keep recent data, archive historical:

```m
// Strategy: Keep last 12 months
// Refresh: Last 30 days incrementally
// Archive: Previous 11 months full

// Power BI Desktop Configuration:
// - "Refresh the last": 1 Month
// - "Archive data starting from": 12 Months ago
```

### 2. Growing Table
Keep all historical data, only refresh new:

```m
// Strategy: Keep all data forever
// Refresh: Last 7 days incrementally
// Archive: All historical data

// Power BI Desktop Configuration:
// - "Refresh the last": 1 Week
// - "Archive data starting from": 1/1/2010
```

### 3. Partitioned by Period
For very large datasets:

```m
// Strategy: Monthly partitions
// Refresh: Current month incrementally
// Archive: All previous months full

// Requires XMLA endpoint and manual partition management
```

## Best Practices

### 1. Choose the Right Granularity
| Data Volume | Recommended Granularity |
|-------------|------------------------|
| < 10M rows | Day or Month |
| 10M-100M rows | Day |
| > 100M rows | Hour or Day |

### 2. Optimize the DateTime Column
```m
// GOOD - Simple date column
= Table.SelectRows(Source, each [Date] >= RangeStart)

// BAD - Complex filtering
= Table.SelectRows(Source, each
    DateTime.Date([Date]) >= DateTime.Date(RangeStart)
    and Time.Hour([Time]) > 8
)
```

### 3. Handle Source Queries Appropriately

**For SQL Sources:**
```m
// GOOD - Query folding works
= Table.SelectRows(Source, each [Date] >= RangeStart)

// BAD - Folding breaks
= Table.SelectRows(
    Table.TransformColumnTypes(Source, {...}),
    each [Date] >= RangeStart
)
```

### 4. Set Appropriate Refresh Times
```m
// Schedule refresh in Power BI Service:
// - Incremental refresh: More frequent (hourly, daily)
// - Historical refresh: Less frequent (weekly, monthly)
// - Avoid overlap between incremental and historical
```

## Common Patterns

### Pattern 1: Transactional Data
```m
// Sales orders - keep last 2 years, refresh last 30 days
let
    RangeStart = #datetime(2024, 1, 1, 0, 0, 0),
    RangeEnd = #datetime(2024, 12, 31, 23, 59, 59),
    Source = Sql.Database("server", "database"),
    Sales = Source{[Schema="dbo",Item="Sales"]}[Data],
    FilteredRows = Table.SelectRows(
        Sales,
        each [OrderDate] >= RangeStart and [OrderDate] < RangeEnd
    )
in
    FilteredRows
```

### Pattern 2: Snapshot Data
```m
// Daily inventory snapshots - keep last 365 days
let
    RangeStart = #datetime(2024, 1, 1, 0, 0, 0),
    RangeEnd = #datetime(2024, 12, 31, 23, 59, 59),
    Source = Sql.Database("server", "database"),
    Inventory = Source{[Schema="dbo",Item="Inventory"]}[Data],
    FilteredRows = Table.SelectRows(
        Inventory,
        each [SnapshotDate] >= RangeStart and [SnapshotDate] < RangeEnd
    )
in
    FilteredRows
```

### Pattern 3: Web API Data
```m
// API calls with date filtering
let
    RangeStart = #datetime(2024, 1, 1, 0, 0, 0),
    RangeEnd = #datetime(2024, 12, 31, 23, 59, 59),
    Source = Json.Document(Web.Contents(
        "https://api.example.com/data",
        [Query=[
            startDate = DateTime.ToText(RangeStart),
            endDate = DateTime.ToText(RangeEnd)
        ]]
    ))
in
    Source
```

## Advanced Scenarios

### Multiple Tables with Different Refresh
```m
// Fact table - Daily incremental
// Dimension table - Weekly full refresh
// Configure refresh separately per table

// Use XMLA endpoint for fine-grained control:
// <RefreshPolicy Mode="Actual">
//   <IncrementalGranularity>Day</IncrementalGranularity>
//   <RollingWindow>90</RollingWindow>
// </RefreshPolicy>
```

### Hybrid with DirectQuery
```m
// Historical data (older than 1 year): DirectQuery
// Recent data (last 12 months): Import with incremental refresh

// Requires composite model configuration:
// - Create two tables from same source
// - Union them with careful relationship design
```

## Monitoring and Troubleshooting

### Check Refresh History
```sql
-- Query refresh history via Power BI REST API
GET https://api.powerbi.com/v1.0/myorg/groups/{groupId}/datasets/{datasetId}/refreshes
```

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "No valid partition" | Range doesn't match data | Adjust RangeStart/RangeEnd |
| "Folding not supported" | M breaks folding | Simplify Power Query |
| Slow incremental refresh | Source query slow | Optimize source query/indexes |
| "Refresh timeout" | Too much data | Reduce refresh window |

### Performance Monitoring
```m
// Use Power BI Desktop refresh dialog
// Check "Refresh load statistics" for:
// - Rows read from source
// - Rows inserted/updated
// - Time taken

// Target: < 5 minutes for incremental refresh
```

## Validation Checklist

- [ ] DateTime column exists and is indexed
- [ ] RangeStart and RangeEnd parameters created
- [ ] Filter applied correctly in Power Query
- [ ] Query folding verified (native query generated)
- [ ] Refresh policy configured in Power BI Desktop
- [ ] Historical refresh tested
- [ ] Incremental refresh tested
- [ ] Refresh schedule configured in service
- [ ] Refresh times monitored and optimized
- [ ] Fallback plan documented (full refresh if needed)

## Using XMLA Endpoint (Advanced)

For precise control over partitions:

```xml
<RefreshPolicy>
    <!-- Incremental refresh configuration -->
    <IncrementalGranularity>Day</IncrementalGranularity>
    <RollingWindow>180</RollingWindow>

    <!-- Source expression for partitioning -->
    <SourceExpression>
        let
            RangeStart = #datetime(...),
            RangeEnd = #datetime(...),
            ...
        in
            ...
    </SourceExpression>
</RefreshPolicy>
```

## Code Example: Complete Setup

```m
// parameters (create as Power Query parameters)
Parameter: RangeStart, Type: datetime, Default: 1/1/2024
Parameter: RangeEnd, Type: datetime, Default: 12/31/2024

// Sales fact table query
let
    RangeStart = RangeStart,
    RangeEnd = RangeEnd,

    // Connect to source - MUST be before filter for folding
    Source = Sql.Database("server", "database"),
    dbo_Sales = Source{[Schema="dbo",Item="Sales"]}[Data],

    // Apply filter - MUST be simple for folding
    FilteredRows = Table.SelectRows(
        dbo_Sales,
        each [OrderDate] >= RangeStart
            and [OrderDate] < RangeEnd
    ),

    // Transformations AFTER filter
    RemovedColumns = Table.SelectColumns(FilteredRows, {
        "OrderID", "CustomerKey", "ProductKey",
        "OrderDate", "Quantity", "Amount"
    }),
    ChangedType = Table.TransformColumnTypes(RemovedColumns, {{
        "OrderDate", type date
    }})

in
    ChangedType
```

## Incremental Refresh vs Other Approaches

| Approach | Best For | Limitations |
|----------|----------|-------------|
| Incremental Refresh | Large, regularly updated datasets | Requires DateTime column |
| Scheduled Full Refresh | Small datasets | Slow for large data |
| Streaming Dataset | Real-time dashboards | Limited retention |
| DirectQuery | Real-time on large data | Slower query performance |
| Composite Model | Hybrid scenarios | More complex setup |

---

**AIDEV-NOTE**: Always test incremental refresh configuration with a sample dataset before applying to production. Verify query folding using "Native Query" in Power Query.
