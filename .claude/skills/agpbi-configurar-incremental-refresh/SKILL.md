---
name: agpbi-configurar-incremental-refresh
description: Configure incremental refresh for Power BI models to optimize large dataset refreshes
parameters:
  - name: table_name
    description: Fact table to configure incremental refresh for
    required: true
  - name: date_column
    description: DateTime column for incremental filtering
    required: true
  - name: refresh_period
    description: Period for incremental refresh (e.g., "1 Month", "7 Days")
    required: true
  - name: archive_start
    description: Start date for historical archive (e.g., "1 Year ago")
    required: true
  - name: strategy
    description: Refresh strategy (rolling, growing, partitioned)
    required: false
    default: rolling
---

# Configure Incremental Refresh

Configure incremental refresh for large Power BI datasets to optimize refresh performance and reduce load on data sources.

## When to Use

| Dataset Size | Refresh Frequency | Recommendation |
|--------------|-------------------|----------------|
| < 1M rows | Daily | Full refresh is fine |
| 1M-10M rows | Hourly/Daily | Consider incremental |
| 10M-100M rows | Hourly/Daily | Incremental recommended |
| > 100M rows | Any | Incremental required |

## Prerequisites Checklist

Before configuring incremental refresh, ensure:

- [ ] DateTime column exists in the table
- [ ] DateTime column has unique values per row
- [ ] RangeStart parameter created
- [ ] RangeEnd parameter created
- [ ] Filter applied in Power Query using parameters
- [ ] Table is in Import mode

## Configuration Steps

### Step 1: Create Parameters in Power Query

```m
// Create these two parameters:
Parameter Name: RangeStart
Type: DateTime
Default: 1/1/2024 12:00:00 AM

Parameter Name: RangeEnd
Type: DateTime
Default: 12/31/2024 11:59:59 PM
```

### Step 2: Add Filter in Power Query

```m
// Add filter step AFTER source connection
// Keep transformations BEFORE filter minimal

FilteredRows = Table.SelectRows(
    Source,
    each [OrderDate] >= RangeStart and [OrderDate] < RangeEnd
)
```

### Step 3: Configure in Power BI Desktop

1. Select the table in Field List
2. Go to Table options → Incremental refresh
3. Configure:
   - **Refresh the last**: `$refresh_period`
   - **Archive data starting from**: `$archive_start`
   - **Only refresh complete days**: Check for date columns

### Step 4: Verify Query Folding

```
Power Query Editor → Right-click query → Native Query
Verify SQL is generated (folding is working)
```

## MCP Usage

```javascript
// 1. Create parameters
parameter_operations(
  operation: "Create",
  definitions: [
    { name: "RangeStart", dataType: "datetime", defaultValue: "2024-01-01" },
    { name: "RangeEnd", dataType: "datetime", defaultValue: "2024-12-31" }
  ]
)

// 2. Update table M expression to filter
table_operations(
  operation: "Update",
  definitions: [{
    name: "$table_name",
    mExpression: "let RangeStart=RangeStart, RangeEnd=RangeEnd in ..."
  }]
)
```

## Refresh Strategies

### Rolling Window (Most Common)
```
Keep last 12 months, refresh last 30 days
- "Refresh the last": 1 Month
- "Archive data starting from": 12 Months ago
```

### Growing Table
```
Keep all historical data
- "Refresh the last": 1 Week
- "Archive data starting from": Static date (e.g., 1/1/2010)
```

### Partitioned (Advanced)
```
Monthly partitions for very large data
- Requires XMLA endpoint
- Manual partition management via Tabular Editor
```

## Validation

- [ ] Parameters RangeStart and RangeEnd created
- [ ] Filter step uses parameters (not hardcoded values)
- [ ] Query folding verified (Native Query exists)
- [ ] Incremental refresh policy configured
- [ ] Refresh tested with small dataset first
- [ ] Historical refresh completed successfully
- [ ] Incremental refresh completed successfully

## Best Practices

1. **Filter Early**: Apply datetime filter as first step after source
2. **Keep Transformations Simple**: Complex transforms break query folding
3. **Use Date Not DateTime**: If time not needed, use Date type (better compression)
4. **Test First**: Test with small date ranges before full deployment
5. **Monitor Refresh**: Check refresh history after first incremental run

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "No valid partition" | Range doesn't match data | Adjust RangeStart/RangeEnd |
| Slow refresh | Folding not working | Simplify Power Query |
| High memory usage | Too much historical data | Reduce archive period |
| Refresh timeout | Too much incremental data | Shorten refresh period |

## Example Configuration

**Input**:
```
table_name: Sales
date_column: OrderDate
refresh_period: 1 Month
archive_start: 3 Years ago
strategy: rolling
```

**Expected Output**:
- Parameters RangeStart, RangeEnd created
- Power Query filter applied to OrderDate
- Incremental refresh policy configured
- Query folding verified

## References

- See `INCREMENTAL-REFRESH.md` for detailed guidance
