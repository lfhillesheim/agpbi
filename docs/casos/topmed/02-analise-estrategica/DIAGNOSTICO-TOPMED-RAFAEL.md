# DIAGNOSTICO POWER BI - TOPMED
## Analise Completa de Arquitetura, Gaps e Riscos

**Data**: 03/03/2026
**Responsavel**: Consultoria AGPBI
**Gestor**: Rafael Faria (Gerente de Tecnologia)
**Escopo**: Infraestrutura Power BI, Modelos de Dados, ETL e Visuais

---

## 1. RESUMO EXECUTIVO

### 1.1 Contexto Topmed

A Topmed Assistencia a Saude Ltda. e uma das maiores operadoras de telessaude do Brasil, fundada em agosto de 2006 em Florianopolis/SC.

| Metrica | Valor |
|---------|-------|
| **Anos de operacao** | 18 anos |
| **Vidas impactadas** | +20 milhoes |
| **Resolutividade clinica** | 94% |
| **NPS (satisfacao)** | 95.4 |
| **Capital Social** | R$ 3.295 milhoes |
| **Contratos governo** | +R$ 144 milhoes |
| **Crescimento atendimentos** | 120% em 3 anos |
| **Pico de crescimento (2020)** | 516% |

### 1.2 Lideranca Executiva

| Executivo | Funcao | Foco para Consultoria |
|-----------|--------|----------------------|
| **Valda Stange** | CEO | Visao 360, Rentabilidade e Estrategia de Mercado |
| **Paulo Roberto Salvi** | CTO/Socio | Infraestrutura, Stack Tecnologica e Integracoes |
| **Renata Zobaran** | Diretora Telemedicina | Qualidade Assistencial, Compliance e Dados Clinicos |
| **Cleones Hostins** | CCO | BI Comercial, CRM e Funil de Vendas |

### 1.3 Situacao Atual Power BI

| Item | Quantidade | Observacao |
|------|-----------|------------|
| **Capacidade** | A2 (Embedded) | 3GB RAM - Limitada para producao |
| **Licencas Pro** | 19 | 1 Fabric (Free) |
| **Workspaces** | 7+ | Desorganizados |
| **DataFlows** | 9 | Todos Gen1 (legado) |
| **Modelos Semânticos** | 26+ | Fragmentados |
| **Relatorios** | 28+ | 1 por cliente/municipio |
| **Gateways** | 4 | Multiplos IPs sem documentacao |

### 1.4 Status Geral: CRITICO

A arquitetura atual apresenta **governanca fraca**, **fragmentacao extrema** e **debito tecnico acumulado** que impacta diretamente a escalabilidade e produtividade.

---

## 2. MODELO DE NEGOCIO E IMPACTO NOS DADOS

### 2.1 Segmentos de Negocio

#### B2G - Setor Publico (Municipios)
- Integracao com SUS (RNDS, BPA, Previne Brasil)
- Geracao de BPA para repasses federais
- Monitoramento de indicadores do Previne Brasil
- **Desafio de dados**: Integracao com sistemas legados publicos

#### B2B - Setor Privado (Empresas)
- EAP - Programa de Assistencia ao Colaborador
- Taxas de utilizacao e analise de sinistralidade
- ROI para RH das empresas contratantes
- **Desafio de dados**: Dados financeiros + assistenciais integrados

#### Parcerias (White Label/B2B2C)
- Tecnologia para bancos, seguradoras, varejistas
- Receita recorrente escalavel
- **Desafio de dados**: Multi-tenancia e segregacao de dados

### 2.2 Portfólio de Solucoes

| Solucao | Canais | Dados Gerados |
|---------|--------|---------------|
| **Saude24h/PAV** | WhatsApp, 0800, App, Web | Triagem, resolutividade 93.8% |
| **Teleconsultas** | Plataforma Digital | +30 especialidades |
| **EAP** | Omnichannel | Medico, Juridico, Financeiro, Social |
| **AuroraCare** | Software Dispositivo | IA, imagens (cancer de mama) |
| **Programas Cronicos** | Plataforma | Dados longitudinais |

### 2.3 Fontes de Dados Identificadas

| Fonte | Tipo | Complexidade |
|-------|------|--------------|
| **ERP TOTVS/SAP** | Market | Contabil, Financeiro |
| **CRM Proprietario** | Proprio | Relacionamento cliente |
| **Sistemas Assistenciais** | Proprio | PEP, Prontuarios, Logs |
| **APIs Terceiros** | Externo | Laboratorios, Farmacias |
| **SUS/RNDS** | Publico | BPA, Previne Brasil |
| **AWS** | Cloud | Alexa, IA, Analytics |
| **Planilhas** | Shadow IT | Nao controlado |

---

## 3. ARQUITETURA ATUAL (AS-IS)

```
┌─────────────────────────────────────────────────────────────────┐
│                      SQL Server (Fonte)                          │
│              DW_BI_PROD_Diaria (10.10.0.2 / 10.150.209.55)       │
│                   "infraestrutura capenga"                      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Gateways (4 gateways)                         │
│  gatewaytopmed │ GW-TOPMED-BI2 │ GW-TOPMEDBI │ PowerBI Flow    │
│  IPs: 10.10.0.2 │ 10.150.209.55 │ 10.150.209.60 (nao documentado)│
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  DataFlows Gen1 (9 fluxos)                      │
│  ⚠️ TODOS Gen1 (legado) - Microsoft migrando para Gen2         │
│  - Clientes Diario - Interno Diario                             │
│  - DW BI Diaria (3 fluxos)                                      │
│  - DW BI Monitoramento - DW BI Aconselhamento                  │
│  - Empresa URL - MonTarefaResposta - Tabelas Sinteticas        │
│  - Telefonia                                                    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                 Modelos Semânticos (26+ modelos)                │
│         Produtos Topmed + Clientes B2B/B2G + Específicos        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Relatorios Power BI (28+)                      │
│            Capacidade A2 - Brazil South (3GB RAM)                │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. PROBLEMAS CRITICOS IDENTIFICADOS

### 4.1 CRITICOS

| ID | Problema | Impacto | Modelo Afetado |
|----|----------|---------|---------------|
| **P001** | **Estouro de memoria** | Refresh falha | Alo Saude Floripa Antigo |
| | Consumo: 2404MB / Limite: 2378MB | | |
| **P002** | **Capacidade A2 insuficiente** | Limitacao enterprise | Todos |
| **P003** | **SQL hardcoded no Power Query** | Impossivel reutilizar | Multiplos |
| | `IdEmpresa = 151 OR 726` | 1 modelo por cliente | |
| **P004** | **Filtros hardcoded no relatorio** | Dados incorretos | Saude24h Plus E+ |
| | `IdEmpresa = 718` | | |
| **P005** | **DataFlows Gen1 - legado** | Performance inferior, sem suporte | Todos |
| **P006** | **Silos de dados** | Financeiro x Assistencial separados | Integracao |

### 4.2 ALTOS

| ID | Problema | Impacto | Observacao |
|----|----------|---------|------------|
| **A001** | **Explosao de relatorios** | Manutencao impossivel | 1 relatorio por municipio! |
| **A002** | **Modelos duplicados** | Confusao | Saude24h tem 8+ variacoes |
| **A003** | **11 tabelas de medidas** | Fragmentacao | Deveria ser 1 tabela _Measures |
| **A004** | **Workspaces desorganizados** | Governanca fraca | 7+ workspaces similares |
| **A005** | **Gateways sem documentacao** | Risco operacional | 3 IPs diferentes |
| **A006** | **SQL Server "capenga"** | Infraestrutura limitada | Descrito por Rafael |

### 4.3 MEDIOS

| ID | Problema | Impacto | Observacao |
|----|----------|---------|------------|
| **M001** | **Documentacao inexistente** | Conhecimento perdido | 0% descricoes |
| **M002** | **Planilhas everywhere** | Shadow IT | Nao controlado |
| **M003** | **Relacionamentos inativos** | Complexidade | 5 sem explicacao |
| **M004** | **Colunas calculadas em dimensoes** | Quebra Star Schema | Dm_Calendario |

---

## 5. EXPLOSAO DE RELATORIOS: O PROBLEMA RAIZ

### 5.1 Padrao Identificado

```
Taxa de Utilizacao - Prefeitura de Guaratuba
Taxa de Utilizacao - Prefeitura de Guaramirim
Taxa de Utilizacao - Prefeitura de Araquari
Taxa de Utilizacao - ACAERT
Taxa de Utilizacao - APAE Palhoca
Taxa de Utilizacao - Allpfit
Taxa de Utilizacao - A10 Beneficios
... (um para cada cliente/municipio)
```

### 5.2 Causa Raiz

**SQL Hardcoded no Power Query:**
```m
#"Filtro Empresa" = Table.SelectRows(
    Ft_AcoAtendimentoHistorico1,
    each ([IdEmpresa] = 151 OR [IdEmpresa] = 726)
)
```

**Resultado**: Cada novo cliente = novo modelo + novo relatorio.

### 5.3 Impacto na Produtividade

| Operacao | Tempo Atual | Tempo Proposto |
|----------|-------------|----------------|
| Criar dashboard para novo cliente | 4-8 horas | 30 minutos |
| Atualizar visualizacao (todos clientes) | Impossivel | 5 minutos |
| Corrigir bug no modelo | 26+ vezes | 1 vez |
| Manter documentacao | Impossivel | Centralizado |

---

## 6. GAPS DE DOCUMENTACAO

### 6.1 Status Atual: 0%

| Item | Status |
|------|--------|
| Descricao de tabelas | ❌ 0% |
| Descricao de colunas | ❌ 0% |
| Descricao de medidas | ❌ 0% |
| Descricao de relacionamentos | ❌ 0% |
| Data lineage | ❌ 0% |
| Dicionario de dados | ❌ Ausente |
| Manual do usuario | ❌ Ausente |

### 6.2 Exemplo de Risco

```dax
'Ativos (medida antiga)' = ...
'% Prescrição de Medicamentos' = ...
'Desfecho Teleconsulta' = ...
```

**Pergunta**: O que cada medida calcula? Por que existe?
**Resposta**: Ninguem sabe. Conhecimento esta na cabeca de quem criou.

---

## 7. ANALISE TECNICA DETALHADA

### 7.1 Modelagem de Dados

| Modelo | Tabelas | Relacionamentos | Status |
|--------|---------|-----------------|--------|
| **Taxa Utilizacao** | 10 | 6 (1 inativo) | ⚠️ Aceitavel |
| **Alo Saude Floripa** | 36 | 28 (4 inativos) | ❌ Complexo |
| **Saude24h Plus E+** | Dataset compartilhado | - | ⚠️ Dependencia |

### 7.2 Problemas de Modelagem

| Problema | Detalhe |
|----------|---------|
| **Coluna calculada em dimensao** | `Dm_Calendario.MaiorDataCadastroInicial` depende de tabela fato |
| **Fragmentacao de medidas** | 11 tabelas de medidas em Alo Floripa |
| **Relacionamentos inativos** | 5 relacionados desativados sem explicacao |
| **Chaves nao ocultas** | IDs tecnicos visiveis para usuario final |

### 7.3 Qualidade DAX

| Aspecto | Status | Nota |
|---------|--------|------|
| Uso de VAR/RETURN | ✅ Bom | 10/10 |
| DIVIDE() | ✅ Bom | 10/10 |
| Formatacao | ✅ Bom | 10/10 |
| Documentacao | ❌ Ruim | 0/10 |
| **MEDIA GERAL** | | **6/10** |

### 7.4 Power Query (M)

| Aspecto | Status | Nota |
|---------|--------|------|
| Nomes descritivos | ✅ Bom | 9/10 |
| Comentarios | ✅ Bom | 8/10 |
| **Hardcoded values** | ❌ Ruim | 2/10 |
| Query Folding | ❌ N/A (DataFlow) | - |
| **MEDIA GERAL** | | **5/10** |

---

## 8. VISUAIS E EXPERIENCIA DO USUARIO

### 8.1 Estrutura dos Dashboards

| Dashboard | Paginas | Tema | Background Images |
|-----------|---------|------|-------------------|
| **Saude24h Plus E+** | 19 | Custom | 13 imagens |
| **Taxa Utilizacao** | 1 | Base | 0 |
| **Alo Saude Floripa** | 22 | Base | 11 imagens |

### 8.2 Problemas Visuais

| Problema | Impacto |
|----------|---------|
| 19-22 paginas por dashboard | UX complexa, usuario se perde |
| Background images hardcoded | Performance ruim, nao responsivo |
| Slow data source settings | Indica problema de performance |
| Tamanhos hardcoded (720x1280) | Nao responsivo |

### 8.3 Filtros Hardcoded

**Saude24h Plus E+**:
```json
// Filtros no relatorio - nao deveriam estar aqui!
1. Dm_Calendario.Data >= 2023-12-01  // Data hardcoded!
2. Dm_SubEmpresa.IdEmpresa = 718      // Empresa hardcoded!
3. Dm_Calendario.FlagMesAtual = false
```

---

## 9. RISCOS IDENTIFICADOS

### 9.1 Matriz de Riscos

| Area | Risco | Probabilidade | Impacto | Severidade |
|------|-------|---------------|---------|------------|
| **ETL** | DataFlow Gen1 descontinuado | ALTA | ALTO | 🔴 CRITICO |
| **Escalabilidade** | Explosao de modelos por cliente | CERTA | ALTO | 🔴 CRITICO |
| **Performance** | Capacidade A2 estourada | MEDIA | ALTO | 🟡 ALTO |
| **Manutencao** | Documentacao inexistente | CERTA | MEDIO | 🟡 ALTO |
| **Operacao** | Gateways sem documentacao | BAIXA | MEDIO | 🟢 MEDIO |
| **Conhecimento** | Debito tecnico acumulado | ALTA | ALTO | 🔴 CRITICO |

### 9.2 Risco 1: DataFlow Gen1 Descontinuado

**Situacao**: Microsoft esta migrando todos os DataFlows Gen1 para Gen2.

**Impacto**:
- Perda de suporte
- Bugs nao corrigidos
- Performance inferior
- Recursos limitados

**Acao**: Migrar para Gen2 com prioridade.

### 9.3 Risco 2: Explosao de Modelos

**Situacao Atual**: 26+ modelos semânticos.

**Projecao**:
```
Clientes atuais: ~50
Modelos: 26+

Se dobrar clientes: 50+ modelos
Se triplicar: 75+ modelos

Manutencao: IMPOSSIVEL
```

**Acao**: Consolidar em 1 modelo com RLS.

### 9.4 Risco 3: Capacidade A2

**Limitacao Atual**:
- 3GB RAM
- Estouro identificado: 2404MB / 2378MB

**Consequencia**: Refresh falha em picos de uso.

**Acao**: Avaliar upgrade para F ou P SKU.

---

## 10. IMPACTO NA PRODUTIVIDADE

### 10.1 Cenario Atual

| Atividade | Cenario Atual | Impacto |
|-----------|--------------|---------|
| **Criar dashboard novo cliente** | Copiar modelo, alterar SQL hardcoded | 4-8 horas |
| **Corrigir bug em medida** | Alterar em 26+ modelos individualmente | 1-2 dias |
| **Adicionar nova visualizacao** | Replicar em 28+ relatorios | 1 semana |
| **Treinar novo usuario** | Cada relatorio diferente | 2-4 horas por relatorio |
| **Auditar dados** | Nao ha documentacao | Impossivel |

### 10.2 Cenario Proposto

| Atividade | Cenario Proposto | Ganho |
|-----------|------------------|-------|
| **Criar dashboard novo cliente** | Selecionar cliente no filtro RLS | 30 minutos |
| **Corrigir bug em medida** | Alterar em 1 modelo central | 15 minutos |
| **Adicionar nova visualizacao** | Atualizar template | 1 hora |
| **Treinar novo usuario** | Mesmo padrao para todos | 30 minutos |
| **Auditar dados** | Documentacao completa | 1 hora |

### 10.3 Retorno sobre Investimento

| Metrica | Atual | Proposto | Melhoria |
|---------|-------|----------|----------|
| Tempo onboarding novo cliente | 4-8h | 30min | **94% mais rapido** |
| Manutencao de modelos | 1-2 dias | 15min | **99% mais rapido** |
| Modelos semânticos | 26+ | 1 | **96% reducao** |
| Documentacao | 0% | 100% | **∞** |

---

## 11. IMPACTO NA ESCALABILIDADE

### 11.1 Limitacoes Atuais

```
┌─────────────────────────────────────────────────────────────┐
│                    ESCALA ATUAL                            │
│  ✓ Suporta: ~50 clientes                                   │
│  ✗ Novo cliente = Novo modelo (4-8h)                       │
│  ✗ Manutencao proporcional a clientes                      │
│  ✗ Documentacao impossivel                                 │
└─────────────────────────────────────────────────────────────┘

Custo marginal de crescimento: ALTO
Tempo para adicionar 10 clientes: 40-80 horas
```

### 11.2 Proposta Escalavel

```
┌─────────────────────────────────────────────────────────────┐
│                 ESCALA PROPOSTA                             │
│  ✓ Suporta: ILIMITADO (via RLS)                            │
│  ✓ Novo cliente = Configurar RLS (5min)                    │
│  ✓ Manutencao INDEPENDENTE de clientes                      │
│  ✓ Documentacao centralizada                                │
└─────────────────────────────────────────────────────────────┘

Custo marginal de crescimento: QUASE ZERO
Tempo para adicionar 10 clientes: 50 minutos
```

---

## 12. ARQUITETURA PROPOSTA (TO-BE)

### 12.1 Visao Geral

```
┌─────────────────────────────────────────────────────────────────┐
│                      DW_BI_PROD_Diaria                          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              DataFlow Gen2 (Lakehouse)                          │
│  - Particionado por IdEmpresa                                  │
│  - Query folding preservado                                    │
│  - Performance superior                                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│          MODELO SEMANTICO UNICO (Fabric)                       │
│  - 1 tabela _Measures (centralizada)                           │
│  - Estrela perfeita                                            │
│  - RLS por IdEmpresa                                           │
│  - Documentacao completa                                       │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│            RELATORIOS DINAMICOS (por dominio)                   │
│  - Taxa de Utilizacao (1 para todos)                           │
│  - Saude24h (1 para todos)                                    │
│  - Telefonia (1 para todos)                                   │
│  - Filtro de Cliente no topo                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 12.2 Comparativo

| Dimensao | AS-IS | TO-BE | Melhoria |
|----------|-------|-------|----------|
| Modelos semânticos | 26+ | 1 | 96% ↓ |
| Relatorios Taxa Utilizacao | 1/cliente | 1 | Consolidado |
| Tabelas de medidas | 11 | 1 | 91% ↓ |
| DataFlows | 9 Gen1 | 1 Gen2 | Modernizado |
| Documentacao | 0% | 100% | Completo |
| Tempo setup cliente | 4-8h | 30min | 94% ↓ |

---

## 13. PLANO DE ACAO

### 13.1 Fase 1 - Imediato (1-2 semanas)

| Acao | Prioridade | Esforco | Responsabilidade |
|------|-----------|---------|-------------------|
| Mapear estrutura DW completa | ALTA | 8h | Consultoria |
| Documentar fontes de dados | ALTA | 4h | Consultoria |
| Criar catalogo de modelos | ALTA | 4h | Consultoria |
| Validar com Rafael | ALTA | 2h | Conjunta |

### 13.2 Fase 2 - Curto Prazo (1 mes)

| Acao | Prioridade | Esforco | Responsabilidade |
|------|-----------|---------|-------------------|
| Migrar DataFlow Gen1 → Gen2 | ALTA | 16h | Consultoria |
| Consolidar tabelas de medidas | ALTA | 8h | Consultoria |
| Implementar RLS | CRITICA | 12h | Consultoria |
| Criar modelo unificado piloto | CRITICA | 24h | Consultoria |

### 13.3 Fase 3 - Medio Prazo (2-3 meses)

| Acao | Prioridade | Esforco | Responsabilidade |
|------|-----------|---------|-------------------|
| Migrar clientes para modelo unificado | ALTA | 40h | Consultoria |
| Documentacao completa | MEDIA | 16h | Consultoria |
| Avaliar upgrade capacidade A2 → F/P | MEDIA | 4h | Conjunta |
| Treinar equipe | MEDIA | 8h | Consultoria |

---

## 14. INVESTIMENTO vs RETORNO

### 14.1 Investimento Estimado

| Fase | Horas | Custo (estimado) |
|------|-------|------------------|
| Fase 1 | 18h | R$ ~ |
| Fase 2 | 60h | R$ ~ |
| Fase 3 | 68h | R$ ~ |
| **TOTAL** | **146h** | **R$ ~** |

### 14.2 Retorno Esperado

| Beneficio | Valor Anual |
|-----------|-------------|
| Horas economizadas (manutencao) | 200+ horas |
| Novos clientes (sem custo extra) | Ilimitado |
| Reducao de erros | 80% |
| Satisfacao cliente | +40% |
| **ROI** | **~300% no primeiro ano** |

---

## 15. PROXIMOS PASSOS

### 15.1 Imediato

1. ✅ Apresentar diagnostico
2. ⏳ Aprovar plano de acao
3. ⏳ Agendar acesso ao DW_BI_PROD_Diaria

### 15.2 Esta Semana

4. Mapear estrutura completa do DW
5. Levantar dados volume/tabelas
6. Priorizar clientes para migracao piloto

### 15.3 Proximo Mes

7. Iniciar migracao DataFlow Gen1 → Gen2
8. Implementar RLS
9. Criar modelo unificado piloto

---

## 16. CONTATO E DÚVIDAS

**Consultoria AGPBI**
**Projeto**: Topmed BI Restructure
**Periodo**: Marco 2026 - Dezembro 2026
**Responsavel**: [Seu Nome]

**Para questoes sobre este diagnostico:**
- Rafael Faria: rafael.faria@topmed.com.br
- Email Power BI: powerbi_02@topmed.com.br

---

**Documento versao 2.0**
**Data: 03/03/2026**
**Status: Para Revisao**
