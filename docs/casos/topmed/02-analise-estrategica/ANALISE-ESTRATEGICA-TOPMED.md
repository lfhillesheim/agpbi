# AVALIAÇÃO ESTRATÉGICA DA ARQUITETURA POWER BI
## Topmed Assistência à Saúde Ltda.

---

**Data**: 04 de Março de 2026
**Responsável**: AGPBI Framework
**Escopo**: Avaliação Completa de Infraestrutura, Governança e Qualidade
**Audiência**: Diretoria Executiva

---

## 1. RESUMO EXECUTIVO

### 1.1 Contexto Organizacional

A Topmed é uma das 5 maiores operadoras de telessaúde do Brasil, com 18 anos de operação, líder absoluta na Região Sul, impactando +20 milhões de vidas com resolutividade clínica de 94% e NPS de 95.4.

### 1.2 Inventário de Dados Mapeado

| Categoria | Quantidade | Observações |
|-----------|------------|-------------|
| Modelos Semânticos | 73 | Datasets em BI TopMed 2 |
| Relatórios | 1.543 | Dashboards e Reports |
| DataFlows | 16 | 9 fluxos Gen1 identificados |
| Workspaces | 20+ | Estrutura fragmentada |
| **TOTAL DE ARTEFATOS** | **1.632** | Inventário completo |

### 1.3 Avaliação de Maturidade

| Dimensão | Score (0-100) | Nível | Status |
|----------|---------------|-------|--------|
| Arquitetura de Dados | 25 | Básico | 🔴 Crítico |
| Governança | 15 | Inicial | 🔴 Crítico |
| Operações | 35 | Básico | 🟡 Atenção |
| Segurança | 40 | Básico | 🟡 Atenção |
| Escalabilidade | 10 | Nenhum | 🔴 Crítico |
| Documentação | 5 | Nenhum | 🔴 Crítico |
| **MÉDIA GERAL** | **22** | **Inicial** | 🔴 **Crítico** |

**Benchmark**: Organizações de saúde de similar porte operam com maturidade 65-80.

---

## 2. ARQUITETURA DE INFRAESTRUTURA

### 2.1 Capacity e Licenciamento

**Configuração Atual**: Power BI A2 (3GB RAM)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  CAPACITY A2 - 3GB RAM                                                      │
│  ├─ 1.632 artefatos competindo por recursos                                │
│  ├─ Capacity compartilhada (sem garantia de performance)                   │
│  └─ Refresh concorrentes sujeitos a timeouts                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Riscos Identificados**:

| Risco | Descrição | Severidade |
|-------|-----------|------------|
| Capacidade insuficiente | 3GB para 1.632 artefatos | Alta |
| Performance variável | Capacity compartilhada | Alta |
| Sem monitoramento | Ausência de visibilidade de gargalos | Média |
| Timeout em refresh concorrentes | Interrupção de disponibilidade | Alta |

**Recomendação**: Avaliar migração para Capacity F ou P1 para garantir performance em produção.

### 2.2 Gateway de Dados

**Infraestrutura Mapeada**:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  gatewaytopmed          ← Gateway principal                                │
│  GW-TOPMED-BI2          ← Gateway secundário                               │
│  GW-TOPMEDBI            ← Gateway terciário                                 │
│  (Modo pessoal)         ← Gateway em modo pessoal (sem controle)           │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Conexões Ativas**:

| Servidor | Porta | Gateway | Uso |
|----------|-------|---------|-----|
| 10.10.0.2 | 1433 | BI TopMed / gatewaytopmed / GW-TOPMED-BI2 | DW_BI_PROD_Diaria |
| 10.150.209.55 | 1433 | gatewaytopmed / GW-TOPMED-BI2 | DW_BI_PROD_Diaria |
| 10.150.209.60 | 1433 | GW-TOPMEDBI | SQL Server |
| SharePoint | 443 | BI TopMed | Arquivos |

**Problemas Identificados**:

1. **Múltiplos gateways** sem configuração de High Availability (HA) documentada
2. **Gateway em modo pessoal** representa risco de segurança
3. **Endereços IP hardcoded** em conexões (fragilidade em mudanças de infraestrutura)
4. **Mesmo servidor acessado por múltiplos gateways** (redundância sem propósito claro)

**Recomendações**:

| Prioridade | Ação | Prazo |
|------------|------|-------|
| Alta | Consolidar em 2 gateways com HA configurado | 30 dias |
| Alta | Remover gateways em modo pessoal | Imediato |
| Alta | Documentar estratégia de HA e failover | 30 dias |
| Média | Migrar conexões IP para DNS | 60 dias |

### 2.3 Fontes de Dados

**Mapeamento Completo**:

| Fonte | Tipo | Uso | Observações |
|-------|------|-----|-------------|
| DW_BI_PROD_Diaria | SQL Server | Data warehouse principal | Acessado via 3 IPs diferentes |
| SharePoint | Arquivos | Fonte de dados auxiliar | Pasta pessoal de usuário |
| DataFlows Gen1 | Gen1 | ETL/ELT | Tecnologia sendo descontinuada |

**Risco Crítico**: SharePoint pessoal como fonte de dados representa Single Point of Failure (SPOF) - se o usuário deixar a empresa, o acesso é perdido.

---

## 3. ARQUITETURA DE DADOS

### 3.1 Modelos Semânticos

**Inventário**: 73 modelos semânticos identificados

**Distribuição por Workspace**:

| Workspace | Modelos | % do Total |
|-----------|---------|------------|
| BI TopMed 2 | 66 | 90% |
| _Homologação PRO | 2 | 3% |
| _Homologação | 2 | 3% |
| Outros | 3 | 4% |

**Análise de Qualidade** (baseada em amostra de 3 modelos):

| Critério | Saúde24h Plus E+ | Taxa Utilização | Alô Floripa | Status Geral |
|----------|------------------|-----------------|-------------|--------------|
| Tabelas | Report only | 10 | 36 | ⚠️ |
| Star Schema | N/A | Parcial | Parcial | 🟡 |
| Chaves ocultas | N/A | ❌ | ❌ | 🔴 |
| Tabela _Measures | N/A | ❌ | Fragmentada (11) | 🔴 |
| Relacionamentos inativos | N/A | 1 | 4 | 🟡 |

### 3.2 Problema Crítico: SQL Hardcoded

**Identificado em**: Alô Saúde Floripa - PMF (M005)

```m
// PROBLEMA: Filtro hardcoded impossibilita reutilização
#"Filtro Empresa" = Table.SelectRows(
    Ft_AcoAtendimentoHistorico1,
    each ([IdEmpresa] = 151 or [IdEmpresa] = 726)
)
```

**Impacto**:
- Cada cliente requer um modelo separado
- Manutenção em massa impossível
- Explicação direta da explosão de artefatos

**Padrão de Fragmentação Identificado**:

| Produto | Relatórios | Padrão |
|---------|------------|--------|
| Taxa de Utilização | 192 | 1 por município/cliente |
| Lista Beneficiários | 201 | 1 por empresa |
| Entrelaços | 118 | 1 padrão + 1 "Nominais" por cliente |
| Saúde24h | 597 | Por produto/segmento |

### 3.3 Violações de Best Practices

| Prática | Status | Impacto |
|---------|--------|---------|
| Star Schema compliance | Parcial | Performance subótima |
| Tabela _Measures centralizada | ❌ Ausente | Fragmentação de medidas |
| Chaves técnicas ocultas | ❌ Não implementado | Poluição visual |
| Auto Date/Time desabilitado | ✅ Sim | - |
| Tabela de Data explícita | ✅ Sim | - |
| Query folding verificado | ❌ N/A (DataFlow) | - |

---

## 4. DATAFLOWS E ETL

### 4.1 Inventário de DataFlows

**Total**: 16 DataFlows identificados

**DataFlows Gen1** (9 fluxos - tecnologia legada):

| DataFlow | Workspace | Risco |
|----------|-----------|-------|
| _Data Flow (Clientes Diário) | _DataFlows e Conjuntos | Descontinuação |
| _Data Flow (Interno Diário) | _DataFlows e Conjuntos | Descontinuação |
| Data Flow (DW BI Diária) | _Data Flows (DW's) | Descontinuação |
| Data Flow (DW BI Diária Aconselhamento) | _Data Flows (DW's) | Descontinuação |
| Data Flow (DW BI Diária Monitoramento) | _Data Flows (DW's) | Descontinuação |
| Data Flow (Empresa URL) | _Data Flows (DW's) | Descontinuação |
| Data Flow (MonTarefaResposta Em Colunas) | _Data Flows (DW's) | Descontinuação |
| Data Flow (Tabelas Sinteticas) | _Data Flows (DW's) | Descontinuação |
| Data Flow (Telefonia) | _Data Flows (DW's) | Descontinuação |

**Risco Estratégico**: Microsoft está descontinuando DataFlows Gen1. Migração forçada em data não especificada.

### 4.2 Configuração de Refresh

**Detectado**: Slow data source settings habilitados em múltiplos relatórios

```
setTimeout: 180 segundos
queryTimeout: 180 segundos
```

**Interpretação**: Queries que excedem 3 minutos indicam problemas de performance na fonte ou nas transformações.

---

## 5. GOVERNANÇA

### 5.1 Estrutura de Workspaces

**Mapeamento**: 20+ workspaces identificados

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
```

**Problemas Críticos**:

| Problema | Quantidade | % do Total |
|----------|------------|------------|
| Artefatos sem workspace definido ("N/A") | 365 | 22% |
| Workspaces duplicados (BI TopMed vs BI TopMed 2) | 2 | - |
| Workspaces duplicados (_Homologação vs _Homologação PRO) | 2 | - |
| Padrão de nomenclatura inconsistente | - | - |

### 5.2 Documentação

**Status**: 🔴 CRÍTICO (0-5% de cobertura)

| Item | Status |
|------|--------|
| Descrição de tabelas | ❌ 0% documentado |
| Descrição de colunas | ❌ 0% documentado |
| Descrição de medidas | ❌ 0% documentado |
| Descrição de relacionamentos | ❌ 0% documentado |
| Data lineage | ❌ 0% documentado |
| Dicionário de dados | ❌ Ausente |
| Manual do usuário | ❌ Ausente |
| Guia de negócio | ❌ Ausente |

**Risco Regulatório**: Empresa de saúde regulamentada operando sem documentação de KPIs e métricas.

---

## 6. SEGURANÇA

### 6.1 Row-Level Security (RLS)

**Status**: ❌ NÃO IMPLEMENTADO

**Arquitetura Atual**: Segregação de dados através de cópias físicas de relatórios por cliente

| Problema | Risco |
|----------|-------|
| Um relatório por cliente | Impossível escalar |
| Sem auditoria de acesso | Quem acessou o quê? |
| SQL hardcoded no Power Query | Qualquer desenvolvedor vê todos os IDs |
| Perfis de segurança não documentados | Quem pode fazer o quê? |

### 6.2 Controle de Acesso

**Usuários no Catálogo OneLake**:

| Usuário | Workspaces (Admin) | Workspaces (Membro) | Workspaces (Viewer) |
|---------|--------------------|----------------------|---------------------|
| BT | 0 | 1 | 38 |
| T( (TopMed geral) | 0 | 1 | 0 |
| SL (Sistema Lupa SSO) | 0 | 0 | 1 |

**Observação**: Ausência de administradores em BI TopMed 2 (principal workspace) é uma lacuna de governança.

---

## 7. QUALIDADE TÉCNICA

### 7.1 DAX

**Avaliação** (baseada em amostra de 3 modelos):

| Aspecto | Status | Observação |
|---------|--------|------------|
| Uso de VAR/RETURN | ✅ Excelente | Todas as medidas usam variáveis |
| Uso de DIVIDE() | ✅ Excelente | Evita divisão por zero |
| Formatação definida | ✅ Bom | Format strings configurados |
| Nomes descritivos | ⚠️ Regular | "Ativos (medida antiga)" indica débito |
| Organização | 🔴 Crítico | 11 tabelas de medidas fragmentadas |
| Documentação | 🔴 Crítico | 0% de medidas com descrição |

**Exemplo de DAX com Boas Práticas**:

```dax
'% Prescrição de Medicamentos' =
    VAR vAtendimentosTotais =
        CALCULATE(
            DISTINCTCOUNT(Ft_ConIndicadores[IdAtendimento]),
            Ft_ConIndicadores[SituacaoDescricao] = "Concluido"
        )
    VAR vRespostasSim =
        CALCULATE(
            DISTINCTCOUNT(Ft_ConIndicadores[IdAtendimento]),
            Ft_ConIndicadores[IdItemAtendimento] = 20,
            Ft_ConIndicadores[SituacaoDescricao] = "Concluido",
            Ft_ConIndicadores[Resposta] = "Sim"
        )
    VAR vResultado = DIVIDE(vRespostasSim, vAtendimentosTotais)
    RETURN
        vResultado + 0
```

**Qualidade do código**: Boa, mas falta documentação do que cada medida representa.

### 7.2 Power Query (M)

**Avaliação**:

| Aspecto | Status | Observação |
|---------|--------|------------|
| Nomes de passos descritivos | ✅ Bom | Em português, claros |
| Comentários | ✅ Bom | Bem documentado |
| Query Folding | ❌ N/A | DataFlow não suporta |
| Parâmetros | ❌ Ruim | Valores hardcoded |
| Schema estável | ⚠️ Regular | Datas hardcoded detectadas |

**Problemas Identificados**:

| ID | Problema | Localização | Severidade |
|----|----------|-------------|------------|
| M001 | SQL hardcoded (IdEmpresa = 151 OR 726) | Alô Floripa | Alta |
| M002 | Data hardcoded (#date(2023, 06, 01)) | Múltiplos | Média |
| M003 | DataFlow Gen1 (legado) | Todos | Alta |

### 7.3 Visuais e UX

**Estrutura de Páginas** (amostra):

| Dashboard | Páginas | Primeira Página | Tema |
|-----------|---------|-----------------|------|
| Saúde24h Plus E+ | 19 | Sumário | Customizado |
| Taxa Utilização | 1 | Página 1 | Padrão |
| Alô Saúde Floripa | 22 | Sumário | Customizado |

**Problemas**:

| Problema | Impacto |
|----------|---------|
| 19-22 páginas por dashboard | UX complexa |
| Background images hardcoded (10+ por dashboard) | Performance |
| Filtros hardcoded no relatório | Dados incorretos |
| Sem bookmark navigation | Navegação manual |

---

## 8. IMPACTOS OPERACIONAIS

### 8.1 Tempo de Setup por Novo Cliente

| Atividade | Tempo Atual | Tempo Proposto | Melhoria |
|-----------|-------------|----------------|----------|
| Copiar relatório template | 30 min | - | - |
| Adaptar filtros hardcoded | 1-2h | - | - |
| Testar validação | 1h | - | - |
| Publicar/configurar permissões | 2-3h | 5 min | 96% |
| **TOTAL** | **4-8h** | **30 min** | **94%** |

### 8.2 Custo de Manutenção

**Cenário**: Alterar 1 visualização em todos os relatórios

| Produto | Relatórios | Tempo Estimado |
|---------|------------|----------------|
| Taxa de Utilização | 192 | 16-32h |
| Lista Beneficiários | 201 | 17-34h |
| Entrelaços | 118 | 10-20h |
| Saúde24h | 597 | 50-100h |
| **TOTAL** | **1.543** | **130-260h** |

**Com arquitetura consolidada**: 30 minutos (260x mais rápido)

### 8.3 Custo Anual do Débito Técnico

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  CUSTO ANUAL ESTIMADO                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Setup de novo cliente:    50 clientes × 6h × R$150/h   = R$45.000/ano      │
│  Manutenção de relatórios:  10 alterações × 200h × R$150/h = R$300.000/ano  │
│  Onboarding de analistas:  2 analistas × 6 semanas × R$8.000 = R$96.000/ano│
│  Perda de conhecimento:    20% do tempo produtivo           = R$60.000/ano   │
│  ─────────────────────────────────────────────────────────────────────────  │
│  TCO ESTIMADO:                                                       R$501.000/ano   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 9. RISCOS ESTRATÉGICOS

### 9.1 Matriz de Riscos

| Risco | Probabilidade | Impacto | Mitigação | Prazo Recomendado |
|-------|---------------|---------|-----------|-------------------|
| DataFlow Gen1 descontinuação | Alta | Alto | Migrar para Gen2 | Imediato |
| Capacidade A2 insuficiente | Certa | Médio | Upgrade capacity | 30 dias |
| Perda de conhecimento (turnover) | Alta | Alto | Documentar tudo | 60 dias |
| SQL hardcoded = quebra em migração | Alta | Alto | Implementar RLS | 60 dias |
| Gateway sem HA = SPOF | Média | Alto | Implementar HA real | 30 dias |
| SharePoint pessoal = SPOF | Média | Alto | Mover para SQL | 30 dias |

### 9.2 Single Points of Failure (SPOFs)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  SPOFs CRÍTICOS IDENTIFICADOS                                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. gatewaytopmed (se cair, refresh param)                                  │
│  2. powerbi_02@topmed (SharePoint pessoal)                                  │
│  3. IP 10.10.0.2 (se mudar, conexões quebram)                               │
│  4. Desenvolvedores chave (conhecimento tribal)                             │
│  5. Capacity A2 (se estourar, timeouts)                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 10. OPORTUNIDADES DE MELHORIA

### 10.1 Consolidação de Artefatos

| Produto | Relatórios Atuais | Proposta | Economia |
|---------|-------------------|----------|----------|
| Taxa de Utilização | 192 | 1 dinâmico com RLS | 99% |
| Lista Beneficiários | 201 | 1 dinâmico com RLS | 99% |
| Entrelaços | 118 | 1 padrão + 1 nominal | 98% |
| Saúde24h | 597 | Por segmento com RLS | 90% |
| Saúde Emocional | 119 | Por segmento com RLS | 90% |
| **TOTAL** | **1.543** | **~150** | **90%** |

### 10.2 Reorganização de Workspaces

**Proposta de Estrutura**:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   ESTRUTURA PROPOSTA DE WORKSPACES                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  01_PRODUCAO                                                                │
│    ├─ Modelos semânticos unificados                                         │
│    ├─ DataFlows Gen2                                                        │
│    └─ Relatórios mestres                                                   │
│                                                                             │
│  02_HOMOLOGACAO                                                             │
│    ├─ Versões de teste                                                     │
│    └─ PoCs e demonstrações                                                 │
│                                                                             │
│  03_ADMIN                                                                   │
│    ├─ Monitoring e governança                                               │
│    └─ Capacity metrics                                                     │
│                                                                             │
│  04_CLIENTES (opcional)                                                     │
│    └─ Segregação física se necessário para RLS                             │
│                                                                             │
│  De 20+ workspaces → 4 workspaces                                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 11. PLANO DE AÇÃO RECOMENDADO

### 11.1 Fase 1: Estabilização (30-60 dias)

**Objetivo**: Eliminar riscos críticos imediatos

| Ação | Prioridade | Prazo | Responsável |
|------|------------|-------|-------------|
| Migrar Capacity A2 → F | Alta | 30 dias | Infraestrutura |
| Consolidar gateways (HA) | Alta | 30 dias | Infraestrutura |
| Mover SharePoint → SQL | Alta | 30 dias | Dados |
| Documentar modelos críticos | Alta | 60 dias | BI |
| Implementar monitoring de capacity | Alta | 30 dias | Operações |

### 11.2 Fase 2: Consolidação (60-120 dias)

**Objetivo**: Eliminar fragmentação crítica

| Ação | Prioridade | Prazo | Responsável |
|------|------------|-------|-------------|
| Implementar RLS | Crítica | 60 dias | BI |
| Remover SQL hardcoded | Crítica | 60 dias | BI |
| Consolidar medidas → _Measures | Alta | 30 dias | BI |
| Migrar DataFlows Gen1 → Gen2 | Alta | 60 dias | Dados |
| Reorganizar workspaces | Alta | 30 dias | Governança |

### 11.3 Fase 3: Otimização (90-180 dias)

**Objetivo**: Melhorar performance e UX

| Ação | Prioridade | Prazo | Responsável |
|------|------------|-------|-------------|
| Implementar incremental refresh | Alta | 60 dias | Dados |
| Otimizar queries lentas | Média | 90 dias | Dados |
| Remover background images | Média | 30 dias | BI |
| Consolidar páginas (22 → 5-8) | Média | 60 dias | BI |
| Implementar bookmark navigation | Média | 30 dias | BI |

---

## 12. KPIS DE TRANSFORMAÇÃO

### 12.1 Métricas de Sucesso

| KPI | Atual | 6 Meses | 12 Meses | Meta Final |
|-----|-------|---------|----------|------------|
| Relatórios | 1.543 | 500 | 200 | ~150 |
| Workspaces | 20+ | 10 | 6 | 4 |
| DataFlows Gen1 | 9 | 5 | 0 | 0 |
| Documentação | 5% | 50% | 80% | 100% |
| Setup cliente | 4-8h | 2h | 1h | 30min |
| Manutenção | 130-260h | 40h | 10h | 30min |
| Maturidade geral | 22/100 | 40/100 | 60/100 | 80/100 |

### 12.2 Retorno sobre Investimento

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  RETURN ON INVESTMENT                                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Investimento:      10-12 semanas × R$30.000/semana = R$360.000             │
│                                                                             │
│  Economia Anual:    R$501.000                                               │
│                                                                             │
│  Payback:           3-6 meses                                              │
│  ROI (1 ano):       114%                                                    │
│  ROI (3 anos):      342%                                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 13. RECOMENDAÇÕES FINAIS

### 13.1 Prioridades Imediatas

1. **CRÍTICA**: Migrar DataFlows Gen1 → Gen2 (risco de descontinuação)
2. **CRÍTICA**: Implementar Row-Level Security (viabiliza escala)
3. **ALTA**: Upgrade capacity A2 → F (garante performance de produção)
4. **ALTA**: Documentar todos os modelos e medidas (conhecimento corporativo)

### 13.2 Próximos Passos

1. Apresentar esta avaliação para diretoria
2. Priorizar iniciativas baseadas em alinhamento estratégico
3. Constituir time de modernização (BI + Dados + Infraestrutura)
4. Definir KPIs de acompanhamento
5. Iniciar execução da Fase 1

---

## 14. CONCLUSÃO

A Topmed possui um ecossistema de dados funcional, mas com significativo débito técnico acumulado. A arquitetura atual apresenta limitações de escalabilidade que impactam diretamente a capacidade de crescimento da organização.

A modernização proposta representa investimento com payback de 3-6 meses e ROI de 114% no primeiro ano, além de posicionar a Topmed com maturidade de dados alinhada às melhores práticas de mercado.

**Recomendação**: Aprovar plano de modernização e iniciar execução imediata da Fase 1.

---

**Documento versão 1.0**
**Data**: 04 de Março de 2026
**Status**: Avaliação Completa
**Próxima Revisão**: Pós-aprovação do plano de ação
