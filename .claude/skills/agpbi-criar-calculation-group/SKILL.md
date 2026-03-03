---
name: criar-calculation-group
description: Create a calculation group for reusable DAX calculations (time intelligence, scenarios, etc.)
parameters:
  - name: group_name
    description: Name of the calculation group
    required: true
  - name: calculation_items
    description: List of calculation items with DAX expressions
    required: true
  - name: priority
    description: Priority for multiple calculation groups (higher = applied first)
    required: false
    default: 50
---

# Create Calculation Group

Create a calculation group for reusable DAX calculations that apply to all measures.

## What Are Calculation Groups?

Calculation groups allow you to define reusable calculations (time intelligence, currency conversion, scenarios) that apply to ANY measure - eliminating measure duplication.

## Benefits

- **Eliminate measure proliferation**: One calculation instead of many
- **Consistency**: Same logic applied to all measures
- **Maintainability**: Update in one place
- **User experience**: Dynamic calculation selection

## Prerequisites

- **Tabular Editor 2 or 3** must be installed
- Power BI Desktop must be open
- Model must already have measures defined

## MCP Usage

```javascript
// Calculation groups require Tabular Editor
// This skill provides guidance for manual creation

calculation_group_operations(
  operation: "Create",
  definitions: [{
    name: "$group_name",
    priority: $priority,
    calculationItems: $calculation_items
  }]
)
```

## Common Patterns

### Time Intelligence Group

```dax
Group Name: Time Intelligence
Priority: 50

Items:
1. Current (Ordinal: 0)
   Expression: SELECTEDMEASURE()

2. YTD (Ordinal: 1)
   Expression: CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date]))

3. PY (Ordinal: 2)
   Expression: CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))

4. YoY % (Ordinal: 3)
   Expression:
   VAR CurrentYTD = CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date]))
   VAR PriorYTD = CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
   RETURN IF(ISBLANK(PriorYTD) OR PriorYTD = 0, BLANK(), DIVIDE(CurrentYTD - PriorYTD, PriorYTD))

Format String: SELECTEDMEASUREFORMATSTRING()
```

### Currency Conversion Group

```dax
Group Name: Currency
Priority: 100

Items:
1. Local Currency
   Expression: SELECTEDMEASURE()

2. USD
   Expression: SELECTEDMEASURE() * [USD Exchange Rate]

3. EUR
   Expression: SELECTEDMEASURE() * [EUR Exchange Rate]
```

### Scenario Group

```dax
Group Name: Scenario
Priority: 75

Items:
1. Actual
   Expression: CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Actual")

2. Budget
   Expression: CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Budget")

3. Variance
   Expression:
   CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Budget") -
   CALCULATE(SELECTEDMEASURE(), 'Scenario'[Scenario] = "Actual")
```

## Creation Steps (Tabular Editor)

### Step 1: Open Tabular Editor
```
Power BI Desktop → External Tools → Tabular Editor
```

### Step 2: Create Calculation Group
```
Right-click "Tables" → Create New → Calculation Group
Name: $group_name
```

### Step 3: Set Properties
```
Priority: $priority
Format String Expression: SELECTEDMEASUREFORMATSTRING()
```

### Step 4: Add Calculation Items
```
Right-click Calculation Group → Add New Calculation Item

For each item:
- Name: Display name
- Ordinal: Display order (0, 1, 2, ...)
- Expression: DAX formula
```

### Step 5: Save and Refresh
```
File → Save
Return to Power BI Desktop → Refresh
```

## Using Calculation Groups in Reports

1. Add the calculation group column to a slicer
2. Users select calculations dynamically
3. All measures automatically apply the selected calculation

## Best Practices

### 1. Naming
```
Group: {Purpose} (e.g., "Time Intelligence", "Currency")
Items: {Action/Period} (e.g., "YTD", "PY", "YoY %")
```

### 2. Handle Division by Zero
```dax
// GOOD: Safe division
IF(ISBLANK(PriorValue) OR PriorValue = 0, BLANK(),
    DIVIDE(CurrentValue - PriorValue, PriorValue)
)
```

### 3. Use Dynamic Format Strings
```dax
// Respects parent measure format
Format String Expression: SELECTEDMEASUREFORMATSTRING()

// Or specific format for percentages
Format String Expression: 0.0%;-0.0%;0.0%
```

### 4. Multiple Groups - Set Priority
```
Higher priority = applied first:
- Currency: 100 (convert first)
- Time Intelligence: 50 (apply on converted values)
- Units: 10 (format last)
```

## Validation Checklist

- [ ] Tabular Editor installed
- [ ] Calculation group created
- [ ] Calculation items defined
- [ ] Ordinal set for each item
- [ ] Format string expression configured
- [ ] Priority set (if multiple groups)
- [ ] Tested with multiple measures
- [ ] Slicer added to report
- [ ] Results verified

## Before vs After

### Before Calculation Groups
```dax
Total Sales = SUM(Sales[Amount])
YTD Sales = TOTALYTD([Total Sales], 'Date'[Date])
PY Sales = CALCULATE([Total Sales], SAMEPERIODLASTYEAR('Date'[Date]))
YoY Sales % = ...

Total Profit = SUM(Sales[Profit])
YTD Profit = TOTALYTD([Total Profit], 'Date'[Date])
PY Profit = CALCULATE([Total Profit], SAMEPERIODLASTYEAR('Date'[Date]))
YoY Profit % = ...

// 30+ measures for basic time intelligence
```

### After Calculation Groups
```dax
Total Sales = SUM(Sales[Amount])
Total Profit = SUM(Sales[Profit])

// User selects "YTD" from slicer
// Both measures automatically show YTD values
```

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Wrong results | CALCULATE removes filters | Use KEEPFILTERS |
| Circular dependency | Measure references itself | Remove circular reference |
| Format not applying | Format string expression not set | Set format expression |
| Not working with specific measures | Measure limitation | Check measure compatibility |

## Example Input

```
group_name: Time Intelligence
calculation_items:
  - name: Current
    expression: SELECTEDMEASURE()
    ordinal: 0
  - name: YTD
    expression: CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date]))
    ordinal: 1
  - name: PY
    expression: CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
    ordinal: 2
  - name: YoY %
    expression: |
      VAR Current = CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date]))
      VAR Prior = CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
      RETURN IF(ISBLANK(Prior) OR Prior = 0, BLANK(), DIVIDE(Current - Prior, Prior))
    ordinal: 3
priority: 50
```

## References

- See `CALCULATION-GROUPS.md` for detailed guidance
