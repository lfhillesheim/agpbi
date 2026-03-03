---
name: configurar-rls
description: Configure Row-Level Security roles
parameters:
  - name: role_name
    description: Name of the RLS role
    required: true
  - name: filter_expression
    description: DAX filter expression
    required: true
  - name: members
    description: Users or groups assigned to role
    required: false
---

# Configure RLS

Configure Row-Level Security (RLS) for the data model.

## Best Practices

1. **Use USERNAME() or USERPRINCIPALNAME()**
   - USERNAME(): Works in Desktop (for testing)
   - USERPRINCIPALNAME(): Works in Service (production)

2. **Filter on dimension tables** (not fact)
   - Filter: DimCliente[Email] = USERPRINCIPALNAME()
   - Not: FactVendas[Email] (won't work well)

3. **Test with different users**
   - Use "View as roles" in Desktop
   - Verify data is filtered correctly

## MCP Usage

```javascript
security_role_operations(
  operation: "Create",
  roleName: "$role_name",
  filterExpression: "$filter_expression",
  modelPermission: "Read"
)
```

## Examples

### Example 1: Filter by Email
```dax
[Email] = USERPRINCIPALNAME()
```

### Example 2: Filter by Region (lookup)
```dax
VAR UserRegion =
    CALCULATETABLE(
        VALUES(DimVendedor[Regiao]),
        DimVendedor[Email] = USERPRINCIPALNAME()
    )
RETURN
    [Regiao] IN UserRegion
```

### Example 3: Default with dynamic
```dax
[Regiao] =
    VAR UserRegion =
        LOOKUPVALUE(
            DimVendedor[Regiao],
            DimVendedor[Email], USERPRINCIPALNAME(),
            "Default"  // Return default if not found
        )
    RETURN
        UserRegion
```

## Testing

After creating role:
1. Modeling → Manage Roles
2. Select role
3. "View as roles"
4. Verify data is filtered
5. Test with different users

## Output
RLS role created and tested.
