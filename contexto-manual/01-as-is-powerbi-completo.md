# Topmed - AS-IS Power BI - Mapeamento Completo

**Data**: 03/03/2026
**Gestor**: Rafael Faria (Gerente de Tecnologia)
**Usuário Admin**: powerbi_02@topmed.com.br
**Fase**: Discovery AS-IS
**Status**: Documento em construção

---

## 1. Arquitetura Detectada

```
┌─────────────────────────────────────────────────────────────────┐
│                      SQL Server (Fonte Principal)                  │
│              DW_BI_PROD_Diaria (10.10.0.2 / 10.150.209.55)      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Gateways (4 gateways)                      │
│  gatewaytopmed | GW-TOPMED-BI2 | GW-TOPMEDBI | PowerBI Flow    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DataFlows Gen1 (8 fluxos)                  │
│  Clientes Diário | Interno Diário | DW's | Telefonía | etc    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Modelos Semânticos (26+)                     │
│         Produtos Topmed + Clientes B2B/B2G + Específicos        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Relatórios Power BI (28+)                   │
│                Capacidade A2 - Brazil South                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Gateways e Conexões

### 2.1 Gateways Configurados (4)

| Gateway | IP | Status | Fonte |
|---------|-----|--------|-------|
| **gatewaytopmed** | 10.10.0.2 | Ativo | DW_BI_PROD_Diaria |
| **gatewaytopmed** | 10.150.209.55 | Ativo | DW_BI_PROD_Diaria |
| **GW-TOPMED-BI2** | 10.150.209.60 | Ativo | DW_BI_PROD_Diaria |
| **GW-TOPMEDBI** | 10.150.209.60 | Ativo | DW_BI_PROD_Diaria |
| PowerBI fluxos de dados (Herdado) | - | Ativo | Dataflows |

### 2.2 Fontes de Dados

| Fonte | Tipo | Uso |
|-------|------|-----|
| **DW_BI_PROD_Diaria** | SQL Server | DATA WAREHOUSE principal |
| SharePoint Online | OneLake | Arquivos, dados externos |
| PowerPlatformDataflows | Power Platform | Fluxos de dados |

**Observação**: SQL Server acessado via múltiplos IPs (10.10.0.2, 10.150.209.55, 10.150.209.60) - possível cluster ou load balancer.

---

## 3. DataFlows (8 fluxos Gen1 identificados)

| DataFlow | Tipo | Finalidade |
|----------|------|------------|
| **_Data Flow (Clientes Diário)** | Gen1 | Dados diários clientes |
| **_Data Flow (Interno Diário)** | Gen1 | Dados internos diários |
| **Data Flow (DW BI Diária Aconselhamento)** | Gen1 | DW Aconselhamento |
| **Data Flow (DW BI Diária Monitoramento)** | Gen1 | DW Monitoramento |
| **Data Flow (DW BI Diária)** | Gen1 | DW principal |
| **Data Flow (Empresa URL)** | Gen1 | Dados de URL |
| **Data Flow (MonTarefaResposta Em Colunas)** | Gen1 | Tarefas específicas |
| **Data Flow (Tabelas Sinteticas)** | Gen1 | Tabelas sintéticas |
| **Data Flow (Telefonia)** | Gen1 | Dados telefonia |

⚠️ **Alerta**: Todos os DataFlows são Gen1 (legado). Microsoft está migrando para Gen2.

---

## 4. Modelos Semânticos (26+ modelos)

### 4.1 Produtos Topmed

| Modelo | Atualização | Workspace |
|--------|-------------|-----------|
| **Gerencial Operacional** | 03/03 12:25 | Dashboards Gerenciais PRO |
| **Taxa Utilizacao - Conjunto de Dados** | 03/03 07:09 | DataFlows |
| **Entrelaços - Conjunto de Dados** | 02/03 22:36 | DataFlows |
| **Lista Beneficiários - Conjunto de Dados** | 03/03 00:08 | DataFlows |
| **Saúde24h Standard - Conjunto de Dados** | 02/03 21:09 | DataFlows |
| **Crônicos - Conjunto de Dados** | 02/03 21:38 | DataFlows |
| **Saúde24h Premium E+ - Conjunto de Dados** | 03/03 02:10 | DataFlows |
| **Saúde24h Medical E+ - Conjunto de Dados** | 03/03 01:08 | DataFlows |
| **Consultório Virtual - Conjunto de Dados** | 03/03 07:05 | DataFlows |
| **Atendimentos D-1 - Conjunto de Dados** | 03/03 09:37 | DataFlows |
| **Saúde Emocional - Terapia Online** | 03/03 00:38 | DataFlows |
| **Nutricall - Conjunto de Dados** | 02/03 18:06 | DataFlows |
| **Saúde 60+ - Conjunto de Dados** | 02/03 19:11 | DataFlows |
| **Mapeamento de Saúde Mental** | 02/03 21:13 | DataFlows |
| **Mapeamento de Saúde Psicossocial** | 02/03 23:31 | DataFlows |
| **Assistente Virtual - Mediktor** | 03/03 07:23 | Dashboards Gerenciais PRO |

### 4.2 Clientes B2B/B2G

| Modelo | Cliente | Tipo |
|--------|---------|------|
| **Alô Saúde Floripa - PMF** | Prefeitura Floripa | B2G (Público) |
| **Mapeamento de Saúde Mental - PF** | Polícia Federal | B2G (Governo) |
| **Gestão de Atendimentos - PF** | Polícia Federal | B2G (Governo) |
| **IPSM** | ? | B2B |
| **Grupo CASE - Gestão de Monitoramento** | Grupo CASE | B2B |
| **Conecta SUS Ribeirão** | SUS Ribeirão | B2G (Público) |
| **Ailos - BI de Vendas** | Ailos | B2B |

### 4.3 Admin/Meta

| Modelo | Finalidade |
|--------|------------|
| **Lista de Relatórios e Permissões** | Documentação |
| **Status Atualização Base Relatórios BI** | Monitoramento |

---

## 5. Relatórios (28+ relatórios)

### 5.1 Gerenciais Internos

| Relatório | Workspace |
|-----------|------------|
| Gerencial Operacional | Dashboards Gerenciais PRO |
| Status Atualização Base Relatórios BI | Dashboards Gerenciais PRO |
| Gerencial Área Técnica | Dashboards Gerenciais PRO |
| Gerencial Único | Dashboards Gerenciais PRO |
| Gerencial Faturamento_Versão Antiga | Dashboards Gerenciais PRO |
| Gerencial Teleconsulta - Interno | Dashboards Gerenciais PRO |
| Assistant Virtual - Mediktor | Dashboards Gerenciais PRO |

### 5.2 Por Cliente (Taxa de Utilização)

⚠️ **Padrão identificado**: Múltiplos relatórios de "Taxa de Utilização" para diferentes municípios/clientes.

| Cliente | Relatórios |
|---------|------------|
| **Guaratuba** | Taxa Utilizacao - Prefeitura de Guaratuba |
| **Guaramirim** | Taxa Utilizacao - Prefeitura de Guaramirim |
| **Araquari** | Taxa Utilizacao - Prefeitura de Araquari; Saúde24h Plus - Araquari |
| **ACAERT** | Taxa Utilizacao - ACAERT |
| **APAE Palhoca** | Taxa Utilizacao - APAE Palhoca |
| **Allpfit** | Taxa Utilizacao - Allpfit; Saúde24h Standard - Allpfit |
| **A10 Beneficios** | Taxa Utilizacao - A10; Saúde24h Standard - A10; Emocional - A10; Nutricall - A10 |

### 5.3 Outros Clientes

| Cliente | Relatórios |
|---------|------------|
| **Localiza** | EAP com Teleconsulta - Localiza |
| **Zurich** | Entrelaços - Zurich; Entrelaços - Zurich Nominais |
| **CISNORDESTE** | CISNORDESTE - Atendimentos Concluídos - Mensal |
| **Corpo e Mente em Forma** | Corpo e Mente em Forma |
| **Inovare Soluções em Saúde** | Mapeamento Saúde Mental - Inovare - Unificado |

---

## 6. Workspaces e Capacidades

| Workspace | Tipo | Capacidade | Administrador |
|-----------|------|------------|---------------|
| **BI TopMed** | Personalizado | topmedbi2 (A2) | powerbi_02 |
| **BI TopMed 2** | Personalizado | topmedbi2 (A2) | powerbi_02 |
| **Dashboards Gerenciais PRO** | ? | topmedbi2 (A2) | ? |
| **_DataFlows e Conjuntos (Relatórios)** | Sistema | topmedbi2 (A2) | ? |
| **_Data Flows (DW's)** | Sistema | topmedbi2 (A2) | ? |
| **Personalizado - Clientes** | Sistema | topmedbi2 (A2) | ? |
| **Taxa Utilização** | Sistema | topmedbi2 (A2) | ? |

---

## 7. Problemas Identificados 🔴

### 7.1 CRÍTICOS

| ID | Problema | Impacto | Observação |
|----|----------|---------|------------|
| **P001** | **Estouro memória** - Alô Saúde Floripa Antigo | Refresh falha | 2404MB usados / 2378MB limite |
| **P002** | **Capacidade A2** | Limitada p/ produção enterprise | SKU A2 é básico |
| **P003** | **DataFlows Gen1** | Legado,性能 inferior | Microsoft migrou p/ Gen2 |
| **P004** | **SQL Server "capenga"** | Infraestrutura limitada | Descrito por Rafael |

### 7.2 ALERTAS

| ID | Problema | Impacto | Observação |
|----|----------|---------|------------|
| **A001** | **Explosão de relatórios Taxa Utilização** | Manutenção impossível | 1 relatório por município! |
| **A002** | **Modelos duplicados/similares** | Confusão | Saúde24h tem 8+ variações |
| **A003** | **Gambiarras confirmadas** | Technical debt | "Não amarrar ao construído" |
| **A004** | **Silos de dados** | Integração necessária | Financeiro × Assistencial |
| **A005** | **Workspaces desorganizados** | Governança fraca | Muitos workspaces similares |
| **A006** | **Gateway múltiplos IPs** | Complexidade | Cluster sem documentação |

### 7.3 OPORTUNIDADES

| ID | Oportunidade | Benefício |
|----|--------------|-----------|
| **O001** | **Consolidar Taxa Utilização** | 1 relatório p/ todos clientes |
| **O002** | **Migrar DataFlows Gen1 → Gen2** | Performance + features |
| **O003** | **Unificar Saúde24h** | Manutenção simplificada |
| **O004** | **Documentar fontes de dados** | Rastreabilidade |
| **O005** | **Revisar capacidade A2** | Escalar p/ Premium/Premium Per User |

---

## 8. Insights

### 8.1 Explosão de Relatórios

O padrão "Taxa de Utilização - [Município]" indica:
- ❌ Cada novo cliente = novo relatório copiado
- ❌ Manutenção em massa impossível
- ❌ Não há reutilização de artefatos
- ✅ **Oportunidade**: Criar 1 relatório com filtro de cliente

### 8.2 DataFlows Gen1

- **8 DataFlows** todos em Gen1 (legado)
- Microsoft está descontinuando Gen1
- **Risco**: Perda de suporte, bugs não corrigidos
- **Ação**: Migrar para Gen2 (Lakehouse) com prioridade

### 8.3 Capacidade A2

- SKU A2 é entry-level Embedded
- **3GB RAM** (limitado)
- Não é ideal p/ produção enterprise
- **Sugestão**: Avaliar F SKU ou P SKU (Premium)

### 8.4 Gateway

- Múltiplos gateways apontando p/ mesma fonte
- Possível redundância sem documentação
- IPs diferentes (10.10.0.2, 10.150.209.55, 10.150.209.60)
- Precisa mapear topologia de rede

---

## 9. Próximos Passos

### Imediatos

- [ ] Entrevistar Rafael Faria - validar descobertas
- [ ] Mapear estrutura do DW_BI_PROD_Diaria (tabelas, volume)
- [ ] Documentar topologia de rede dos gateways
- [ ] Levantar Quick Wins (consolidações óbvias)

### Curto Prazo

- [ ] Consolidar relatórios Taxa de Utilização (1 p/ todos)
- [ ] Unificar modelos Saúde24h duplicados
- [ ] Migrar DataFlows Gen1 → Gen2
- [ ] Revisar capacidade (A2 → F/P)

### Médio Prazo

- [ ] Propor arquitetura target
- [ ] Implementar governança de dados
- [ ] Criar catálogo de dados
- [ ] Estabelecer SLA de refresh

---

## 10. Questionamentos p/ Rafael

1. **Gateways**: Por que múltiplos gateways com IPs diferentes? É um cluster?
2. **Capacidade**: A2 é suficiente ou precisamos escalar?
3. **DataFlows**: Podemos migrar Gen1 → Gen2 imediatamente?
4. **Taxa Utilização**: Por que 1 relatório por município? Podemos consolidar?
5. **Fontes**: DW_BI_PROD_Diaria é o único DW? Tem outros?
6. **SLA**: Quais são os requisitos de disponibilidade?
7. **Prioridade**: O que é mais urgente melhorar agora?

---

**Status**: AS-IS Power BI mapeado
**Próxima atualização**: Pós entrevista com Rafael
**Data**: 03/03/2026
