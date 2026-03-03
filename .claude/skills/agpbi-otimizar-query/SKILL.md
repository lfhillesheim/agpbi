---
name: agpbi-otimizar-query
description: Optimize Power Query M for query folding
parameters:
  - name: query_name
    description: Name of the query to optimize
    required: true
---

# Optimize Power Query

Optimize Power Query (M) to ensure query folding for better performance.

## Query Folding Best Practices

### ✅ DO (Folds to SQL)
- Table.SelectRows()
- Table.SelectColumns()
- Table.RenameColumns()
- Table.Sort()
- Table.Join() with JoinKind.Inner/LeftOuter

### ❌ DON'T (Prevents folding)
- Text.From() on columns
- List.PositionOf() with non-integer
- Table.TransformRows() with complex logic
- Custom functions that can't be translated

## Optimization Steps

1. **Remove unnecessary columns early**
   ```powerquery
   = Table.SelectColumns(Source, {"Col1", "Col2", "Col3"})
   ```

2. **Filter rows before transformations**
   ```powerquery
   = Table.SelectRows(Source, each [Status] = "Ativo")
   ```

3. **Use native database functions when possible**
   ```powerquery
   = Table.NestedJoin(...)
   // Not: Table.Combine with complex logic
   ```

4. **Avoid Text.From on numeric/date columns**
   ```powerquery
   // ❌ BAD
   = Table.AddColumn(Source, "AnoTexto", each Text.From([Ano]))

   // ✅ GOOD (keep as type)
   = Table.TransformColumnTypes(Source, {{"Ano", Int64.Type}})
   ```

5. **Use Table.Buffer only on small lookup tables**
   ```powerquery
   = Table.Buffer(DimStatus)  // OK for small dimension
   ```

## Check for Folding

After optimization:
1. Right-click query → View Native Query
2. If SQL is shown: ✅ Folding works
3. If "Formula.Firewall": ❌ No folding

## Output
Optimized M query with query folding enabled.
