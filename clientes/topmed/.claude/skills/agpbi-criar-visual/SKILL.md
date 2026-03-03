---
name: criar-visual
description: Create Power BI visual in report
parameters:
  - name: visual_type
    description: Type of visual (bar, line, card, matrix, etc)
    required: true
  - name: page_name
    description: Target page name
    required: true
  - name: data_fields
    description: Comma-separated list of: measure, dimension, measure
    required: true
  - name: title
    description: Visual title
    required: true
---

# Create Visual

Create a Power BI visual with appropriate configuration.

## Visual Types

| Type | Use For | Data Pattern |
|------|---------|--------------|
| bar | Comparisons | dimension, measure |
| column | Comparisons | dimension, measure |
| line | Trends over time | date, measure |
| card | Single KPI | measure |
| matrix | Detailed data | dimension1, dimension2, measure |
| pie | Part-to-whole | dimension, measure |

## MCP Usage

PBIP visuals are in `Report/` folder as JSON configs.

## Configuration

For each visual type, apply:
- Proper formatting (colors, labels)
- Tooltips
- Data labels (if appropriate)
- Title

## Example

**Input**:
```
visual_type: bar
page_name: Resumo
data_fields: DimProduto[Categoria], Total Vendas
title: Vendas por Categoria
```

**Creates**:
- Bar chart on page "Resumo"
- X-axis: Categoria
- Y-axis: Total Vendas
- Title: "Vendas por Categoria"
- Default formatting applied

## Auto-Configuration

Based on visual type:
- **bar**: Horizontal bars, sorted descending
- **line**: Date on X, measure on Y, markers
- **card**: Large number, label, no border
- **matrix**: Expandable rows, subtotals
