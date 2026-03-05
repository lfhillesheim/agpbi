# MAPEAMENTO COMPLETO: PROBLEMAS, RISCOS E DESCOBERTAS
## Power BI Topmed - Análise de Arquitetura, Governança e Escalabilidade

---

**Data**: 04/03/2026
**Responsável**: AGPBI Framework
**Status**: Análise Completa
**Destinatário**: Rafael Faria (CTO/Gerente de Tecnologia)

---

## 1. RESUMO EXECUTIVO

### Contexto Topmed
- **18 anos** de operação (fundada em agosto/2006)
- **20M+ vidas** acompanhadas
- **94%** resolutividade
- **NPS 95.4**
- **3 segmentos**: B2G (prefeituras), B2B (empresas), White Label (parcerias)

### O Problema Real

```
TOTAL IDENTIFICADO: 1.632 artefatos
```

**A arquitetura Power BI da Topmed apresenta fragmentação extrema.**

### Impacto Imediato
- 1.543 relatórios para 73 modelos semânticos = **21:1 ratio** (impossível de manter)
- 192 relatórios de "Taxa de Utilização" (1 por cliente/município)
- 201 relatórios de "Lista Beneficiários" (1 por empresa)
- 365 artefatos (22%) sem workspace definido
- 9 DataFlows Gen1 (legado sendo descontinuado)

### Call-to-Action
**A arquitetura atual é incompatível com escala.** Cada novo cliente multiplica artefatos linearmente. A modernização é urgente e crítica.

---

## 2. INVENTÁRIO COMPLETO

### 2.1 Números Oficiais

| Categoria | Quantidade | Observação |
|-----------|-----------|------------|
| **Modelos Semânticos** | **73** | Datasets em "BI TopMed 2" |
| **Relatórios** | **1.543** | Dashboards/Reports |
| **DataFlows** | **16** | Fluxos de dados (9 Gen1 identificados) |
| **TOTAL DE ARTEFATOS** | **1.632** | Inventário completo |

### 2.2 Distribuição por Workspace

| Workspace | Relatórios | Modelos | Total | % |
|-----------|------------|---------|-------|---|
| **N/A (Não classificado)** | 364 | 0 | 365 | 22% |
| **Lista Beneficiários Cliente** | 207 | 0 | 207 | 13% |
| **Taxa Utilização** | 192 | 0 | 192 | 12% |
| **Saúde24h Standard** | 130 | 0 | 130 | 8% |
| **Entrelaços** | 118 | 0 | 118 | 7% |
| **Saúde24h Premium E+** | 88 | 0 | 88 | 5% |
| **Saúde24h Plus** | 81 | 0 | 81 | 5% |
| **BI TopMed 2** | 0 | 66 | 76 | 5% |
| **Saúde Emocional** | 74 | 0 | 74 | 5% |
| **Personalizado - Clientes** | 24 | 0 | 24 | 1% |
| **Outros (10+ workspaces)** | ~185 | ~7 | ~192 | 12% |

**Insight Crítico**: 365 artefatos (22%) estão sem workspace definido. Isso representa governança inexistente.

### 2.3 Segmentação por Produto

| Produto | Modelos | Relatórios | Total | % do Total |
|---------|---------|------------|-------|------------|
| **Saúde24h (todos)** | 9 | 597 | 606 | 37% |
| **Lista Beneficiários** | 1 | 201 | 202 | 12% |
| **Taxa de Utilização** | 1 | 191 | 192 | 12% |
| **Saúde Emocional** | 2 | 119 | 121 | 7% |
| **Entrelaços** | 1 | 118 | 119 | 7% |
| **EAP/Teleconsulta** | 2 | 65 | 67 | 4% |
| **Crônicos** | 3 | 63 | 66 | 4% |
| **Nutrição (Nutricall)** | 2 | 60 | 62 | 4% |
| **Atendimentos** | 8 | 46 | 54 | 3% |
| **Gerencial** | - | 25 | 25 | 2% |
| **Outros** | - | 49 | 49 | 4% |

**Saúde24h sozinho representa 37% de todos os artefatos.**

---

## 3. PROBLEMAS CRÍTICOS IDENTIFICADOS

### 3.1 Fragmentação Extrema

#### Problema 1: Taxa de Utilização - 192 Relatórios

**Padrão**: 1 relatório por município/cliente

```
Taxa Utilizacao - Prefeitura de Guaratuba
Taxa Utilizacao - Prefeitura de Guaramirim
Taxa Utilizacao - Prefeitura de Araquari
Taxa Utilizacao - ACAERT
Taxa Utilizacao - APAE Palhoca
Taxa Utilizacao - Allpfit
Taxa Utilizacao - A10 Beneficios
... (192 no total)
```

**Impacto**: Alterar 1 visualização = **192 alterações manuais**

**Solução**: 1 relatório dinâmico com RLS por cliente
**Redução**: 99%

#### Problema 2: Lista Beneficiários - 201 Relatórios

**Padrão**: 1 relatório por empresa/cliente

```
Lista Beneficiários - BrFan
Lista Beneficiários - FABRICA CT
Lista Beneficiários - LOGOSUL
Lista Beneficiários - Planus
... (201 no total)
```

**Impacto**: Onboarding de novo cliente = copiar, adaptar, publicar (4-8h)

**Solução**: 1 relatório dinâmico com RLS
**Redução**: 99%

#### Problema 3: Entrelaços - 118 Relatórios

**Padrão**: 1 relatório padrão + 1 versão "Nominais" por cliente

```
Entrelaços - Zurich
Entrelaços - Zurich - Nominais
Entrelaços - Tivit - Nominais
Entrelaços - TopMed - Nominais
... (118 no total, 59 versões "Nominais")
```

**Impacto**: Duplicação de manutenção

**Solução**: 2 relatórios (padrão + nominal com RLS)
**Redução**: 98%

#### Problema 4: Saúde24h - 597 Relatórios

**Variações por produto**:
- Saúde24h Plus E+ (88 relatórios)
- Saúde24h Premium E+ (88 relatórios)
- Saúde24h Standard (130 relatórios)
- Saúde24h Smart E+ (22 relatórios)
- Saúde24h Smart (14 relatórios)
- Saúde24h Plus (81 relatórios)
- Outros (174 relatórios)

**Problema**: Cada cliente tem múltiplas versões por produto

**Solução**: Consolidar por segmento com RLS
**Redução**: 90%

### 3.2 Problemas Técnicos

#### Problema 5: DataFlows Gen1 (CRÍTICO)

**Todos os 9 DataFlows são Gen1 (LEGADO)**

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

**Risco**: Microsoft está descontinuando Gen1

**Impacto**: Migração forçada em data desconhecida

**Solução**: Migrar para Gen2 (urgentemente)

#### Problema 6: SQL Hardcoded no Power Query

**Exemplo identificado (M005)**:
```sql
WHERE IdEmpresa = 151 OR IdEmpresa = 726
```

**Problema**:
- Multi-tenancy via cópia de código
- Não escalável
- Manutenção impossível

**Solução**: Implementar RLS (Row-Level Security)

#### Problema 7: Ausência Total de Documentação

**Análise de 3 PBIPs amostrados**:
- DAX: 6/10 (boas práticas, zero documentação)
- Power Query: 5/10 (hardcoded values)
- Modelagem: Sem descrições em tabelas/colunas
- Medidas: Sem descrição de negócio

**Impacto**:
- Conhecimento tribal
- Dependência de pessoas específicas
- Onboarding de semanas para novos analistas

#### Problema 8: Zero RLS Implementado

**Situação Atual**:
- Segregação de dados via cópia de relatórios
- 1 relatório por cliente
- Segurança física (workspaces por cliente)

**Problema**:
- Explosão de artefatos
- Impossível escalar
- Sem auditoria de acesso

### 3.3 Problemas de Governança

#### Problema 9: Workspaces Fragmentados

**Situação**: 20+ workspaces diferentes

```
BI TopMed 2
BI TopMed
Dashboards Gerenciais PRO
_Homologação PRO
_Homologação
Admin monitoring
Personalizado - Clientes
_DataFlows e Conjuntos (Relatórios)
_Data Flows (DW's)
Saúde24h Plus
Saúde24h Standard
Taxa Utilização
Entrelaços
Saúde24h Premium E+
Saúde24h Smart E+
Saúde24h Smart
Teleconsulta (EAP)
Hiperconsultadores
Crônicos
Mapeamento de Saúde Mental
Nutricall - Teleorientação Nutricional
Saúde Emocional - Terapia Online
Lista Beneficiários Cliente
... (mais)
```

**Problemas**:
- Mistura de produtos, clientes e usos
- Sem padrão de nomenclatura
- Workspaces "N/A" com 365 artefatos
- Dificulta governança e segurança

#### Problema 10: Infraestrutura de Gateways

**Gateways identificados**:
- gatewaytopmed (principal)
- GW-TOPMED-BI2
- GW-TOPMEDBI
- (Modo pessoal) - gateways pessoais

**Problemas**:
- Múltiplos gateways redundantes
- Gateways em modo pessoal (sem controle)
- Conexões duplicadas ao mesmo SQL Server

#### Problema 11: Capacidade A2

**Especificações**: 3GB RAM para o ambiente inteiro

**Problema**:
- 1.632 artefatos competindo por 3GB
- Refresh simultâneos podem falhar
- Sem monitoramento de capacity metrics

---

## 4. IMPACTOS NA PRODUTIVIDADE

### 4.1 Tempo de Setup Novo Cliente

| Atividade | Tempo Atual | Tempo Proposto | Melhoria |
|-----------|-------------|----------------|----------|
| Copiar relatório template | 30 min | - | - |
| Adaptar filtros hardcoded | 1-2h | - | - |
| Testar validação | 1h | - | - | - |
| Publicar em workspace | 30 min | - | - |
| Configurar permissões | 1-2h | 5 min | 96% |
| **TOTAL** | **4-8h** | **30 min** | **94% ↓** |

### 4.2 Custo de Manutenção

**Cenário**: Alterar 1 visualização em todos os relatórios

| Produto | Relatórios | Tempo Estimado |
|---------|------------|----------------|
| Taxa de Utilização | 192 | 16-32h |
| Lista Beneficiários | 201 | 17-34h |
| Entrelaços | 118 | 10-20h |
| Saúde24h | 597 | 50-100h |
| **TOTAL** | **1.543** | **130-260h** |

**Com arquitetura consolidada**: 30 minutos

**Diferença**: 260x mais rápido

### 4.3 Onboarding de Novos Analistas

**Cenário Atual**:
- Sem documentação
- Conhecimento tribal
- Aprender "onde está cada coisa"
- **Tempo**: 4-6 semanas para produtividade

**Cenário Proposto**:
- Documentação completa
- Star Schema padronizado
- Métricas em tabela _Measures
- **Tempo**: 1-2 semanas para produtividade

### 4.4 Perda de Conhecimento (Turnover)

**Risco**: Se pessoa chave sair, conhecimento perdido

**Situação Atual**:
- Zero documentação
- Lógica de negócio no Power Query hardcoded
- Padrões não documentados

**Impacto**: Sem essa pessoa, alterações podem quebrar produção

---

## 5. RISCOS ESTRATÉGICOS

### 5.1 Risco 1: DataFlows Gen1 Descontinuação

**Severidade**: CRÍTICA
**Probabilidade**: ALTA
**Timeline**: Indefinida (Microsoft não informou data)

**Impacto se não agir**:
- Migração forçada em data desconhecida
- Possível quebra de refreshes
- Interrupção de operações

**Recomendação**: Migrar para Gen2 em 2 semanas

### 5.2 Risco 2: Non-Scalability

**Severidade**: ALTA
**Probabilidade**: CERTA (já acontecendo)

**Problema**: Crescimento linear de artefatos

```
Novo Cliente = 3-5 novos relatórios
100 clientes novos = 300-500 novos relatórios
1000 clientes novos = 3.000-5.000 novos relatórios
```

**Impacto**:
- Manutenção impossível
- Time-to-market aumenta
- Qualidade diminui

**Recomendação**: Implementar RLS urgentemente

### 5.3 Risco 3: Time-to-Market Explosivo

**Severidade**: ALTA
**Probabilidade**: CERTA

**Cenário**: Lançar novo produto/serviço

| Etapa | Tempo Atual |
|-------|-------------|
| Desenvolver base | 2-4 semanas |
| Criar 100+ relatórios | 4-8 semanas |
| **TOTAL** | **6-12 semanas** |

**Com arquitetura escalável**: 2-3 semanas

### 5.4 Risco 4: Perda de IP (Turnover)

**Severidade**: MÉDIA
**Probabilidade**: MÉDIA

**Problema**: Conhecimento crítico não documentado

**O que pode ser perdido**:
- Lógica de negócio hardcoded
- Padrões de modelagem
- Workarounds não documentados
- Relacionamentos entre entidades

**Impacto**: Sem documentação, turnover = reinvenção

### 5.5 Risco 5: Single Point of Failure

**Severidade**: MÉDIA
**Probabilidade**: BAIXA

**Problema**: Dependência de pessoas específicas

**Cenário**: Pessoa responsável por área crítica indisponível

**Impacto**: Alterações críticas ficam paralisadas

---

## 6. OPORTUNIDADES DE MELHORIA

### 6.1 Consolidação de Artefatos

| Produto | Relatórios Atuais | Proposta | Economia |
|---------|-------------------|----------|----------|
| Taxa de Utilização | 192 | 1 dinâmico | 99% ↓ |
| Lista Beneficiários | 201 | 1 dinâmico | 99% ↓ |
| Entrelaços | 118 | 1 + 1 nominal | 98% ↓ |
| Saúde24h Standard | 130 | 1 por segmento | 90% ↓ |
| Saúde Emocional | 119 | 1 por segmento | 90% ↓ |
| **TOTAL GERAL** | **1.543** | **~150** | **90% ↓** |

**De 1.543 relatórios → ~150 relatórios**

### 6.2 Reorganização de Workspaces

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

**De 20+ workspaces → 4 workspaces**

### 6.3 Melhorias de Qualidade Técnica

| Área | Situação Atual | Meta |
|------|----------------|------|
| Documentação de modelos | 0% | 100% |
| Medidas com descrição | ~10% | 100% |
| Star Schema compliance | Parcial | 100% |
| Query folding verificado | Não | 100% |
| RLS implementado | Não | Sim |
| Auto Date/Time | ? | Desabilitado |

---

## 7. PLANO DE AÇÃO RECOMENDADO

### Fase 1: Mapeamento e Governança (1 semana)

**Objetivo**: Entender e organizar

- [x] Mapear todos os workspaces e artefatos
- [ ] Documentar os 73 modelos semânticos
- [ ] Identificar relatórios duplicados/obsoletos
- [ ] Catalogar os 365 artefatos "N/A"
- [ ] Criar padrão de nomenclatura

**Entregáveis**:
- Inventário completo ✓ (já feito)
- Documentação de todos os modelos
- Padrão de nomenclatura aprovado

### Fase 2: Consolidação Crítica (2-4 semanas)

**Objetivo**: Eliminar fragmentação nos maiores problemas

**Prioridade CRÍTICA**:
- [ ] Taxa de Utilização: 192 → 1 relatório dinâmico
- [ ] Lista Beneficiários: 201 → 1 relatório dinâmico
- [ ] Implementar RLS para segregação por cliente
- [ ] Remover SQL hardcoded do Power Query

**Prioridade ALTA**:
- [ ] Entrelaços: 118 → 2 relatórios (padrão + nominal)
- [ ] Saúde Emocional: consolidar por segmento

**Entregáveis**:
- 300+ relatórios removidos
- RLS implementado e testado
- Documentação de como adicionar cliente

### Fase 3: Migração Gen1 → Gen2 (2 semanas)

**Objetivo**: Eliminar risco de descontinuação

- [ ] Migrar 9 DataFlows Gen1 para Gen2
- [ ] Validar query folding em cada migração
- [ ] Testar performance pós-migração
- [ ] Atualizar documentação

**Entregáveis**:
- 0 DataFlows Gen1
- Documentação de migração
- Testes de validação

### Fase 4: Saúde24h (4 semanas)

**Objetivo**: Consolidar maior produto

- [ ] Consolidar 597 relatórios Saúde24h
- [ ] Padronizar por segmento (Plus, Premium, Standard, Smart)
- [ ] Unificar modelos semânticos
- [ ] Implementar RLS por segmento

**Entregáveis**:
- 500+ relatórios consolidados
- Star Schema validado
- Documentação completa

---

## 8. KPIS DE SUCESSO

### 8.1 Métricas de Transformação

| KPI | Atual | Meta | Melhoria | Timeline |
|-----|-------|------|----------|----------|
| **Relatórios** | 1.543 | ~150 | 90% ↓ | 8-10 semanas |
| **Workspaces** | 20+ | 4 | 80% ↓ | 1 semana |
| **Artefatos "N/A"** | 365 | 0 | 100% ↓ | 1 semana |
| **DataFlows Gen1** | 9 | 0 | 100% ↓ | 2 semanas |
| **Setup novo cliente** | 4-8h | 30min | 94% ↓ | Fase 2 |
| **Alteração em 1 visual** | 130-260h | 30min | 99% ↓ | Fase 2 |
| **Documentação** | ~10% | 100% | 900% ↑ | Contínuo |

### 8.2 ROI Esperado

**Investimento**: ~10-12 semanas de trabalho dedicado

**Retornos**:
- Setup de cliente: 94% mais rápido
- Manutenção: 99% mais rápida
- Onboarding: 50% mais rápido
- Time-to-market: 60% mais rápido
- Risco eliminado: Gen1 descontinuação

**Payback Estimado**: 3-6 meses

---

## 9. CONCLUSÃO

### A Realidade

O inventário Power BI da Topmed revela uma arquitetura complexa e fragmentada:

- **1.632 artefatos** identificados
- A fragmentação é **extrema e sistêmica**
- **20+ relatórios para cada modelo semântico**
- 192 relatórios de "Taxa de Utilização" (1 por cliente!)
- 9 DataFlows Gen1 (legado)

### O Problema

**A arquitetura atual é incompatível com escala.**

Cada novo cliente multiplica artefatos linearmente. A manutenção é impossível. O time-to-market aumenta continuamente.

### A Solução

**Modernização urgente através de:**

1. **Consolidação**: 1.543 → ~150 relatórios (90% redução)
2. **RLS**: Segregação por cliente sem duplicar artefatos
3. **Gen2**: Migrar DataFlows antes que seja forçado
4. **Documentação**: Transformar conhecimento tribal em ativo corporativo
5. **Governança**: 4 workspaces organizados

### O Impacto

Com essa transformação:

- Setup de novo cliente: **30 minutos** (vs 4-8h hoje)
- Manutenção: **99% mais rápida**
- Time-to-market: **60% mais rápido**
- Risco de Gen1: **Eliminado**

### Next Steps

1. Aprovar plano de ação
2. Priorizar Fase 2 (Consolidação Crítica)
3. Iniciar migração Gen1 → Gen2
4. Implementar RLS piloto em 1 produto

---

**Documento versão 1.0**
**Data: 04/03/2026**
**Status: Análise Completa - Aguardando Aprovação**

---

## Apêndice: Arquivos de Referência

- `INVENTARIO-COMPLETO-TOPMED.md` - Inventário detalhado
- `analise-completa-qualidade.md` - Análise técnica PBIP
- `analise-qualidade-modelos.md` - Qualidade de modelos
- `Lista - Modelo semantico.txt` - 73 modelos
- `Lista - Relatórios.txt` - 1.543 relatórios
- `Lista - Fluxos.txt` - 16 DataFlows
- `conexões gateway.txt` - Infraestrutura de gateways
