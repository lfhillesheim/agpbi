---
name: push-framework
description: Push framework changes - detects if change is general (main) or client-specific (branch)
parameters:
  - name: mudanca
    description: Descrição do que foi modificado
    required: true
---

# AGPBI Push Framework

You are managing the AGPBI framework with branch strategy:
- **main** = pure template (general benefits)
- **client-branches** = client-specific changes

## Current Context

Working directory: agpbi root
Current branch: {branch}

## Step 1: Analyze the Change

Based on user's description: **$mudanca**

Determine the **change type**:

### GENERAL (goes to main) ✅
Changes that benefit ALL clients:

| Type | Examples |
|------|----------|
| New skill | `/agpbi-xxx` new command |
| Skill improvement | Better `/agpbi-vision` |
| New agent | New specialist agent |
| Bug fix | Framework error correction |
| New script | Useful utility for everyone |
| Documentation | README, framework docs |
| Framework structure | `.claude/`, `_framework/` changes |

### CLIENT-SIFIC (stays in branch) 🏢
Changes for ONE client only:

| Type | Examples |
|------|----------|
| Client data | Topmed info, contacts |
| Projects | `topmed-financeiro` project files |
| Customizations | Client branding, colors |
| Specific data | Client URLs, APIs |
| Client docs | Context of specific client |

## Step 2: Confirm with User

```yaml
Based on: "$mudanca"
My analysis: [GENERAL or CLIENT-SPECIFIC]
Reason: [why]
```

Ask user to confirm if correct.

## Step 3: Execute Git Operations

### If GENERAL (main):

```bash
# 1. Stash changes
git stash

# 2. Go to main
git checkout main

# 3. Apply changes
git stash pop

# 4. Commit
git add .
git commit -m "feat: [description]"
git push

# 5. Update all client branches
for branch in topmed empresa-x; do
    git checkout $branch
    git merge main
    git push
done

# 6. Return to main
git checkout main
```

### If CLIENT-SPECIFIC (current branch):

```bash
# 1. Check we're in client branch
git checkout [current-client-branch]

# 2. Commit
git add .
git commit -m "feat: [description]"
git push
```

## Step 4: Report

```yaml
Action taken: [merged to main / committed to branch]
Branches updated: [list]
Next: [user can continue working]
```

## Important

- ALWAYS ask user to confirm change type before executing
- NEVER push to main without explicit confirmation
- List all files that will be affected
- If unsure, ask user: "This benefits all clients?"
