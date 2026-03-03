# CI/CD and Deployment for Power BI

## Overview

CI/CD (Continuous Integration/Continuous Deployment) for Power BI enables automated testing, validation, and deployment of PBIP projects. This ensures consistent, reliable updates to Power BI reports.

## Deployment Options

| Option | Best For | Complexity |
|--------|----------|------------|
| Power BI Automate | Simple deployments | Low |
| PowerShell + Power BI REST API | Programmatic control | Medium |
| Azure DevOps/GitHub Actions | Full CI/CD pipeline | High |
| Fabric/Power BI Deployment Pipelines | No-code, visual | Medium |

## Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  Development│──────▶│    Test     │──────▶│ Production  │
│   Workspace │      │  Workspace  │      │  Workspace  │
└─────────────┘      └─────────────┘      └─────────────┘
       │                     │                     │
       ▼                     ▼                     ▼
   Dev PBIP              Test PBIP             Prod Report
```

## Preparing for CI/CD

### 1. PBIP Format
```
Convert .pbix to .pbip:
- Open Power BI Desktop
- File → Save As → Power BI Project
- Enables source control and automation
```

### 2. Source Control Structure
```
git-repo/
├── .github/                 # GitHub Actions
│   └── workflows/
│       └── deploy.yml
├── .azure-pipelines/        # Azure DevOps
│   └── powerbi-deploy.yml
├── report/                  # PBIP project
│   ├── .pbir
│   ├── .pbiproj
│   ├── DataModelSchema
│   ├── report/
│   └── ...
├── tests/                   # Pester tests
│   └── model.tests.ps1
└── deploy/                  # Deployment scripts
    ├── deploy-dev.ps1
    ├── deploy-test.ps1
    └── deploy-prod.ps1
```

## Deployment Methods

### Method 1: Power BI Deployment Pipelines (No-Code)

#### Setup
1. Go to Power BI Service
2. Navigate to Deployment Pipelines
3. Create new pipeline
4. Add stages: Dev → Test → Production

#### Usage
```
1. Deploy PBIP to Dev workspace
2. Review in Dev
3. Promote to Test
4. Validate in Test
5. Promote to Production
```

#### Pros/Cons
```
Pros:
- No coding required
- Visual interface
- Built-in comparison
- Supports selective deployment

Cons:
- Limited flexibility
- No automated testing
- Manual steps required
```

### Method 2: PowerShell + REST API

#### Prerequisites
```powershell
# Install Power BI PowerShell module
Install-Module -Name MicrosoftPowerBIMgmt

# Connect to Power BI
Connect-PowerBIServiceAccount
```

#### Deployment Script Template
```powershell
# deploy-pbip.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$WorkspaceName,

    [Parameter(Mandatory=$true)]
    [string]$ReportPath,

    [Parameter(Mandatory=$true)]
    [string]$ReportName
)

# Login
Connect-PowerBIServiceAccount

# Get workspace
$workspace = Get-PowerBIWorkspace -Name $WorkspaceName

# Check if report exists
$existingReport = Get-PowerBIReport -WorkspaceId $workspace.Id -Name $ReportName

if ($existingReport) {
    # Update existing report
    Write-Host "Updating existing report: $ReportName"

    # Upload new PBIP
    $report = New-PowerBIReport `
        -Path $ReportPath `
        -WorkspaceId $workspace.Id `
        -Name $ReportName `
        -ConflictAction CreateOrOverwrite
} else {
    # Create new report
    Write-Host "Creating new report: $ReportName"

    $report = New-PowerBIReport `
        -Path $ReportPath `
        -WorkspaceId $workspace.Id `
        -Name $ReportName
}

Write-Host "Report deployed successfully: $($report.WebUrl)"
```

### Method 3: GitHub Actions

#### Workflow Template
```yaml
# .github/workflows/deploy-powerbi.yml
name: Deploy Power BI Report

on:
  push:
    branches:
      - main
    paths:
      - 'report/**'

env:
  WORKSPACE_NAME: 'Production Workspace'
  REPORT_PATH: 'report'
  REPORT_NAME: 'Sales Report'

jobs:
  validate:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3

      - name: Validate PBIP
        run: |
          # Run pbi-tools validate
          pbi-tools validate -path ${{ env.REPORT_PATH }}

      - name: Run Tests
        run: |
          # Run Pester tests
          Invoke-Pester -Path tests/ -OutputFormat NUnitXml

  deploy:
    needs: validate
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Power BI module
        run: Install-Module -Name MicrosoftPowerBIMgmt -Force

      - name: Connect to Power BI
        env:
          POWERBI_CLIENT_ID: ${{ secrets.POWERBI_CLIENT_ID }}
          POWERBI_CLIENT_SECRET: ${{ secrets.POWERBI_CLIENT_SECRET }}
        run: |
          $password = ConvertTo-SecureString $env:POWERBI_CLIENT_SECRET -AsPlainText -Force
          $credential = New-Object System.Management.Automation.PSCredential ($env:POWERBI_CLIENT_ID, $password)
          Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -TenantId ${{ secrets.TENANT_ID }}

      - name: Deploy Report
        run: |
          .\deploy\deploy-prod.ps1 `
            -WorkspaceName ${{ env.WORKSPACE_NAME }} `
            -ReportPath ${{ env.REPORT_PATH }} `
            -ReportName ${{ env.REPORT_NAME }}

      - name: Update Parameters
        run: |
          # Update dataset parameters
          .\deploy\update-parameters.ps1 `
            -WorkspaceName ${{ env.WORKSPACE_NAME }} `
            -DatasetName ${{ env.REPORT_NAME }} `
            -Parameters @{
                'Server' = 'prod-server.database.windows.net'
                'Database' = 'prod-database'
            }
```

### Method 4: Azure DevOps

#### Pipeline Template
```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: windows-latest

variables:
  workspaceName: 'Production Workspace'
  reportPath: 'report'
  reportName: 'Sales Report'

stages:
  - stage: Validate
    jobs:
      - job: Validate
        steps:
          - task: PowerShell@2
            displayName: 'Validate PBIP'
            inputs:
              pwsh: true
              script: |
                pbi-tools validate -path $(reportPath)

  - stage: Deploy
    dependsOn: Validate
    condition: succeeded()
    jobs:
      - deployment: DeployToProduction
        environment: 'Production'
        strategy:
          runOnce:
            deploy:
              steps:
                - checkout: self

                - task: PowerShell@2
                  displayName: 'Deploy to Power BI'
                  inputs:
                    pwsh: true
                    script: |
                      .\deploy\deploy-prod.ps1 `
                        -WorkspaceName $(workspaceName) `
                        -ReportPath $(reportPath) `
                        -ReportName $(reportName)
```

## Automated Testing

### Pester Tests for Model Quality
```powershell
# tests/model.tests.ps1
Describe "Power BI Model Validation" {
    BeforeAll {
        # Import Power BI module
        Import-Module MicrosoftPowerBIMgmt
        Connect-PowerBIServiceAccount

        # Get model
        $workspace = Get-PowerBIWorkspace -Name "Test Workspace"
        $dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id
    }

    Context "Model Structure" {
        It "Should have at least one Date table" {
            $model = Invoke-PowerBIRestMethod `
                -Url "datasets/$($dataset.Id)/model" `
                -Method Get

            $dateTables = $model.tables | Where-Object { $_.isDateTable -eq $true }
            $dateTables.Count | Should -BeGreaterOrEqual 1
        }

        It "Should not have bidirectional relationships" {
            $model = Invoke-PowerBIRestMethod `
                -Url "datasets/$($dataset.Id)/model" `
                -Method Get

            $biDiRels = $model.relationships | Where-Object {
                $_.crossFilteringBehavior -eq "Both"
            }
            $biDiRels.Count | Should -Be 0
        }
    }

    Context "Measures" {
        It "Should have descriptions for all measures" {
            # Check measure descriptions
            # ...
        }
    }
}
```

## Environment Management

### Configuration by Environment
```powershell
# config/dev.ps1
$config = @{
    WorkspaceName = "Development Workspace"
    Server = "dev-server.database.windows.net"
    Database = "dev-database"
    RefreshSchedule = @{
        Enabled = $false
    }
}

# config/prod.ps1
$config = @{
    WorkspaceName = "Production Workspace"
    Server = "prod-server.database.windows.net"
    Database = "prod-database"
    RefreshSchedule = @{
        Enabled = $true
        Frequency = "Daily"
        Time = "06:00"
    }
}
```

### Update Parameters
```powershell
# update-parameters.ps1
param(
    [string]$WorkspaceName,
    [string]$DatasetName,
    [hashtable]$Parameters
)

$workspace = Get-PowerBIWorkspace -Name $WorkspaceName
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id -Name $DatasetName

# Update parameters
foreach ($param in $Parameters.GetEnumerator()) {
    $updateUrl = "datasets/$($dataset.Id)/updates"
    $body = @{
        updateDetails = @(
            @{
                name = $param.Key
                newValue = $param.Value
            }
        )
    } | ConvertTo-Json

    Invoke-PowerBIRestMethod `
        -Url $updateUrl `
        -Method Post `
        -Body $body
}
```

## Best Practices

### 1. Branch Strategy
```
main (production)
  ↑
develop (staging)
  ↑
feature/* (development)
```

### 2. Validation Gates
```
Before deployment:
- Validate PBIP structure
- Run Pester tests
- Check for secrets
- Verify workspace access
- Test data source connectivity
```

### 3. Rollback Plan
```
- Keep previous version in backup workspace
- Tag releases in git
- Document rollback procedure
- Test rollback process
```

### 4. Access Control
```
- Use Service Principals for automation
- Store credentials in Key Vault
- Limit workspace permissions
- Audit deployment access
```

## Validation Checklist

- [ ] PBIP format enabled
- [ ] Source control configured
- [ ] Automated tests created
- [ ] Deployment script tested
- [ ] Service Principal created
- [ ] Credentials secured (Key Vault)
- [ ] Workspaces configured (Dev/Test/Prod)
- [ ] Deployment pipeline created
- [ ] Rollback procedure documented
- [ ] Monitoring/alerting configured

## Common Issues

### Issue: Service Principal Permissions
```powershell
# Solution: Enable Service Principal API access
# Admin portal → Tenant settings → Service principals
# Enable: "Allow service principals to use Power BI APIs"
```

### Issue: Large File Upload Timeout
```powershell
# Solution: Use multipart upload or increase timeout
$report = New-PowerBIReport `
    -Path $ReportPath `
    -WorkspaceId $workspace.Id `
    -Timeout 1800  # 30 minutes
```

### Issue: Dataset Refresh Fails
```powershell
# Solution: Update data source credentials
Update-PowerBIDatasource `
    -DatasetId $dataset.Id `
    -DatasourceId $datasource.Id `
    -Username $username `
    -Password $password
```

## Monitoring

### Deployment History
```powershell
# Get deployment history
Get-PowerBIActivityEvent `
    -StartDateTime (Get-Date).AddDays(-7) `
    -ActivityType 'UpdateReport'
```

### Dataset Refresh Monitoring
```powershell
# Check refresh history
$workspace = Get-PowerBIWorkspace -Name $workspaceName
$dataset = Get-PowerBIDataset -WorkspaceId $workspace.Id

Invoke-PowerBIRestMethod `
    -Url "datasets/$($dataset.Id)/refreshes" `
    -Method Get
```

---

**AIDEV-NOTE**: Always test deployment scripts in a non-production environment first. Use Service Principals with limited scope for automation, never personal accounts.
