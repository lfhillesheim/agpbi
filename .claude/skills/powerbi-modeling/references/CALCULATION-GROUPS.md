# Calculation Groups for Power BI

## Overview

Calculation Groups allow you to define reusable calculations that apply to any measure. They solve the problem of duplicating measures for time intelligence and other common patterns.

### Benefits
- **Eliminate measure proliferation**: One calculation instead of many
- **Consistency**: Apply same logic to all measures
- **Maintainability**: Update in one place
- **Flexibility**: Users can select calculations dynamically

## When to Use Calculation Groups

| Scenario | Without Calc Groups | With Calc Groups |
|----------|---------------------|------------------|
| Time Intelligence (YoY, MoM) | `YTD Sales`, `YTD Profit`, `YTD Cost`... | `YTD` applies to any measure |
| Currency Conversion | `Sales USD`, `Sales EUR`, `Profit USD`... | One conversion calc |
| Scenarios | `Sales Budget`, `Sales Actual`, `Sales Forecast` | One scenario selector |
| Unit Conversion | `Sales in K`, `Sales in M`, `Sales in B` | One unit selector |

## Prerequisites

- **Power BI Desktop** (with Tabular Editor)
- **Tabular Editor 2** (free) or **Tabular Editor 3** (paid)
- **Compatible mode**: Power BI supports calculation groups

## Creating Calculation Groups

### Using Tabular Editor 3 (Recommended)

1. **Open Tabular Editor** from Power BI Desktop
   - External Tools → Tabular Editor

2. **Create Calculation Group Table**
   ```
   Right-click Tables → Create New → Calculation Group
   Name: "Time Intelligence" (or other meaningful name)
   ```

3. **Add Calculation Items**
   ```
   Right-click Calculation Group → Add New Calculation Item
   ```

### Using Tabular Editor 2

1. Open Tabular Editor
2. File → New → Calculation Group Table
3. Add calculation items manually

## Common Patterns

### Pattern 1: Time Intelligence

```dax
-- Calculation Group: Time Intelligence

-- Item: YTD (Year to Date)
CALCULATE(
    SELECTEDMEASURE(),
    DATESYTD('Date'[Date])
)

-- Item: PY (Prior Year)
CALCULATE(
    SELECTEDMEASURE(),
    SAMEPERIODLASTYEAR('Date'[Date])
)

-- Item: YoY % (Year over Year Growth)
DIVIDE(
    CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date])),
    CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
) - 1

-- Item: YoY Diff (Year over Year Difference)
CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date])) -
CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date])

-- Item: MTD (Month to Date)
CALCULATE(
    SELECTEDMEASURE(),
    DATESMTD('Date'[Date])
)

-- Item: PM (Prior Month)
CALCULATE(
    SELECTEDMEASURE(),
    DATEADD('Date'[Date], -1, MONTH)
)

-- Item: MoM % (Month over Month Growth)
DIVIDE(
    CALCULATE(SELECTEDMEASURE(), DATESMTD('Date'[Date])),
    CALCULATE(SELECTEDMEASURE(), DATEADD('Date'[Date], -1, MONTH))
) - 1
```

### Pattern 2: Currency Conversion

```dax
-- Calculation Group: Currency

-- Item: USD
SELECTEDMEASURE() * [USD Exchange Rate]

-- Item: EUR
SELECTEDMEASURE() * [EUR Exchange Rate]

-- Item: BRL
SELECTEDMEASURE() * [BRL Exchange Rate]

-- Item: Local Currency
SELECTEDMEASURE()
```

### Pattern 3: Scenarios (Budget vs Actual)

```dax
-- Calculation Group: Scenario

-- Item: Actual
SELECTEDMEASURE()

-- Item: Budget
CALCULATE(
    SELECTEDMEASURE(),
    'Scenario'[Scenario] = "Budget"
)

-- Item: Variance
CALCULATE(
    SELECTEDMEASURE(),
    'Scenario'[Scenario] = "Budget"
) - CALCULATE(
    SELECTEDMEASURE(),
    'Scenario'[Scenario] = "Actual"
)

-- Item: Variance %
DIVIDE(
    CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Budget") -
    CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Actual"),
    CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Actual")
)
```

### Pattern 4: Unit Conversion

```dax
-- Calculation Group: Unit Display

-- Item: Units
SELECTEDMEASURE()

-- Item: Thousands
DIVIDE(SELECTEDMEASURE(), 1000)

-- Item: Millions
DIVIDE(SELECTEDMEASURE(), 1000000)

-- Item: Billions
DIVIDE(SELECTEDMEASURE(), 1000000000)
```

### Pattern 5: String Aggregation (Dynamic Title)

```dax
-- Calculation Group: Dynamic Titles

-- Item: No Title
SELECTEDMEASURE()

-- Item: With Title
VAR Title =
    IF(
        ISBLANK(SELECTEDMEASURE()),
        "",
        "Total " & SELECTEDMEASURENAME()
    )
RETURN
    CALCULATE(SELECTEDMEASURE(), Title)
```

## Configuration Properties

### Ordinal Property
Controls the order in which calculation items appear in the slicer:

```dax
-- Set Ordinal in Tabular Editor:
-- YTD: 0
-- MTD: 1
-- PY: 2
-- YoY %: 3
```

### Format String Expression
Dynamic formatting based on calculation:

```dax
-- For percentage calculations:
0.0%;-0.0%;0.0%

-- For currency (using parent measure format):
SELECTEDMEASUREFORMATSTRING()

-- For thousands:
#,##0,,;(#,##0,,)
```

### Hide Items
Control which items are visible:

```dax
-- In Tabular Editor:
-- Set Hidden = true for items used only internally
-- Example: Hide "Prior Year" if only showing YoY %
```

## Best Practices

### 1. Naming Conventions
```
Calculation Group Table: {Purpose}
Examples: "Time Intelligence", "Currency", "Scenario"

Calculation Items: {Action/Period}
Examples: "YTD", "PY", "YoY %", "USD", "Budget"
```

### 2. Use Dynamic Format Strings
```dax
-- GOOD: Respects parent measure format
Format String Expression: SELECTEDMEASUREFORMATSTRING()

-- BAD: Hardcoded format
Format String Expression: "#,##0.00"
```

### 3. Handle Division by Zero
```dax
-- GOOD: Safe division
VAR Result =
    DIVIDE(
        CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date])),
        CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
    )
RETURN
    IF(ISBLANK(Result) OR Result = BLANK(), 0, Result) - 1

-- BAD: Potential error
CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date])) /
CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date])) - 1
```

### 4. Apply to Specific Measures
```dax
-- Only apply to certain measures:
CALCULATE(
    SELECTEDMEASURE(),
    DATESYTD('Date'[Date]),
    -- Only apply to measures containing "Sales"
    CONTAINSSTRING(SELECTEDMEASURENAME(), "Sales")
)
```

### 5. Calculation Item Dependencies
```dax
-- When items reference other items, use CALCULATIONGROUP:
CALCULATE(
    SELECTEDMEASURE(),
    CALCULATIONGROUP("Time Intelligence", "YTD")
)
```

## Multiple Calculation Groups

### Priority Matters
When using multiple calculation groups, the **Priority** property determines order of application:

```
Priority (higher = applied first):
- Currency: 100
- Time Intelligence: 50
- Units: 10
```

### Example: Currency + Time Intelligence
```
Result = Time Intelligence applied to Currency converted measure
OR
Result = Currency applied to Time Intelligence measure
(Depends on Priority)
```

## Common Issues and Solutions

### Issue: Wrong Results with CALCULATE
```dax
-- PROBLEM: CALCULATE removes previous filters
CALCULATE(
    SELECTEDMEASURE(),
    'Date'[Year] = 2024
)

-- SOLUTION: Use KEEPFILTERS
CALCULATE(
    SELECTEDMEASURE(),
    KEEPFILTERS('Date'[Year] = 2024)
)
```

### Issue: Circular Dependency
```dax
-- PROBLEM: Measure references itself through calc group
-- SOLUTION: Avoid direct measure references in calc groups
```

### Issue: Format Not Applying
```dax
-- Ensure Format String Expression is set:
SELECTEDMEASUREFORMATSTRING()

-- Or specific format:
0.0%;-0.0%;0.0%
```

### Issue: Not Working with Specific Measures
```dax
-- Calculation groups don't work with:
-- - Dynamic format strings (prior to 2022)
-- - Certain MDX queries
-- - Excel pivot tables (may need Excel 2016+)
```

## Using Calculation Groups in Reports

### Slicer Setup
1. Add the calculation group column to a slicer
2. Users select the calculation dynamically
3. All measures automatically apply the selected calculation

### Visual Interactions
```
Time Intelligence Slicer → Applied to all visuals
Currency Selector → Applied to financial visuals only
```

## Validation Checklist

- [ ] Tabular Editor installed and accessible
- [ ] Calculation group table created
- [ ] Calculation items defined with correct DAX
- [ ] Ordinal set for display order
- [ ] Format string expression configured
- [ ] Priority set (if multiple groups)
- [ ] Tested with multiple measures
- [ ] Dynamic titles configured (if needed)
- [ ] Hidden items properly configured
- [ ] Documentation updated

## Code Template

```dax
-- Calculation Group: Time Intelligence
-- Description: Common time intelligence calculations

-- Priority: 50
-- Format String Expression: SELECTEDMEASUREFORMATSTRING()

-- Items:
-- 1. Current (Ordinal: 0)
SELECTEDMEASURE()

-- 2. YTD (Ordinal: 1)
CALCULATE(
    SELECTEDMEASURE(),
    DATESYTD('Date'[Date])
)

-- 3. PY (Ordinal: 2)
CALCULATE(
    SELECTEDMEASURE(),
    SAMEPERIODLASTYEAR('Date'[Date])
)

-- 4. YoY % (Ordinal: 3)
VAR CurrentYTD =
    CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date]))
VAR PriorYTD =
    CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
RETURN
    IF(
        ISBLANK(PriorYTD) OR PriorYTD = 0,
        BLANK(),
        DIVIDE(CurrentYTD - PriorYTD, PriorYTD)
    )
```

## Comparison: Before vs After

### Before Calculation Groups
```dax
-- Dozens of duplicated measures:
Total Sales = SUM(Sales[Amount])
YTD Sales = TOTALYTD([Total Sales], 'Date'[Date])
PY Sales = CALCULATE([Total Sales], SAMEPERIODLASTYEAR('Date'[Date]))
YoY Sales % = ...

Total Profit = SUM(Sales[Profit])
YTD Profit = TOTALYTD([Total Profit], 'Date'[Date])
PY Profit = CALCULATE([Total Profit], SAMEPERIODLASTYEAR('Date'[Date]))
YoY Profit % = ...

-- 30+ measures for basic time intelligence
```

### After Calculation Groups
```dax
-- One calculation group, same result:
Total Sales = SUM(Sales[Amount])
Total Profit = SUM(Sales[Profit])

-- User selects "YTD" from slicer
-- Both measures automatically show YTD values
```

---

**AIDEV-NOTE**: Calculation groups are a powerful feature but require Tabular Editor. Always test thoroughly before deploying, as calculation errors affect ALL measures.
