---
name: inicializar-pbip
description: Initialize a new PBIP project with proper folder structure
parameters:
  - name: project_name
    description: Name of the PBIP project
    required: true
  - name: department
    description: Department/folder name
    required: true
---

# Initialize PBIP Project

Initialize a new Power BI Project (.pbip) with proper folder structure.

## Location
`03-build/projects/$department/`

## Create Structure

```bash
# Create PBIP folder
mkdir -p "$project_name.pbip"/{Model,Report,DataModelSchema,Definitions}

# Create .pbip file
touch "$project_name.pbip/.pbip"

# Create minimal model structure
mkdir -p "$project_name.pbip/Model/tables"
```

## Output
Empty PBIP project ready for development.

## Files Created
- `.pbip` - PBIP marker file
- `Model/` - Model definition folder
- `Report/` - Report definition folder
- `DataModelSchema/` - Power Query M queries
