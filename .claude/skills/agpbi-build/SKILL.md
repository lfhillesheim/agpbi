---
name: build
description: Run the Build stage - implement Power BI solution with best practices
parameters:
  - name: project_name
    description: Name of the PBIP project to build
    required: true
---

# Build Stage Workflow

You are running the **Build** stage for: **$project_name**

## Pre-Flight Check

⚠️ **STOP** if Validate stage is not complete:
- [ ] analise-dados.md exists
- [ ] validacao-numeros.md exists
- [ ] wireframe.md exists
- [ ] riscos.md exists
- [ ] tecnica.md exists
- [ ] Go/No-Go decision is GO

If any are missing, run `/validate` first.

## Build Lifecycle - 10 Steps

### Step 1: Conexão 🔌
- Set up all data connections
- Configure Power BI Gateway if needed
- Test credentials and refresh
- Document connection parameters

**MCP Tools**:
```javascript
connection_operations(operation: "ListConnections")
```

### Step 2: ETL (Power Query) 🔄
- Build transformation logic
- Handle data quality issues
- Optimize query folding
- Document transformation steps

**Best Practices**:
- Enable fast combine (if privacy allows)
- Use native database queries when appropriate
- Remove unnecessary columns early
- Handle nulls and errors gracefully

### Step 3: Modelagem Dimensional ⭐
- Design Star Schema
- Create dimension tables
- Create fact tables
- Set proper data types
- Hide technical columns

**Checklist**:
- [ ] Fact tables contain measures (numbers)
- [ ] Dimension tables contain attributes (descriptions)
- [ ] Relationships: 1:* from dimension to fact
- [ ] Single direction cross-filter (default)
- [ ] Date table marked as Date Table

### Step 4: Relacionamentos 🔗
- Configure cardinality correctly
- Set cross-filter direction
- Activate/deactivate as needed
- Document relationship logic

**MCP Tools**:
```javascript
relationship_operations(operation: "List")
relationship_operations(operation: "Create", ...)
```

### Step 5: Cálculos DAX 📊
- Create measures for ALL business metrics
- Use calculated columns only when necessary
- Format all measures properly
- Document every measure

**Best Practices**:
```dax
// Good - Measure for aggregation
Total Sales = SUM(Sales[Amount])

// Bad - Calculated column (use measure instead)
Sales Amount = Sales[Quantity] * Sales[UnitPrice]

// Good - Using variables for clarity
YTD Sales =
VAR CurrentDate = MAX('Date'[Date])
VAR YearStart = DATE(YEAR(CurrentDate), 1, 1)
RETURN
    CALCULATE(
        [Total Sales],
        DATESBETWEEN('Date'[Date], YearStart, CurrentDate)
    )
```

**MCP Tools**:
```javascript
measure_operations(
  operation: "Create",
  definitions: [{
    name: "Total Sales",
    tableName: "Sales",
    expression: "SUM(Sales[Amount])",
    formatString: "$#,##0",
    description: "Sum of all sales amounts"
  }]
)
```

### Step 6: Visuais 📈
- Build from wireframe
- Use appropriate chart types
- Ensure accessibility
- Optimize for performance
- Test interactions

**Guidelines**:
- Bar/Column: Comparisons
- Line: Trends over time
- Pie/Donut: Part-to-whole (use sparingly)
- Table/Matrix: Detailed data
- Cards: Single KPIs
- Scatter: Correlations

### Step 7: Design UI/UX 🎨
- Apply consistent theme
- Follow color palette
- Ensure proper hierarchy
- Mobile-responsive if needed
- Test usability

**Principles**:
- Most important info at top left
- Related visuals near each other
- Consistent filter placement
- Clear titles and labels
- Purposeful color (not decorative)

### Step 8: Orquestração ⏰
- Configure refresh schedule
- Set up incremental refresh if needed
- Configure error handling
- Set up monitoring
- Document refresh process

**MCP Tools**:
```javascript
model_operations(operation: "GetStats")
```

### Step 9: Documentação 📚
Create all mandatory documents:

1. **documentacao-tecnica.md** - Technical architecture
2. **documentacao-negocio.md** - Business user guide
3. **manual-usuario.md** - End user manual
4. **rls.md** (if applicable) - Security configuration
5. **gateway.md** (if applicable) - Gateway setup
6. **checklist-entrega.md** - Quality checklist

### Step 10: Segurança 🔒
- Implement RLS if needed
- Configure role permissions
- Test security roles
- Document security setup
- Train users on access

**MCP Tools**:
```javascript
security_role_operations(operation: "List")
security_role_operations(operation: "Create", ...)
```

## Quality Gates

Before delivery, ensure:

### Model Quality
- [ ] Star Schema implemented
- [ ] All relationships configured correctly
- [ ] No circular dependencies
- [ ] Technical columns hidden
- [ ] Date table marked

### Measure Quality
- [ ] All measures have descriptions
- [ ] All measures formatted
- [ ] No unnecessary calculated columns
- [ ] Measures follow naming convention
- [ ] Error handling in place

### Visual Quality
- [ ] All visuals from wireframe present
- [ ] Titles are clear and descriptive
- [ ] Colors are consistent
- [ ] Tooltips are informative
- [ ] Accessibility is OK

### Documentation Quality
- [ ] Technical docs complete
- [ ] Business docs clear
- [ ] User manual written
- [ ] Security documented (if needed)
- [ ] Gateway documented (if needed)

### Testing
- [ ] All measures return correct values
- [ ] Refresh completes successfully
- [ ] Performance is acceptable
- [ ] RLS restricts data correctly (if applicable)
- [ ] Mobile layout works (if applicable)

## Common Anti-Patterns to Avoid

❌ **Bi-directional relationships everywhere**
→ Use single direction by default

❌ **Calculated columns for aggregations**
→ Use measures instead

❌ **Hiding business metrics**
→ Keep important measures visible

❌ **Complex DAX without comments**
→ Document WHY, not WHAT

❌ **Forgetting to hide keys**
→ Hide technical columns from report view

❌ **Hardcoding values**
→ Use parameters or measures

❌ **No descriptions on measures**
→ Every measure needs a description

## Success Criteria

Build is complete when:
- [ ] PBIP file opens without errors
- [ ] All measures validated
- [ ] Performance acceptable (< 5 sec load)
- [ ] Documentation complete
- [ ] User training done
- [ ] Client sign-off received

---

**Remember**: This is production code. Quality, documentation, and user experience matter.
