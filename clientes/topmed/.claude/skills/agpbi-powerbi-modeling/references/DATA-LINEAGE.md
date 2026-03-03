# Data Lineage for Power BI

## Overview

Data lineage tracks the flow of data from source systems through transformations to the final Power BI model. It enables:
- Understanding where data comes from
- Tracing data transformations
- Impact analysis of changes
- Compliance and auditing
- Troubleshooting data issues

## Why Data Lineage Matters

| Scenario | Without Lineage | With Lineage |
|----------|-----------------|--------------|
| Source column changes | Breaking unknown | Know what breaks |
| Data quality issue | Hard to find root cause | Trace to source |
| Compliance audit | Manual documentation | Automated tracking |
| Model optimization | Guessing bottlenecks | Data flow visibility |
| Onboarding new team | Slow learning | Self-documenting |

## Lineage Levels

### Level 1: Source to Model
```
Source System → Power Query → Data Model
```

### Level 2: Column Mapping
```
Source Column → Transformed Column → Model Column
```

### Level 3: Transformation Tracking
```
Source → Step 1 → Step 2 → ... → Final Column
```

## Documentation Template

### Data Dictionary Template
```markdown
# Data Dictionary: Sales Fact Table

## Source Information
| Property | Value |
|----------|-------|
| Source System | SQL Server - AdventureWorks |
| Source Database | Sales |
| Source Schema | dbo |
| Source Table | SalesOrderHeader |
| Source Query | Custom (see Power Query) |
| Refresh Frequency | Daily |
| Owner | Sales Operations |

## Column Mapping
| Model Column | Source Column | Transformations | Notes |
|--------------|---------------|-----------------|-------|
| OrderDate | OrderDate | Date only (no time) | |
| CustomerKey | CustomerID | Surrogate key added | |
| SalesAmount | SubTotal + TaxAmt | Calculated in M | |
| SalesRegion | TerritoryID | Lookup to Territory table | |

## Transformation Steps
1. Source: SQL.Database("server", "AdventureWorks")
2. Filter: OrderDate >= 2020-01-01
3. Join: Customer table on CustomerID
4. Merge: Territory region on TerritoryID
5. Calculate: SalesAmount = SubTotal + TaxAmt
6. Type: Change data types
7. Remove: Unused columns
```

## Implementation Approaches

### Approach 1: Manual Documentation

#### Power Query Documentation
```m
// Add documentation steps in Power Query
// AIDEV-LINEAGE-SOURCE: SQL.Sales.SalesOrderHeader
// AIDEV-LINEAGE-TRANSFORM: Filter 2020+, join Customer, calculate amount
let
    Source = Sql.Database("server", "Sales"),
    dbo_SalesOrderHeader = Source{[Schema="dbo",Item="SalesOrderHeader"]}[Data],

    // AIDEV-LINEAGE: Filter to 2020+
    FilteredRows = Table.SelectRows(
        dbo_SalesOrderHeader,
        each [OrderDate] >= #datetime(2020, 1, 1, 0, 0, 0)
    ),

    // AIDEV-LINEAGE: Join Customer for CustomerKey
    MergedQueries = Table.NestedJoin(
        FilteredRows,
        {"CustomerID"},
        Customer,
        {"CustomerID"},
        "Customer",
        JoinKind.Inner
    ),

    // AIDEV-LINEAGE: Calculate SalesAmount
    AddedCustom = Table.AddColumn(
        MergedQueries,
        "SalesAmount",
        each [SubTotal] + [TaxAmt]
    )
in
    AddedCustom
```

### Approach 2: Automated Lineage with Annotations

#### Using Tabular Editor
```csharp
// Set lineage annotations
var table = Model.Tables["Sales"];

// Source information
table.SetAnnotation("SourceSystem", "SQL Server");
table.SetAnnotation("SourceDatabase", "AdventureWorks");
table.SetAnnotation("SourceSchema", "dbo");
table.SetAnnotation("SourceTable", "SalesOrderHeader");

// Set lineage for columns
var orderDateCol = table.Columns["OrderDate"];
orderDateCol.SetAnnotation("SourceColumn", "OrderDate");
orderDateCol.SetAnnotation("Transformations", "Date only, no time");
orderDateCol.SetAnnotation("BusinessDefinition", "Date when order was placed");

var salesAmountCol = table.Columns["SalesAmount"];
salesAmountCol.SetAnnotation("SourceColumn", "SubTotal + TaxAmt");
salesAmountCol.SetAnnotation("Transformations", "Calculated: SubTotal + TaxAmt");
salesAmountCol.SetAnnotation("BusinessDefinition", "Total order value including tax");
```

### Approach 3: Power Query Metadata

#### Custom Lineage Table
```m
// Create lineage documentation table
let
    Source = #table(
        {"TableName", "ColumnName", "SourceSystem", "SourceTable", "SourceColumn", "Transformation", "Notes"},
        {
            {"Sales", "OrderDate", "SQL Server", "SalesOrderHeader", "OrderDate", "Date only", "Order date"},
            {"Sales", "CustomerKey", "SQL Server", "SalesOrderHeader", "CustomerID", "Surrogate key", "FK to Customer"},
            {"Sales", "SalesAmount", "SQL Server", "SalesOrderHeader", "SubTotal+TaxAmt", "Calculated", "Total + tax"},
            {"Customer", "CustomerName", "SQL Server", "Customer", "CustomerName", "None", "Full name"},
            {"Customer", "Region", "SQL Server", "Customer", "TerritoryID", "Lookup", "Sales territory"}
        }
    )
in
    Source
```

## Lineage Documentation Structure

### File Structure
```
project/
├── documentation/
│   ├── lineage/
│   │   ├── sales-fact-lineage.md
│   │   ├── customer-dim-lineage.md
│   │   └── transformations.md
│   └── data-dictionary.md
```

### Lineage Document Template
```markdown
# Lineage: {Table Name}

## Overview
**Description**: {Business description of table}
**Type**: {Fact/Dimension}
**Grain**: {One row per...}

## Source
- **System**: {e.g., SQL Server, SAP, Excel}
- **Server**: {server name}
- **Database**: {database name}
- **Schema**: {schema name}
- **Table/Query**: {table name or query}
- **Access Method**: {Import/DirectQuery/Gateway}

## Data Flow
```
{Source Table} → {Power Query Steps} → {Model Table}
```

## Column Lineage
| Model Column | Source | Transformations | Description |
|--------------|--------|-----------------|-------------|
| | | | |

## Transformations
1. **Step 1**: {Description}
2. **Step 2**: {Description}
3. ...

## Dependencies
- **Upstream**: {Source tables, other queries}
- **Downstream**: {Measures, visuals that use this}

## Refresh
- **Frequency**: {Daily, Weekly, etc.}
- **Time**: {When refresh runs}
- **Duration**: {Expected refresh time}
- **Gateway**: {If applicable}

## Issues
- **Known Issues**: {Any known data quality issues}
- **Pending Changes**: {Planned modifications}

## Change Log
| Date | Change | Impact | Author |
|------|--------|--------|--------|
```

## Best Practices

### 1. Document at Source
```
When creating Power Query queries:
- Add descriptive step names
- Add comments for complex transformations
- Note source system references
```

### 2. Maintain Separation of Concerns
```
Staging queries (raw source)
  ↓
Transformation queries (business logic)
  ↓
Model queries (final schema)
```

### 3. Use Query Dependencies
```
Power BI Desktop → Transform Data → Query Dependencies
Shows:
- Which queries reference others
- Impact of changes
- Refresh order
```

### 4. Version Control for Documentation
```
Commit lineage docs with model changes:
- Keep lineage in source control
- Update with every change
- Review in pull requests
```

## Tools for Lineage

### Power BI Desktop Features
```
Query Dependencies View:
- Home tab → Transform data → Query Dependencies
- Visual representation of query relationships
- Shows upstream and downstream dependencies

Native Query Preview:
- View generated SQL for source queries
- Verify query folding
```

### Tabular Editor
```
Annotations:
- Add metadata to tables, columns, measures
- Document source systems
- Track transformations

Description Property:
- Built-in description field
- Visible to users
- Exported to documentation
```

### Third-Party Tools
```
- Documentation generators (PBI-Tools, Documentation-builder)
- Data catalog platforms
- Custom PowerShell scripts
```

## Change Impact Analysis

### Impact Analysis Template
```markdown
# Change Impact: {Date}

## Proposed Change
- **What**: {Description of change}
- **Why**: {Business reason}
- **Where**: {Tables, columns affected}

## Impact Analysis

### Direct Impact
- **Tables**: {Affected tables}
- **Columns**: {Affected columns}
- **Measures**: {Measures using affected columns}
- **Visuals**: {Reports using affected measures}

### Upstream Impact
- **Sources**: {Source systems affected}
- **Queries**: {Power Query dependencies}

### Downstream Impact
- **Reports**: {Reports using this data}
- **Users**: {Affected user groups}

### Testing Required
- [ ] Data validation
- [ ] Measure verification
- [ ] Visual testing
- [ ] Performance testing

## Rollback Plan
{How to revert if issues occur}

## Approval
- [ ] Data Owner
- [ ] Report Owner
- [ ] Change Approver
```

## Validation Checklist

- [ ] All source systems documented
- [ ] Column mapping complete
- [ ] Transformations tracked
- [ ] Dependencies documented
- [ ] Business definitions provided
- [ ] Refresh schedule documented
- [ ] Known issues noted
- [ ] Change log maintained
- [ ] Impact analysis process defined
- [ ] Review schedule established

## Common Patterns

### Pattern 1: Star Schema Lineage
```
Source:
- SQL Server tables (normalized)

Transform:
- Power Query: Join, flatten, add surrogate keys

Model:
- Dimensions: Customer, Product, Date
- Fact: Sales

Lineage tracking:
- Document source table for each dimension
- Map source columns to dimension columns
- Track key relationships
```

### Pattern 2: Multi-Source Lineage
```
Sources:
- SQL Server (Sales)
- Excel (Budget)
- Web API (Forecasts)

Transform:
- Union, merge, standardize

Model:
- Combined fact table

Lineage tracking:
- Track source indicator column
- Document transformation rules
- Note refresh frequencies per source
```

### Pattern 3: Slowly Changing Dimensions
```
Source:
- Transaction log with history

Transform:
- Type 2 SCD implementation (current + historical)

Model:
- Dimension with IsCurrent, StartDate, EndDate

Lineage tracking:
- Document SCD logic
- Track effective dates
- Note history retention
```

---

**AIDEV-NOTE**: Data lineage is not optional - it's essential for maintainability. Start documenting from day one, not as an afterthought. Use automation where possible, but manual documentation is still valuable.
