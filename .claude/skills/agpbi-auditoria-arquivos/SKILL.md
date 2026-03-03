---
name: agpbi-auditoria-arquivos
description: Complete audit of file organization, structure, and quality
---

# File Governance Audit

Perform comprehensive audit of project file organization.

## Audit Categories

### 1. Structure Compliance (Weight: 30%)
- [ ] All required folders exist
- [ ] No folders in wrong locations
- [ ] Naming convention followed
- [ ] No deep nesting (>5 levels)

### 2. File Placement (Weight: 25%)
- [ ] Files in correct phase folders
- [ ] No loose files in root
- [ ] Images in Documentation/imagens/
- [ ] PBIPs in correct location

### 3. Completeness (Weight: 20%)
- [ ] Vision: All 5 docs present
- [ ] Validate: All 5 docs present
- [ ] Build: All docs present if started
- [ ] README.md present

### 4. File Quality (Weight: 15%)
- [ ] No duplicate files
- [ ] No temporary files
- [ ] Markdown files have metadata
- [ ] No excessively large files (>100MB in wrong place)

### 5. References (Weight: 10%)
- [ ] No broken internal links
- [ ] Cross-references valid
- [ ] External links work (optional)

## Process

1. **Scan all files**
   ```bash
   find . -type f -name "*.md" > all_files.txt
   ```

2. **Check structure**
   ```bash
   ls -d 00-contexto 01-vision 02-validate 03-build 04-reunioes 05-atividades 06-decisoes
   ```

3. **Count files by location**
   ```bash
   find . -type f -name "*.md" | sed 's!/.*!!' | sort | uniq -c
   ```

4. **Find misplaced files**
   - Files in root that shouldn't be
   - Files in wrong phase folder
   - Images not in Documentation/imagens/

5. **Check for duplicates**
   ```bash
   fdupes -r . | head -50
   ```

6. **Check for temp files**
   ```bash
   find . -type f \( -name "*.tmp" -o -name "*.bak" -o -name "~$*" \)
   ```

7. **Validate references**
   - Check markdown links
   - Verify referenced files exist

## Scoring

```python
def calculate_score(audit_results):
    structure = (correct_folders / total_folders) * 30
    placement = (correct_placed / total_files) * 25
    completeness = (required_present / required_total) * 20
    quality = (quality_checks / total_quality_checks) * 15
    references = (valid_links / total_links) * 10
    return structure + placement + completeness + quality + references
```

## Output

```markdown
# Auditoria de Governança de Arquivos

**Data**: YYYY-MM-DD HH:MM
**Score**: XX/100 - [Rating]
**Arquivos Auditados**: N

## 📊 Score Breakdown

| Categoria | Peso | Score | Notas |
|-----------|------|-------|-------|
| Estrutura | 30% | XX/30 | |
| Localização | 25% | XX/25 | |
| Completude | 20% | XX/20 | |
| Qualidade | 15% | XX/15 | |
| Referências | 10% | XX/10 | |

## ✅ Strengths
- Strength 1
- Strength 2

## ⚠️ Issues Found

### Alta Prioridade (5)
1. **[Issue]**
   - **Impacto**: [High/Medium/Low]
   - **Ação**: [What to do]
   - **Responsável**: [Who should do it]

### Média Prioridade (N)
[Same format]

### Baixa Prioridade (N)
[Same format]

## 📁 Structure Analysis
- Pastas requeridas: 7
- Pastas encontradas: N
- Pastas faltando: [list]

## 📄 File Placement Analysis
- Total de arquivos: N
- No lugar certo: N (X%)
- Fora do lugar: N (X%)
- Sem categoria: N (X%)

## 🗑️ Cleanup Needed
- Arquivos temporários: N
- Arquivos duplicados: N
- Espaço recuperável: X MB

## 🎯 Recommendations
1. [Action 1]
2. [Action 2]
3. [Action 3]

## 📋 Next Actions
- [ ] [Action 1] - Priority - Owner
- [ ] [Action 2] - Priority - Owner

---

**Relatório gerado em**: X segundos
**Próxima auditoria recomendada**: 1 semana
```

## Ratings

- **95-100**: Excellent - Perfect organization
- **85-94**: Good - Minor issues
- **70-84**: Fair - Some organization needed
- **50-69**: Poor - Significant issues
- **< 50**: Critical - Major reorganization needed
