# Framework Pattern Index

This index maintains a searchable catalog of all proven patterns and anti-patterns across the AGPBI framework.

## Purpose

- Quick lookup of patterns by category
- Cross-reference with skills
- Track pattern usage frequency
- Identify candidates for automation

## Pattern Index Structure

```json
{
  "patterns": {
    "data_modeling": [
      {
        "id": "pattern-star-schema-fact-degenerate",
        "name": "Degenerate Dimension in Fact Table",
        "category": "data_modeling",
        "description": "Keep transaction identifiers in fact table instead of separate dimension",
        "use_case": "Order numbers, invoice IDs that have no attributes",
        "frequency": 15,
        "projects_used": ["client-a", "client-b", "client-c"],
        "status": "proven",
        "related_skill": null,
        "related_reference": "STAR-SCHEMA.md",
        "added_at": "2026-02-15"
      }
    ],
    "dax": [
      {
        "id": "pattern-divide-function",
        "name": "DIVIDE() Instead of /",
        "category": "dax",
        "description": "Always use DIVIDE() for safe division",
        "use_case": "All division operations",
        "frequency": 50,
        "projects_used": ["all"],
        "status": "proven",
        "related_skill": "criar-medida",
        "related_reference": "MEASURES-DAX.md",
        "added_at": "2026-02-01"
      }
    ],
    "power_query": [
      {
        "id": "pattern-query-folding",
        "name": "Query Folding for Performance",
        "category": "power_query",
        "description": "Ensure M operations fold to source SQL",
        "use_case": "All source queries",
        "frequency": 20,
        "projects_used": ["client-a", "client-b", "client-d"],
        "status": "proven",
        "related_skill": "otimizar-query",
        "related_reference": "PERFORMANCE.md",
        "added_at": "2026-03-02"
      }
    ]
  },
  "anti_patterns": [
    {
      "id": "anti-bidirectional-default",
      "name": "Bi-directional as Default",
      "category": "relationships",
      "description": "Using bi-directional relationships without justification",
      "problem": "2-10x slower queries, ambiguous paths",
      "solution": "Use single-direction, add AIDEV-QUESTION if needed",
      "frequency": 8,
      "projects_seen": ["client-a", "client-c", "client-e"],
      "status": "documented"
    }
  ],
  "skill_candidates": [
    {
      "id": "candidate-incremental-refresh",
      "name": "Incremental Refresh Configuration",
      "pattern_frequency": 5,
      "description": "Manual incremental refresh setup repeated across projects",
      "status": "implemented",
      "implemented_as": "configurar-incremental-refresh",
      "implemented_at": "2026-03-02"
    }
  ]
}
```

## Pattern Status Values

| Status | Meaning |
|--------|---------|
| `emerging` | Seen in 1-2 projects, promising |
| `proven` | Seen in 3+ projects, validated |
| `documented` | Added to references |
| `automated` | Implemented as skill/hook |
| `deprecated` | No longer recommended |

## Adding New Patterns

### From Retrospective
```yaml
When pattern identified in retrospective:
  1. Add to patterns index with status "emerging"
  2. Track frequency across projects
  3. At frequency = 3, promote to "proven"
  4. If applicable, create skill candidate
```

### From Pattern Detector
```yaml
Pattern detector:
  1. Scans all .context/ directories
  2. Identifies repeated patterns
  3. Adds to index automatically
  4. Suggests skill creation
```

## Maintenance

### Monthly Review
```yaml
- Review emerging patterns
- Update frequencies
- Promote proven patterns
- Identify automation candidates
- Remove deprecated patterns
```

### Quarterly Cleanup
```yaml
- Archive patterns not used in 6+ months
- Consolidate similar patterns
- Update documentation references
- Check skills still relevant
```

---

**Purpose**: Make framework wisdom discoverable and reusable.
