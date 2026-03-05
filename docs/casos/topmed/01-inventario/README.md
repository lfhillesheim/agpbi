# INVENTÁRIO POWER BI - TOPMED (COMPLETO)
## Análise Detalhada: Workspaces, Modelos, Relatórios e Segmentação

**Data**: 04/03/2026
**Fonte**: Catálogo OneLake exportado manualmente
**Status**: Análise Completa

---

## 1. NÚMEROS OFICIAIS

| Categoria | Quantidade | Observação |
|-----------|-----------|------------|
| **Modelos Semânticos** | **73** | Datasets semânticos |
| **Relatórios** | **1.543** | Dashboards/Reports |
| **DataFlows** | **16** | Fluxos de dados |
| **TOTAL DE ARTEFATOS** | **1.632** | Inventário completo |

**Comparação com estimativa anterior:**
- Estimávamos ~26 modelos → **Real: 73** (180% a mais)
- Estimávamos ~28 relatórios → **Real: 1.543** (5.400% a mais!)

---

## 2. DISTRIBUIÇÃO POR WORKSPACE

### Workspaces Principais (por volume de artefatos)

| Workspace | Relatórios | Modelos | DataFlows | Total |
|-----------|------------|---------|-----------|-------|
| **N/A (Não classificado)** | 364 | 0 | 1 | 365 |
| **Lista Beneficiários Cliente** | 207 | 0 | 0 | 207 |
| **Taxa Utilização** | 192 | 0 | 0 | 192 |
| **Saúde24h Standard** | 130 | 0 | 0 | 130 |
| **Entrelaços** | 118 | 0 | 0 | 118 |
| **Saúde24h Premium E+** | 88 | 0 | 0 | 88 |
| **Saúde24h Plus** | 81 | 0 | 0 | 81 |
| **BI TopMed 2** | 0 | 66 | 10 | 76 |
| **Saúde Emocional** | 74 | 0 | 0 | 74 |
| **Personalizado - Clientes** | 24 | 0 | 0 | 24 |

### Insights de Workspaces

1. **Desorganização**: 365 artefatos "N/A" - sem workspace definido
2. **Workspaces por produto**: Cada produto Topmed tem seu workspace (Saúde24h Plus, Standard, etc.)
3. **Workspaces por cliente**: "Personalizado - Clientes" agrega vários clientes específicos
4. **Centralização de modelos**: Todos os 66 modelos identificados estão em "BI TopMed 2"

---

## 3. SEGMENTAÇÃO POR PRODUTO TOPMED

### Portfólio Saúde24h

| Produto | Modelos | Relatórios | Total |
|---------|---------|------------|-------|
| **Saúde24h (todos)** | 9 | 597 | **606** |
| - Plus E+ | 1 | 88 | 89 |
| - Premium E+ | 1 | 88 | 89 |
| - Standard | 1 | 130 | 131 |
| - Smart E+ | 1 | 22 | 23 |
| - Smart | 1 | 14 | 15 |
| - Basic | 1 | ~10 | ~11 |
| - Plus | 1 | 81 | 82 |
| - PAV | 1 | ~20 | ~21 |
| - Geral | 3 | ~144 | ~147 |

**Insight**: Saúde24h representa **37% de todos os artefatos** (606 de 1.632)

### Outros Produtos

| Produto | Modelos | Relatórios | Total |
|---------|---------|------------|-------|
| **Lista Beneficiários** | 1 | 201 | **202** |
| **Taxa de Utilização** | 1 | 191 | **192** |
| **Saúde Emocional** | 2 | 119 | **121** |
| **Entrelaços** | 1 | 118 | **119** |
| **EAP/Teleconsulta** | 2 | 65 | **67** |
| **Crônicos** | 3 | 63 | **66** |
| **Nutrição (Nutricall)** | 2 | 60 | **62** |
| **Atendimentos** | 8 | 46 | **54** |

---

## 4. ANÁLISE POR DOMÍNIO/TEMA

```
┌─────────────────────────────────────────────────────────────────┐
│                  DISTRIBUIÇÃO POR TEMA                          │
├─────────────────────────────────────────────────────────────────┤
│  Saúde24h              ░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 37%         │
│  Lista Beneficiários  ░░░░░░░░░░ 12%                            │
│  Taxa Utilização      ░░░░░░░░░  12%                            │
│  Saúde Emocional      ░░░░░░░    7%                             │
│  Entrelaços           ░░░░░░░    7%                             │
│  EAP/Teleconsulta     ░░░░░      4%                            │
│  Crônicos             ░░░░░      4%                            │
│  Nutrição             ░░░░░      4%                            │
│  Atendimentos         ░░░░       3%                            │
│  Gerencial            ░░         2%                            │
│  Mapeamento Mental    ░          1%                            │
│  Admin/Monitoring     ░          1%                            │
│  Outros               ░░         6%                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. FRAGMENTAÇÃO: O PROBLEMA REAL

### 5.1 Taxa de Utilização - 192 Relatórios!

**Padrão identificado**: 1 relatório por município/cliente

```
Taxa Utilizacao - Prefeitura de Guaratuba
Taxa Utilizacao - Prefeitura de Guaramirim
Taxa Utilizacao - Prefeitura de Araquari
Taxa Utilizacao - ACAERT
Taxa Utilizacao - APAE Palhoca
Taxa Utilizacao - Allpfit
Taxa Utilizacao - A10 Beneficios
Taxa Utilizacao - Ferramentaria Demarchi
Taxa Utilizacao - BrFan
Taxa Utilizacao - Conecta+
Taxa Utilizacao - F&Fcred
Taxa Utilizacao - Grupo Rodocargas
Taxa Utilizacao - Jaslog
Taxa Utilizacao - Unafisco Saúde
... (192 no total)
```

**Impacto**: Se precisar alterar 1 visualização → **192 alterações manuais!**

### 5.2 Lista Beneficiários - 202 Relatórios por Cliente

**Padrão**: 1 relatório por empresa/cliente

```
Lista Beneficiários - BrFan
Lista Beneficiários - FABRICA CT
Lista Beneficiários - LOGOSUL
Lista Beneficiários - Planus
Lista Beneficiários - Tivoli
Lista Beneficiários - Unificado Mediclick
Lista Beneficiários - Unificado Unifie
Lista Beneficiários - Unificado Marsh
Lista Beneficiários - F&Fcred
... (202 no total)
```

### 5.3 Entrelaços - 118 Relatórios (59 versões "Nominais")

**Padrão**: 1 relatório padrão + 1 versão "Nominais" por cliente

```
Entrelaços - Zurich
Entrelaços - Zurich - Nominais
Entrelaços - Tivit - Nominais
Entrelaços - TopMed - Nominais
Entrelaços - Trouwnutricion - Nominais
Entrelaços - Unafisco - Nominais
Entrelaços - Uniclube - Nominais
Entrelaços - Unidas - Nominais
Entrelaços - Unificado Marsh - Nominais
Entrelaços - Vivara - Nominais
Entrelaços - VLI - Nominais
... (118 no total)
```

### 5.4 Saúde24h - 597 Relatórios

**Variações por produto**:
- Saúde24h Plus E+ (88 relatórios)
- Saúde24h Premium E+ (88 relatórios)
- Saúde24h Standard (130 relatórios)
- Saúde24h Smart E+ (22 relatórios)
- Saúde24h Smart (14 relatórios)
- Saúde24h Plus (81 relatórios)
- Outros (174 relatórios)

**Problema**: Cada cliente tem múltiplas versões por produto!

---

## 6. TOP CLIENTES (POR VOLUME DE RELATÓRIOS)

| Cliente | Relatórios | Tipo |
|---------|------------|------|
| **Nominais** | 64 | Versão nominal de relatórios |
| **Teleconsulta Nutricional** | 46 | Nutrição |
| **Teleorientação Psicológica** | 23 | Saúde Emocional |
| **Prefeituras (Diário)** | 17 | B2G |
| **Unificado Marsh** | 8 | EAP |
| **F&FCred** | 8 | EAP |
| **Grupo Rodocargas** | 8 | EAP |
| **Jaslog** | 8 | EAP |
| **Unafisco Saúde** | 8 | EAP |
| **Plano de Saúde São José** | 7 | EAP |

**Insight**: EAP tem maior fragmentação por cliente

---

## 7. DATAFLOWS - 16 FLUXOS GEN1

### DataFlows Identificados

| DataFlow | Tipo | Workspace |
|----------|------|-----------|
| _Data Flow (Clientes Diário) | Gen1 | _DataFlows e Conjuntos |
| _Data Flow (Interno Diário) | Gen1 | _DataFlows e Conjuntos |
| Data Flow (DW BI Diária) | Gen1 | _Data Flows (DW's) |
| Data Flow (DW BI Diária Aconselhamento) | Gen1 | _Data Flows (DW's) |
| Data Flow (DW BI Diária Monitoramento) | Gen1 | _Data Flows (DW's) |
| Data Flow (Empresa URL) | Gen1 | _Data Flows (DW's) |
| Data Flow (MonTarefaResposta Em Colunas) | Gen1 | _Data Flows (DW's) |
| Data Flow (Tabelas Sinteticas) | Gen1 | _Data Flows (DW's) |
| Data Flow (Telefonia) | Gen1 | _Data Flows (DW's) |

**Total**: 9 fluxos identificados (todos Gen1 - legado!)

---

## 8. MATRIZ DE COMPLEXIDADE

### Por Área de Negócio

| Área | Artefatos | Complexidade | Prioridade |
|------|-----------|--------------|------------|
| **Saúde24h** | 606 | MUITO ALTA | CRÍTICA |
| **Beneficiários** | 202 | ALTA | ALTA |
| **Taxa Utilização** | 192 | ALTA | CRÍTICA |
| **Saúde Emocional** | 121 | MÉDIA | MÉDIA |
| **Entrelaços** | 119 | MÉDIA | MÉDIA |
| **EAP** | 67 | MÉDIA | ALTA |
| **Crônicos** | 66 | MÉDIA | MÉDIA |
| **Nutrição** | 62 | MÉDIA | BAIXA |
| **Gerencial** | 25 | BAIXA | MÉDIA |

---

## 9. INSIGHTS ESTRATÉGICOS

### 9.1 Explosão de Artefatos

**Cenário Atual**:
- 1.543 relatórios para ~73 modelos semânticos
- **Razão**: 21 relatórios por modelo
- **Problema**: Impossível manter

**Causa Raiz**:
1. **1 relatório por cliente** (padrão predominante)
2. **Variações por produto** (Plus, Premium, Standard, Smart)
3. **Versões "Nominais"** (adicional para cada cliente)
4. **Workspaces desorganizados** (365 sem classificação)

### 9.2 Oportunidades de Consolidação

| Produto | Relatórios Atuais | Proposta | Economia |
|---------|-------------------|----------|---------|
| **Taxa de Utilização** | 192 | 1 dinâmico | **99% ↓** |
| **Lista Beneficiários** | 201 | 1 dinâmico | **99% ↓** |
| **Entrelaços** | 118 | 1 + 1 nominal | **98% ↓** |
| **Saúde24h Standard** | 130 | 1 por segmento | **90% ↓** |
| **Saúde Emocional** | 119 | 1 por segmento | **90% ↓** |

**Potencial de redução**: De 1.543 → **~150 relatórios** (90% redução)

### 9.3 Governança de Workspaces

**Situação Atual**:
- 20+ workspaces diferentes
- 365 artefatos sem workspace
- Mistura de produtos, clientes e usos

**Proposta**:
```
┌─────────────────────────────────────────────────────────────────┐
│                   ESTRUTURA PROPOSTA                           │
├─────────────────────────────────────────────────────────────────┤
│ 01_PRODUCAO                                                    │
│   - Modelos semânticos unificados                              │
│   - DataFlows Gen2                                            │
│   - Relatórios mestres                                        │
├─────────────────────────────────────────────────────────────────┤
│ 02_HOMOLOGACAO                                                │
│   - Versões de teste                                          │
│   - PoCs e demonstrações                                      │
├─────────────────────────────────────────────────────────────────┤
│ 03_ADMIN                                                      │
│   - Monitoring e governança                                    │
│   - Capacity metrics                                          │
├─────────────────────────────────────────────────────────────────┤
│ 04_CLIENTES (opcional - RLS)                                  │
│   - Se necessário segregação física                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 10. PLANO DE AÇÃO PRIORITÁRIO

### Fase 1 - Mapeamento (1 semana)

- [ ] Mapear workspaces e reorganizar
- [ ] Documentar os 73 modelos semânticos
- [ ] Identificar relatórios duplicados/obsoletos
- [ ] Catalogar os 365 artefatos "N/A"

### Fase 2 - Consolidação Crítica (2-4 semanas)

- [ ] **Taxa de Utilização**: Consolidar 192 → 1 relatório dinâmico
- [ ] **Lista Beneficiários**: Consolidar 201 → 1 relatório dinâmico
- [ ] **Entrelaços**: Consolidar 118 → 2 relatórios (padrão + nominal)
- [ ] Implementar RLS para segregação por cliente

### Fase 3 - Migração Gen1 → Gen2 (2 semanas)

- [ ] Migrar 9 DataFlows Gen1 para Gen2
- [ ] Validar query folding
- [ ] Testar performance

### Fase 4 - Saúde24h (4 semanas)

- [ ] Consolidar 597 relatórios Saúde24h
- [ ] Padronizar por segmento (Plus, Premium, Standard, Smart)
- [ ] Unificar modelos semânticos

---

## 11. KPIs DE SUCESSO

| KPI | Atual | Meta | Melhoria |
|-----|-------|------|----------|
| Relatórios | 1.543 | ~150 | 90% ↓ |
| Workspaces | 20+ | 4 | 80% ↓ |
| Artefatos "N/A" | 365 | 0 | 100% ↓ |
| DataFlows Gen1 | 9 | 0 | 100% ↓ |
| Tempo setup cliente | 4-8h | 30min | 94% ↓ |

---

## 12. CONCLUSÃO

**O inventário da Topmed é 50x maior do que a estimativa inicial:**

- Estimava-se ~50 artefatos → **Real: 1.632**
- A fragmentação é extrema e sistêmica
- **20+ relatórios para cada modelo semântico**
- 192 relatórios de "Taxa de Utilização" (1 por cliente!)

**A arquitetura atual é incompatível com escala.**

A modernização é **urgente e crítica** para:
1. Viabilizar novos clientes sem multiplicar artefatos
2. Manter e atualizar dashboards em tempo hábil
3. Governança e controle sobre o patrimônio de dados

---

**Documento versão 3.0**
**Data: 04/03/2026**
**Status: Inventário Completo**
