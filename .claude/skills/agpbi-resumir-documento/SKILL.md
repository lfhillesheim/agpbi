---
name: agpbi-resumir-documento
description: Read, interpret, and summarize a document
parameters:
  - name: file_path
    description: Path to document to summarize
    required: true
  - name: detail_level
    description: brief/standard/detailed
    required: false
    default: standard
---

# Summarize Document

Read a document and generate a structured summary.

## Process

1. **Read the document**
2. **Identify document type** (Vision/Validate/Build/Meeting/Activity/Decision)
3. **Extract key information**
4. **Generate structured summary**

## Output Format

```markdown
# Resumo: [Document Name]

## 📋 Metadados
- **Tipo**: [Vision/Validate/Build/Reunião/Atividade/Decisão]
- **Data**: [Last modified]
- **Localização**: [path/to/file]
- **Status**: [Em andamento/Completo/Bloqueado]

## 🎯 Propósito
[Brief description of document's purpose]

## 📌 Pontos Chave
- Point 1
- Point 2
- Point 3

## ✅ Decisões Documentadas
- Decision 1
- Decision 2

## 📊 Dados e Métricas
- Data point 1
- Data point 2

## 👥 Pessoas e Responsabilidades
- Person A - Role
- Person B - Responsibility

## ⚠️ Riscos e Bloqueadores
- Risk 1
- Blocker 1

## 📅 Próximos Passos
- Step 1
- Step 2

## 🔗 Relacionamentos
- References to: [other documents]
- Referenced by: [other documents]

## 📈 Progresso
- [ ] Item 1
- [x] Item 2
```

## Detail Levels

### Brief
- Purpose only
- Top 3 points
- No details

### Standard
- All sections above
- 5-10 key points
- Next steps included

### Detailed
- All sections above
- All points included
- Full context
- All relationships
