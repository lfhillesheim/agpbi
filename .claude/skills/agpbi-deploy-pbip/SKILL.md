---
name: deploy-pbip
description: Deploy Power BI PBIP project to Power BI Service using PowerShell and REST API
parameters:
  - name: workspace_name
    description: Target workspace name
    required: true
  - name: report_path
    description: Local path to PBIP project folder
    required: true
  - name: report_name
    description: Name of the report in service
    required: true
  - name: environment
    description: Environment (dev, test, prod)
    required: true
  - name: update_parameters
    description: Whether to update dataset parameters
    required: false
    default: false
---

# Deploy PBIP to Power BI Service

Deploy a Power BI Project (PBIP) to Power BI Service using automated deployment scripts.

## Prerequisites

- **Power BI PowerShell module** installed
- **Service Principal** or account access
- **Workspace** created in service
- **PBIP format** project

## Setup

### Install PowerShell Module
```powershell
Install-Module -Name MicrosoftPowerBIMgmt -Force
```

### Service Principal (Recommended for CI/CD)
```powershell
# Create Service Principal in Azure AD
# Grant access to Power BI API
# Add to workspace as Admin

$clientId = "your-client-id"
$clientSecret = "your-client-secret"
$tenantId = "your-tenant-id"
```

## Deployment Steps

### Step 1: Build PBIP
```powershell
# Ensure PBIP is ready for deployment
# - Save all changes in Power BI Desktop
# - Close Power BI Desktop
# - Verify .pbip folder structure
```

### Step 2: Connect to Power BI
```powershell
# User authentication
Connect-PowerBIServiceAccount

# Or Service Principal
$password = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($clientId, $password)
Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -TenantId $tenantId
```

### Step 3: Get Workspace
```powershell
$workspace = Get-PowerBIWorkspace -Name "$workspace_name"
if (-not $workspace) {
    Write-Error "Workspace '$workspace_name' not found"
    exit 1
}
```

### Step 4: Deploy Report
```powershell
# Check if report exists
$existingReport = Get-PowerBIReport -WorkspaceId $workspace.Id -Name "$report_name"

if ($existingReport) {
    # Update existing report
    Write-Host "Updating existing report: $report_name"

    # Remove old report
    Remove-PowerBIReport -Id $existingReport.Id -WorkspaceId $workspace.Id

    # Upload new version
    $report = New-PowerBIReport `
        -Path "$report_path" `
        -WorkspaceId $workspace.Id `
        -Name "$report_name" `
        -ConflictAction CreateOrOverwrite
} else {
    # Create new report
    Write-Host "Creating new report: $report_name"

    $report = New-PowerBIReport `
        -Path "$report_path" `
        -WorkspaceId $workspace.Id `
        -Name "$report_name"
}

Write-Host "Report deployed successfully: $($report.WebUrl)"
```

### Step 5: Update Parameters (Optional)
```powershell
if ($update_parameters) {
    # Get dataset
    $dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id -Name "$report_name"

    # Update parameters
    $updateUrl = "datasets/$($dataset.Id)/updates"
    $body = @{
        updateDetails = @(
            @{ name = "Server"; newValue = "prod-server.database.windows.net" }
            @{ name = "Database"; newValue = "prod-database" }
        )
    } | ConvertTo-Json

    Invoke-PowerBIRestMethod `
        -Url $updateUrl `
        -Method Post `
        -Body $body
}
```

### Step 6: Configure Refresh
```powershell
# Set refresh schedule
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id -Name "$report_name"

$refreshSchedule = @{
    value = @{
        enabled = $true
        localTimeZoneId = "UTC"
        times = @(@{ hour = 6, minute = 0 })
        notifications = @{
            enabled = $true
        }
    }
} | ConvertTo-Json

Invoke-PowerBIRestMethod `
    -Url "datasets/$($dataset.Id)/refreshSchedule" `
    -Method Patch `
    -Body $refreshSchedule
```

## GitHub Actions Workflow

```yaml
# .github/workflows/deploy-powerbi.yml
name: Deploy Power BI Report

on:
  push:
    branches: [main]
    paths: ['report/**']

env:
  WORKSPACE: 'Production Workspace'
  REPORT_PATH: 'report'
  REPORT_NAME: 'Sales Report'

jobs:
  deploy:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3

      - name: Deploy to Power BI
        shell: pwsh
        env:
          POWERBI_CLIENT_ID: ${{ secrets.POWERBI_CLIENT_ID }}
          POWERBI_CLIENT_SECRET: ${{ secrets.POWERBI_CLIENT_SECRET }}
          TENANT_ID: ${{ secrets.TENANT_ID }}
        run: |
          .\.github\scripts\deploy-pbip.ps1 `
            -WorkspaceName ${{ env.WORKSPACE }} `
            -ReportPath ${{ env.REPORT_PATH }} `
            -ReportName ${{ env.REPORT_NAME }}
```

## Environment Configuration

### Development Environment
```powershell
$config = @{
    workspaceName = "Development Workspace"
    server = "dev-server.database.windows.net"
    database = "dev-database"
    refreshEnabled = $false
}
```

### Production Environment
```powershell
$config = @{
    workspaceName = "Production Workspace"
    server = "prod-server.database.windows.net"
    database = "prod-database"
    refreshEnabled = $true
    refreshFrequency = "Daily"
    refreshTime = "06:00 UTC"
}
```

## Validation Checklist

- [ ] Power BI PowerShell module installed
- [ ] Workspace exists in service
- [ ] Service Principal has workspace access
- [ ] PBIP project saved and closed
- [ ] Report path is correct
- [ ] Dataset parameters configured (if applicable)
- [ ] Data source credentials updated
- [ ] Refresh schedule configured
- [ ] Deployment tested in non-production first
- [ ] Rollback plan documented

## Best Practices

1. **Use Service Principals** for automation (never personal accounts)
2. **Separate Workspaces** for dev/test/prod
3. **Environment-specific Parameters** for each environment
4. **Test in Dev before Production**
5. **Version Control** all deployment scripts
6. **Monitor Refresh** after deployment
7. **Document Rollback** procedures

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Access Denied" | Insufficient permissions | Check workspace access for SP/user |
| "Report not found" | Report name mismatch | Verify exact report name |
| "Timeout" | Large file or slow network | Increase timeout, check connectivity |
| "Refresh failed" | Data source credentials | Update credentials in service |
| "Parameters not updated" | Dataset not found | Wait for dataset creation |

## Example Input

```
workspace_name: Production Workspace
report_path: C:\Projects\SalesDashboard\report
report_name: Sales Executive Dashboard
environment: prod
update_parameters: true
```

## Rollback Procedure

```powershell
# In case of failed deployment
$workspace = Get-PowerBIWorkspace -Name "$workspace_name"
$report = Get-PowerBIReport -WorkspaceId $workspace.Id -Name "$report_name"

# Option 1: Restore from backup workspace
$backupReport = Get-PowerBIReport -WorkspaceId $backupWorkspace.Id -Name "$report_name"
Copy-PowerBIReport -ReportId $backupReport.Id -TargetWorkspaceId $workspace.Id

# Option 2: Revert to previous version (if versioned in git)
git checkout previous-version
# Re-run deployment
```

## Monitoring

### Check Deployment Status
```powershell
$workspace = Get-PowerBIWorkspace -Name "$workspace_name"
$report = Get-PowerBIReport -WorkspaceId $workspace.Id -Name "$report_name"
Write-Host "Report URL: $($report.WebUrl)"
Write-Host "Last Updated: $($report.LastUpdate)"
```

### Check Refresh History
```powershell
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id -Name "$report_name"
$refreshes = Invoke-PowerBIRestMethod -Url "datasets/$($dataset.Id)/refreshes" -Method Get
$refreshes.value | Select-Object -First 5 | Format-Table startTime, status, duration
```

## References

- See `CICD-DEPLOYMENT.md` for detailed CI/CD guidance
