# Perspectives for Power BI Models

## Overview

Perspectives allow you to create customized views of your data model for different user groups. They simplify the model by showing only relevant tables, columns, and measures to specific audiences.

## When to Use Perspectives

| Scenario | Benefit |
|----------|---------|
| Large models (50+ tables) | Hide complexity from end users |
| Multiple departments | Show only relevant tables per team |
| Different access levels | Hide sensitive tables/columns |
| Embedded analytics | Customize model per app |
| Excel analysis | Simplify pivot table fields |

## Architecture

```
Full Model (All Tables)
├── Sales Perspective (Sales team)
│   ├── Sales, Customers, Products, Date
│   └── Sales-specific measures
├── Finance Perspective (Finance team)
│   ├── Budget, Actuals, Accounts, Date
│   └── Finance-specific measures
└── Operations Perspective (Ops team)
    ├── Inventory, Logistics, Suppliers, Date
    └── Ops-specific measures
```

## Creating Perspectives

### Using Tabular Editor (Recommended)

1. **Open Tabular Editor** from Power BI Desktop
   - External Tools → Tabular Editor

2. **Create Perspective**
   ```
   Right-click Model → Add New Perspective
   Name: "Sales" (or department name)
   ```

3. **Add Objects to Perspective**
   ```
   For each table/column/measure:
   - In Properties → Perspectives
   - Check the boxes for relevant perspectives
   ```

### Using Tabular Editor 3

```
Table → Perspectives property → Check boxes
Column → Perspectives property → Check boxes
Measure → Perspectives property → Check boxes
```

## Best Practices

### 1. Naming Conventions
```
Perspective Names: {Department/Role}
Examples:
- Sales
- Finance
- Operations
- Executive
- External

Do NOT use:
- "View1", "View2" (not descriptive)
- "Sales View" (redundant)
- Abbreviations like "Fin", "Ops"
```

### 2. Inclusion Strategy
```
For each perspective:
- Include ALL dimension tables used by department
- Include ONLY fact tables relevant to department
- Hide technical columns (keys, IDs)
- Include ALL relevant measures
```

### 3. Shared vs Departmental
```
Shared across ALL perspectives:
- Date table
- Geography table
- Common dimensions (Customer, Product)

Department-specific:
- Fact tables
- Private dimensions
- Department-specific measures
```

### 4. Measure Organization
```
Use display folders within perspectives:
Sales Perspective:
├── Revenue
│   ├── Total Sales
│   ├── YTD Sales
│   └── Sales vs Budget
├── Margins
│   ├── Gross Margin %
│   └── Net Margin %
└── Customer Metrics
    ├── Customer Count
    └── Avg Order Value
```

## Common Patterns

### Pattern 1: Departmental
```
Sales Perspective:
- Sales, Orders, Customers, Products, Date
- Measures: Revenue, Orders, Margins

Finance Perspective:
- Budget, Actuals, Variance, Accounts, Date
- Measures: Budget vs Actual, YTD Budget, Variance %

HR Perspective:
- Employees, Payroll, Departments, Date
- Measures: Headcount, Salary, Turnover
```

### Pattern 2: Executive vs Operational
```
Executive Perspective:
- High-level tables only
- Aggregated measures (summaries)
- Fewer columns (simplified)
- KPIs and trends

Operational Perspective:
- Detailed tables
- Transaction-level measures
- All relevant columns
- Drill-down capabilities
```

### Pattern 3: External vs Internal
```
Internal Perspective:
- All tables and measures
- Cost/profit details
- Sensitive metrics

External Perspective:
- Public tables only
- Revenue, volume (no cost)
- Aggregated data
- No drill-through to detail
```

## Configuration Examples

### Table-Level Perspective
```csharp
// In Tabular Editor for Sales Perspective
// Tables to include:
- Customer       ✅
- Product        ✅
- Date           ✅
- Sales          ✅
- Salesperson    ✅

// Tables to exclude:
- Budget         ❌
- Inventory      ❌
- Payroll        ❌
- Accounting     ❌
```

### Column-Level Perspective
```csharp
// For Customer table in Sales Perspective:
CustomerKey      ❌ (Hide technical key)
CustomerID       ❌ (Hide source ID)
CustomerName     ✅
CustomerEmail    ✅
CustomerPhone    ✅
CustomerType     ✅
CreatedDate      ❌ (Hide audit columns)
```

### Measure-Level Perspective
```csharp
// Sales Perspective - include:
- Total Sales                ✅
- Sales per Customer         ✅
- Sales vs Budget            ✅

// Finance Perspective - include:
- Total Revenue              ✅
- Cost of Goods              ✅
- Gross Profit               ✅
- Net Income                 ✅

// Sales Perspective - exclude:
- Cost of Goods              ❌
- Operating Expenses         ❌
- Net Income                 ❌
```

## Using Perspectives

### In Power BI Desktop
```
1. Build model with all tables
2. Create perspectives in Tabular Editor
3. Save and refresh in Power BI Desktop
4. Users see their perspective when building reports
```

### In Power BI Service
```
1. Publish model with perspectives
2. Users create reports in their perspective
3. Report builders only see their perspective
4. Different reports can use different perspectives
```

### In Excel
```
1. Connect to Power BI dataset
2. Select perspective during connection
3. Pivot table fields show only perspective objects
```

### In Power BI Embedded
```
1. Configure effective username/role
2. Specify perspective in embed token
3. Embedded app shows only perspective view
```

## Limitations

### Not a Security Feature
```
⚠️ IMPORTANT: Perspectives do NOT provide security!
- Users can still access all data via DAX
- Not a replacement for RLS
- Use only for UX simplification
- Use RLS for actual security
```

### Feature Limitations
```
- Cannot create relationships within perspectives
- Cannot change model behavior per perspective
- Cannot have different calculations per perspective
- All users with model access can switch perspectives (in Desktop)
```

## Validation Checklist

- [ ] Business requirements documented per perspective
- [ ] Perspective names are clear and descriptive
- [ ] All relevant tables included per perspective
- [ ] Technical columns hidden (keys, IDs)
- [ ] Measures organized in display folders
- [ ] No orphaned tables (tables with no relationships)
- [ ] RLS configured for actual security
- [ ] Tested with Excel connectivity
- [ ] Tested with Power BI Desktop
- [ ] Documentation updated

## Code Examples

### Tabular Editor Script (C#)
```csharp
// Create perspectives programmatically
var model = Model;

// Create Sales perspective
var salesPerspective = model.AddPerspective("Sales");

// Add tables to Sales perspective
salesPerspective.AddTable(model.Tables["Sales"]);
salesPerspective.AddTable(model.Tables["Customer"]);
salesPerspective.AddTable(model.Tables["Product"]);
salesPerspective.AddTable(model.Tables["Date"]);

// Create Finance perspective
var financePerspective = model.AddPerspective("Finance");

// Add tables to Finance perspective
financePerspective.AddTable(model.Tables["Budget"]);
financePerspective.AddTable(model.Tables["Actuals"]);
financePerspective.AddTable(model.Tables["Account"]);
financePerspective.AddTable(model.Tables["Date"]);
```

### PowerShell (with Tabular Object Model)
```powershell
# Add perspective using TOM
Load-Module -Name TabularObjectModel

$server = "asazure://region.asazure.windows.net/myserver"
$database = "MyModel"

$server = New-Object Microsoft.AnalysisServices.Tabular.Server
$server.Connect($server)

$database = $server.Databases.FindByName($database)

# Create perspective
$perspective = $database.Model.Perspectives.Add()
$perspective.Name = "Sales"

# Add tables
$table = $database.Model.Tables.FindByName("Sales")
$perspective.Annotations.Add()
$perspective.Annotations[0].Name = "Table:" + $table.Name
```

## Comparison: Perspectives vs RLS

| Aspect | Perspectives | RLS |
|--------|--------------|-----|
| Purpose | UX simplification | Data security |
| Hides tables | Yes | No |
| Hides rows | No | Yes |
| Enforced in Service | Partially | Yes |
| Works with Excel | Yes | Yes |
| Works with Embedded | Yes | Yes |
| Bypassable | Yes (Desktop) | No |

## Common Patterns

### Pattern 1: Multi-Tenant
```
Tenant A Perspective:
- Shows only Tenant A tables
- Measures calculate for Tenant A only

Tenant B Perspective:
- Shows only Tenant B tables
- Measures calculate for Tenant B only

+ RLS to ensure data isolation
```

### Pattern 2: Data Product View
```
Data Product Perspective:
- Simplified model for external users
- Pre-built measures only
- No technical tables
- No ad-hoc capabilities

Internal Perspective:
- Full model available
- All tables and columns
- Ad-hoc analysis enabled
```

### Pattern 3: Language/Region
```
US Perspective:
- USD measures only
- US geography
- English columns

EU Perspective:
- EUR measures only
- EU geography
- Local language columns
```

---

**AIDEV-NOTE**: Perspectives improve UX but do NOT provide security. Always use RLS for actual data access control. Perspectives can be bypassed in Power BI Desktop.
