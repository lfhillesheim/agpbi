# Topmed Assistência à Saúde Ltda
## Análise Completa do Ambiente Power BI

**Data**: Março de 2026
**Responsável**: AGPBI Framework
**Status**: Análise Completa

---

## Resumo Executivo

A Topmed é uma das 5 maiores operadoras de telessaúde do Brasil, com **18 anos de operação**, líder absoluta na Região Sul, impactando **+20 milhões de vidas** com resolutividade clínica de **94%** e NPS de **95.4**.

### Inventário Descoberto

| Categoria | Quantidade | Observação |
|-----------|------------|------------|
| Modelos Semânticos | 73 | Datasets em BI TopMed 2 |
| Relatórios | 1.543 | Dashboards e Reports |
| DataFlows | 16 | 9 fluxos Gen1 (LEGADO) |
| **TOTAL** | **1.632** | Inventário completo |

**Comparação com estimativa anterior**: Estimávamos ~50 artefatos → **Real: 1.632** (3.164% a mais!)

---

## Estrutura da Documentação

```
docs/casos/topmed/
├── 01-inventario/           # Inventário completo e relatórios
├── 02-analise-estrategica/  # Avaliação estratégica e riscos
├── 03-arquitetura/          # Infraestrutura, gateways, qualidade
├── 04-propostas/            # Documentos comerciais do cliente
└── 05-scripts/              # Scripts Python de análise
```

---

## Principais Descobertas

### 1. Fragmentação Extrema 🔴
- **192 relatórios** de Taxa de Utilização (1 por cliente)
- **201 relatórios** de Lista Beneficiários (1 por empresa)
- **597 relatórios** Saúde24h (fragmentados por produto/segmento)
- **Impacto**: Alterar 1 visual em todos = 130-260 horas de trabalho

### 2. DataFlows Gen1 (CRÍTICO) 🔴
Todos os 9 DataFlows são Gen1 (LEGADO) - Microsoft está descontinuando:
- _Data Flow (Clientes Diário)
- _Data Flow (Interno Diário)
- Data Flow (DW BI Diária)
- Data Flow (DW BI Diária Aconselhamento)
- Data Flow (DW BI Diária Monitoramento)
- Data Flow (Empresa URL)
- Data Flow (MonTarefaResposta Em Colunas)
- Data Flow (Tabelas Sintéticas)
- Data Flow (Telefonia)

### 3. SQL Hardcoded
Exemplo identificado: `WHERE IdEmpresa = 151 OR IdEmpresa = 726`
- Multi-tenancy via cópia de código
- Não escalável
- Manutenção impossível

### 4. Ausência de Documentação
- Medidas DAX sem descrição de negócio
- Tabelas e colunas sem documentação
- Zero padrões de nomenclatura

---

## Agrupamentos Identificados

| Pai | Filhos | Painéis |
|-----|--------|---------|
| Prudential | 7 variantes | 12 |
| Telamed | 6 variantes | - |
| Vallora | 3 variantes | 10 |
| Marista | 4 variantes | 7 |
| Mediclick | 3 variantes | 13 |
| Bom Abraço | 3 variantes | 10 |

---

## Recomendações

### Imediato (0-3 meses)
1. **Migrar DataFlows Gen1 → Gen2** (9 fluxos)
2. **Consolidar relatórios por produto** (Taxa Utilização: 192 → 1)
3. **Implementar RLS por cliente** (substituir SQL hardcoded)

### Curto Prazo (3-6 meses)
1. **Reestruturar workspaces** (20+ → 4)
2. **Documentar modelos semânticos** (73 modelos)
3. **Padronizar nomenclatura**

### Longo Prazo (6-12 meses)
1. **Arquitetura corporativa** (Star Schema centralizado)
2. **CI/CD para deploy** (automação)
3. **Monitoramento e governança**

---

## Métricas de Sucesso Esperadas

| KPI | Antes | Depois | Melhoria |
|-----|-------|--------|----------|
| Relatórios | 1.543 | ~150 | 90% |
| Workspaces | 20+ | 4 | 80% |
| Setup cliente | 4-8h | 30min | 94% |
| Alteração visual | 130-260h | 30min | 99% |
| DataFlows Gen1 | 9 | 0 | 100% |

---

## Arquivos Principais

- **[Inventário Completo](01-inventario/README.md)** - Lista detalhada de todos os artefatos
- **[Análise Estratégica](02-analise-estrategica/ANALISE-ESTRATEGICA-TOPMED.md)** - Avaliação completa
- **[Diagnóstico](02-analise-estrategica/DIAGNOSTICO-TOPMED-RAFAEL.md)** - Visão do CTO
- **[Qualidade de Modelos](03-arquitetura/analise-qualidade-modelos.md)** - Análise técnica

---

**Relatório versão 1.0 | Data: 04/03/2026 | Framework AGPBI v3.2**
