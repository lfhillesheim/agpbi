# Topmed - AS-IS Power BI - Mapeamento Completo

**Data**: 03/03/2026
**Gestor**: Rafael Faria
**Usuário Admin**: powerbi_02@topmed.com.br
**Status**: Discovery em andamento

---

## 1. Infraestrutura Power BI

### 1.1 Licenças (19 usuários Pro)

| Usuário | Email | Licença |
|---------|-------|---------|
| Área Tecnica TopMed | area.tecnica@topmed.com.br | M365 Business Basic + PBI Pro |
| BI Topmed | bi.topmed@topmedcombr.onmicrosoft.com | PBI Pro |
| BI TopMed | powerbi@topmedcombr.onmicrosoft.com | PBI Pro |
| **BI TopMed 2** | **powerbi_02@topmed.com.br** | **Fabric Free + M365 Basic + PBI Pro + Automate** |
| Cliente TopMed | cliente@topmed.com.br | PBI Pro + M365 Basic |
| Comercial TopMed | comercial@topmed.com.br | Automate Free + PBI Pro + M365 Basic |
| Debora Floriano | debora.floriano@topmed.com.br | PBI Pro + M365 Basic |
| Diego Felipe Bettanin | diego.bettanin@topmed.com.br | Automate Free + PBI Pro + M365 Basic |
| Financeiro | financeiro@topmed.com.br | Automate Free + PBI Pro + M365 Basic |
| Implantação | implantacao@topmed.com.br | Teams Premium + PBI Pro + M365 Basic |
| Luiz Fernando | luiz.fernando@topmed.com.br | PBI Pro + M365 Basic |
| Maria Eduarda | maria.eduarda@topmed.com.br | Automate Free + PBI Pro + M365 Basic |
| Marketing TopMed | marketing@topmed.com.br | OneDrive + Exchange + PBI Pro |
| **Paulo Salvi** | **paulo.salvi@topmed.com.br** | **PBI Pro + M365 Basic** |
| Produtos | produtos@topmed.com.br | Automate Free + PBI Pro + Exchange |
| **Rafael Roberto Faria** | **rafael.faria@topmed.com.br** | **PBI Pro + M365 Basic** |
| Roberta Cunha | roberta.cunha@topmed.com.br | PBI Pro + M365 Basic |
| Roberta Soares | roberta.soares@topmed.com.br | PBI Pro + M365 Basic |
| Time Operacional TopMed | operacional@topmed.com.br | PBI Pro |
| **Valda Stange** | **valda.stange@topmed.com.br** | **PBI Pro + M365 Basic** |

**TOTAL**: 18 licenças Pro + 1 Fabric (Free)

### 1.2 Capacidade

| Atributo | Valor |
|----------|-------|
| **Nome** | topmedbi2 |
| **SKU** | A2 (Embedded) |
| **Região** | Brazil South |
| **Status** | Ativo |
| **Administradores** | BI TopMed 2, Oriente T, Roberto TI |

⚠️ **Alerta**: Capacidade A2 é limitada para produção enterprise

### 1.3 Workspaces

| Workspace | Tipo | Role |
|-----------|------|------|
| **BI TopMed** | Personalizado | Admin |
| **BI TopMed 2** | Personalizado | Admin (capacity A2) |
| **TopMed (geral)** | Group | Admin |
| **Sistema Lupa SSO** | User | Visualizador |

---

## 2. Modelos Semânticos (53 identificados)

### 2.1 Produtos Topmed (Core)

| Modelo | Workspace | Atualização | Status |
|--------|-----------|-------------|--------|
| Saúde24h Basic - Conjunto de Dados | DataFlows | 23:00 diário | ✅ OK |
| Saúde24h Plus - Conjunto de Dados | DataFlows | 20:30 diário | ✅ OK |
| Saúde24h Plus E+ - Conjunto de Dados | DataFlows | 00:00 diário | ✅ OK |
| Saúde24h Premium - Conjunto de Dados | DataFlows | 23:30 diário | ✅ OK |
| Saúde24h Premium E+ - Conjunto de Dados | DataFlows | 02:00 diário | ✅ OK |
| Saúde24h Smart - Conjunto de Dados | DataFlows | 20:30 diário | ✅ OK |
| Saúde24h Smart E+ - Conjunto de Dados | DataFlows | 20:00 diário | ✅ OK |
| Saúde24h Medical E+ - Conjunto de Dados | DataFlows | 01:00 diário | ✅ OK |
| **Saúde24h PAV PAE Consulta Imediata** | DataFlows | 16:30 diário | ✅ OK |
| EAP - Conjunto de Dados | DataFlows | 19:30 diário | ✅ OK |
| Teleconsulta (EAP) - Conjunto de Dados | DataFlows | 20:00 diário | ✅ OK |
| Crônicos - Conjunto de Dados | DataFlows | 21:30 diário | ✅ OK |
| Obesidade - Conjunto de Dados | DataFlows | 01:30 diário | ✅ OK |
| Saúde Emocional - Terapia Online - Conjunto de Dados | DataFlows | 00:30 diário | ✅ OK |
| Nutricall - Conjunto de Dados | DataFlows | 18:00 diário | ✅ OK |
| Nutricall - Teleorientação Nutricional - Conjunto de Dados | DataFlows | 18:30 diário | ✅ OK |
| Saúde Emocional - Teleorientação Psicológica - Conjunto de Dados | DataFlows | 19:30 diário | ✅ OK |
| Entrelaços - Conjunto de Dados | DataFlows | 22:30 diário | ✅ OK |
| Consultório Virtual - Conjunto de Dados | DataFlows | 07:00 diário | ✅ OK |
| Lista Beneficiários - Conjunto de Dados | DataFlows | 00:00 diário | ✅ OK |
| Detalhamento Clínico Teleconsultas - Conjunto de Dados | DataFlows | 10:30 diário | ✅ OK |
| Atendimentos D-1 - Conjunto de Dados | DataFlows | 09:30 diário | ✅ OK |
| Taxa Utilizacao - Conjunto de Dados | DataFlows | 07:00 diário | ✅ OK |
| Gestão de Monitoramento - Conjunto de Dados | DataFlows | 11:00 diário | ✅ OK |
| Saúde 60+ - Conjunto de Dados | DataFlows | 19:00 diário | ✅ OK |
| Hiperconsultadores - Conjunto de Dados | DataFlows | 22:00 diário | ✅ OK |
| IPSM | Clientes | 19:00 diário | ✅ OK |

### 2.2 Clientes Personalizados (B2B/B2G)

| Modelo | Cliente | Atualização | Status |
|--------|---------|-------------|--------|
| Alô Saúde Floripa - PMF | Prefeitura Floripa | 10:00 diário | ✅ OK |
| **Alô Saúde Floripa - PMF - Contrato Antigo** | Prefeitura Floripa | 19:00 | ❌ **FALHA MEMÓRIA** |
| CISNORDESTE - Atendimentos Concluídos | CISNORDESTE | 19:00 diário | ✅ OK |
| Unifique - Atendimentos Informações Gerais | Unifique | 08:00 diário | ✅ OK |
| Unifique - Operacional Diario | Unifique | 08:30 diário | ✅ OK |
| Relatório Complementar - Localiza | Localiza | 19:00 diário | ✅ OK |
| Informações Grupo Europ | Grupo Europ | 11:00 diário | ✅ OK |
| Ailos - BI de Vendas | Ailos | 09:00 diário | ✅ OK |
| Ailos - Gestão de Atendimentos | Ailos | 09:30 diário | ✅ OK |
| Transpetro - Gestão de Atendimentos | Transpetro | 10:30 diário | ✅ OK |
| Conecta SUS Ribeirão | SUS Ribeirão | 07:30 diário | ✅ OK |
| Grupo CASE - Gestão de Monitoramento | Grupo CASE | 11:30 diário | ✅ OK |
| Corpo e Mente em Forma | Corporativo | 09:00 diário | ✅ OK |
| Apresentação Correios | Correios | 11/10/2024 (única) | ✅ OK |
| PoC ANAC - Gestão Unificada Atendimentos | ANAC | 12/02/2025 (única) | ✅ OK |
| Gerencial TelaPet | TelaPet (homologação) | 09/12/2025 (única) | ✅ OK |

### 2.3 Policia Federal

| Modelo | Descrição | Atualização | Status |
|--------|-----------|-------------|--------|
| Mapeamento de Saúde Mental - Polícia Federal | Saúde mental PF | 21:30 diário | ✅ OK |
| Gestão de Atendimentos - Polícia Federal | Gestão PF | 18:00 diário | ✅ OK |

### 2.4 Outros

| Modelo | Descrição | Status |
|--------|-----------|--------|
| Report Usage Metrics Model | Métricas uso ( Saúde24h Basic) | ✅ OK (duplicado) |
| Report Usage Metrics Model | Métricas uso (Clientes) | ✅ OK (duplicado) |
| Mapeamento de Saúde Mental - Conjunto de Dados | Saúde mental | ✅ OK |
| Mapeamento de Saúde Psicossocial | Saúde psicossocial | ✅ OK (2x/dia) |

---

## 3. Problemas Identificados 🔴

### 3.1 CRÍTICO

| ID | Problema | Impacto | Modelo Afetado |
|----|----------|---------|----------------|
| **P001** | **Estouro de memória** | Refresh falha | Alô Saúde Floripa - PMF - Contrato Antigo |
| **P002** | Capacidade A2 insuficiente | Limitação enterprise | Todos os modelos |
| **P003** | **Duplicação de modelos** | Confusão, custo | Report Usage Metrics (2x) |

**Detalhe P001**:
```
Error: Resource Governing - Memory limit exceeded
Consumed: 2404 MB
Limit: 2378 MB
Database size: 693 MB
```

### 3.2 ALERTAS

| ID | Problema | Impacto | Observação |
|----|----------|---------|------------|
| **A001** | Múltiplas versões de mesmo produto | Manutenção complexa | Saúde24h tem 8 variações |
| **A002** | Gambiarras mencionadas | Technical debt | "Não amarrar ao construído" |
| **A003** | Silos de dados | Integração necessária | Financeiro × Assistencial |
| **A004** | Planilhas shadow IT | Governança fraca | Confirmado por Rafael |

---

## 4. Relatórios Admin

### 4.1 Monitoring

| Relatório | URL | Uso |
|-----------|-----|-----|
| Feature Usage and Adoption | [link](https://app.powerbi.com/groups/b4821abb-07c1-4f3a-969a-2248646200f9/reports/cbd45a4d-199a-45be-b6fe-44eff1148a12) | Métricas de uso |
| OneLake data hub | [link](https://app.powerbi.com/groups/b4821abb-07c1-4f3a-969a-2248646200f9/reports/742cf9f7-8501-4481-98b7-fa3921f1921e) | Catálogo dados |
| Microsoft Purview | [link](https://app.powerbi.com/groups/b4821abb-07c1-4f3a-969a-2248646200f9/reports/19937c76-0dd6-4e16-98f8-5eb33fabe8a8) | Governança |

---

## 5. Arquitetura Detectada

```
┌─────────────────────────────────────────────────────────────┐
│                    SQL Server (Fonte)                       │
│                  "infraestrutura capenga"                  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Power Query / Dataflows                  │
│                  _DataFlows e Conjuntos (Relatórios)        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Modelos Semânticos                     │
│                       (53 modelos)                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Relatórios Power BI                    │
│                    Capacidade A2 (Brazil South)             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Próximos Passos

- [ ] Analisar estrutura dos modelos (tabelas, relacionamentos)
- [ ] Mapear fontes de dados SQL Server
- [ ] Identificar duplicações e consolidar
- [ ] Propor arquitetura target
- [ ] Priorizar Quick Wins

---

**Status**: Documento em construção
**Próxima atualização**: Após análise dos novos arquivos
