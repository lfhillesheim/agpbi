# Topmed - Análise de Qualidade dos Modelos Semânticos

**Data**: 03/03/2026
**Artefatos Analisados**: 3 PBIPs
**Fase**: Discovery AS-IS - Análise Técnica

---

## 1. Modelos Analisados

| Modelo | Tabelas | Relações | Tipo |
|--------|---------|----------|------|
| **Taxa Utilizacao** | 10 | 6 (1 inativo) | Dataset completo |
| **Alô Saúde Floripa - PMF** | 36 | 28 (4 inativos) | Dataset completo |
| **Saúde24h Plus E+** | - | - | Report only (dataset compartilhado) |

---

## 2. Taxa Utilizacao - Conjunto de Dados

### 2.1 Estrutura

```
┌─────────────────────────────────────────────────────────┐
│                    MODELO: 10 Tabelas                    │
├─────────────────────────────────────────────────────────┤
│ DIMENSÕES (4)                                           │
│  Dm_Calendario          Tabela de data                  │
│  Dm_Empresa             Empresas                         │
│  Dm_SubEmpresa          Sub-empresas                     │
│  Dm_Profissional        Profissionais de saúde           │
│  Dm_EmpresaURL          URLs                             │
├─────────────────────────────────────────────────────────┤
│ FATOS (2)                                               │
│  Ft_BeneficiarioHistoricoProduto  Histórico beneficiários│
│  Ft_ConAgendamento               Agendamentos            │
├─────────────────────────────────────────────────────────┤
│ MEDIDAS (2)                                             │
│  MedidasBeneficiarios   KPIs beneficiários               │
│  MedidasTeleConsulta    KPIs teleconsulta                │
├─────────────────────────────────────────────────────────┤
│ AUXILIAR (1)                                            │
│  Aux_Notas              Notas/texto                      │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Qualidade DAX

| Aspecto | Status | Observação |
|---------|--------|------------|
| **Uso de VAR** | ✅ BOM | Todas as medidas usam VAR/RETURN |
| **DIVIDE()** | ✅ BOM | Usa DIVIDE() em vez de / |
| **Formatação** | ✅ BOM | formatString definido |
| **Documentação** | ❌ RUIM | Medidas sem descrição |
| **Nomes descritivos** | ⚠️ REGULAR | "Ativos (medida antiga)" indica débito técnico |

### 2.3 Problemas Identificados

| ID | Problema | Severidade |
|----|----------|------------|
| **M001** | Coluna calculada em Dm_Calendario com MIN() sobre tabela fato | ALTA |
| **M002** | Medida "Ativos (medida antiga)" não foi removida | MÉDIA |
| **M003** | Relacionamento DataAgendamento → Data INATIVO | MÉDIA |
| **M004** | Auto Date/Time desabilitado (✅ corrigido) | - |

**Detalhe M001**:
```dax
// PROBLEMA: Coluna calculada em tabela dimensão
// dependendo de tabela fato - quebra Star Schema
MaiorDataCadastroInicial = IF(
    Dm_Calendario[Data]>= MIN(Ft_BeneficiarioHistoricoProduto[PrDataAtivacao]),
    "Sim", "Não"
)
```

### 2.4 Power Query (M)

| Aspecto | Status | Observação |
|---------|--------|------------|
| **Fonte** | DataFlow Gen1 | Legado |
| **Query Folding** | ❌ N/A | Fonte não é SQL direto |
| **Nomes de passos** | ✅ BOM | Descritivos em português |
| **Comentários** | ✅ BOM | Bem comentado |
| **Hardcoded** | ❌ RUIM | Data hardcoded: `#date(2023, 06, 01)` |

---

## 3. Alô Saúde Floripa - PMF

### 3.1 Estrutura

```
┌─────────────────────────────────────────────────────────────┐
│                  MODELO: 36 Tabelas                         │
├─────────────────────────────────────────────────────────────┤
│ DIMENSÕES (4)                                               │
│  Dm_Calendario          Tabela de data                      │
│  Dm_Produto             Produtos Topmed                     │
│  Dm_SubEmpresa          Sub-empresas                        │
│  Dm_TipoDataConfirmacaoExames  Tipos de data               │
├─────────────────────────────────────────────────────────────┤
│ FATOS (13)                                                  │
│  Ft_AcoAtendimentoHistorico        Atendimentos             │
│  Ft_AcoAtendimentoQuestionario     Questionários            │
│  Ft_AcoAtendimentoQuestionario-MAR_JUL  Parcial histórico   │
│  Ft_AvaliacaoNpsQrCode              Avaliações NPS          │
│  Ft_BeneficiarioHistoricoProduto   Beneficiários            │
│  Ft_ConAgendamento                  Agendamentos             │
│  Ft_ConFilaProntoAtendimento       Filas de atendimento     │
│  Ft_ConfirmacaoExames               Confirmação exames       │
│  Ft_ConfirmacaoExamesEmColunas     Exames (pivotado)        │
│  Ft_ConIndicadores                  Indicadores              │
│  Ft_ConIndicadoresHipoteses         Hipóteses               │
│  Ft_IntencaoInicialDesfecho         Intenção vs desfecho     │
│  Ft_AtendimentosHistoricoDesfechoCovid  Covid específico    │
├─────────────────────────────────────────────────────────────┤
│ FATOS HISTÓRICOS (4)                                        │
│  Ft_Telefonia_HISTORICO              Telefonía              │
│  Ft_TelefoniaTMATME_HISTORICO        Telefonía TMATME       │
│  Ft_TelefoniaFaturamentoPMF_HISTORICO Faturamento PMF      │
│  Ft_PesquisaSatisfacao_HISTORICO     Pesquisa satisfação    │
├─────────────────────────────────────────────────────────────┤
│ FATOS TELEFONIA (1)                                         │
│  Ft_Telefonia                         Telefonía atual        │
├─────────────────────────────────────────────────────────────┤
│ MEDIDAS (9)                                                 │
│  MedidasReceptivos        KPIs receptivos                   │
│  MedidasBeneficiarios     KPIs beneficiários                │
│  MedidasTelefonia         KPIs telefonia                    │
│  MedidasFaturamentoPMF    KPIs faturamento                  │
│  MedidasFila              KPIs filas                         │
│  MedidasTeleconsulta      KPIs teleconsulta                 │
│  MedidasIndicadores       KPIs indicadores                  │
│  MedidasNpsQrCode         KPIs NPS                           │
│  MedidasConfirmacaoExames KPIs exames                       │
│  MedidasVisaoGeralAtendimentos Visão geral                 │
│  MedidasGerais            Medidas gerais                    │
├─────────────────────────────────────────────────────────────┤
│ OUTROS (1)                                                 │
│  Glossário                Tabela auxiliar                   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Qualidade DAX

| Aspecto | Status | Observação |
|---------|--------|------------|
| **Uso de VAR** | ✅ BOM | Boas práticas aplicadas |
| **DIVIDE()** | ✅ BOM | Usa DIVIDE() corretamente |
| **Formatação** | ✅ BOM | Format strings definidos |
| **Documentação** | ❌ RUIM | Sem descrições nas medidas |
| **Organização** | ✅ BOM | Tabelas de medidas especializadas |

**Exemplo de DAX bom**:
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

### 3.3 Power Query (M)

| Aspecto | Status | Observação |
|---------|--------|------------|
| **Fonte** | DataFlow Gen1 | Legado |
| **SQL Hardcoded** | 🔴 CRÍTICO | `IdEmpresa = 151 or [IdEmpresa] = 726` |
| **Query Folding** | ❌ N/A | DataFlow não folding |
| **Comentários** | ✅ BOM | Bem documentado |
| **Colunas calculadas** | ⚠️ MISTO | Algumas em M, outras em DAX |

**PROBLEMA CRÍTICO**:
```m
// SQL hardcoded em M - QUEBRA REUTILIZAÇÃO
#"Filtro Empresa" = Table.SelectRows(
    Ft_AcoAtendimentoHistorico1,
    each ([IdEmpresa] = 151 or [IdEmpresa] = 726)
)
```

### 3.4 Problemas Identificados

| ID | Problema | Severidade |
|----|----------|------------|
| **M005** | **SQL hardcoded no M** | CRÍTICA |
| **M006** | Tabelas *_HISTORICO duplicadas | ALTA |
| **M007** | 4 relacionamentos inativos | MÉDIA |
| **M008** | Ft_AcoAtendimentoQuestionario-MAR_JUL (parcial) | ALTA |
| **M009** | Coluna "Hora" calculada em DAX | MÉDIA |

**M005 Explicação**: O filtro de empresa hardcoded no Power Query significa:
- ❌ Não é possível reutilizar o modelo para outros clientes
- ❌ Cada cliente precisa de um modelo separado
- ❌ Manutenção em massa impossível

**Solução**: Remover o filtro do M e aplicar RLS (Row-Level Security)

---

## 4. Saúde24h Plus E+ - Prefeitura de Ascurra

### 4.1 Estrutura

```
┌─────────────────────────────────────────────────────────────┐
│                   REPORT ONLY                               │
│  Este dashboard NÃO possui modelo semântico próprio         │
│  Usa um dataset compartilhado (provavelmente Gen1)         │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Observações

- **Arquitetura**: Report ligado a dataset compartilhado
- **Implicação**: Mudanças no dataset afetam TODOS os relatórios conectados
- **Risco**: Se mudar algo para Ascurra, impacta outros clientes

---

## 5. Análise Cross-Modelo

### 5.1 Padrões de Nomenclatura

| Tipo | Padrão | Status |
|------|--------|--------|
| Tabelas Dimensão | `Dm_*` | ✅ Consistente |
| Tabelas Fato | `Ft_*` | ✅ Consistente |
| Tabelas Medidas | `Medidas*` | ✅ Consistente |
| Tabelas Auxiliares | `Aux_*` | ✅ Consistente |

### 5.2 Tabelas Compartilhadas

| Tabela | Usado em | Observação |
|--------|----------|------------|
| Dm_Calendario | Todos | Consistente |
| Ft_BeneficiarioHistoricoProduto | Ambos | Reutilização |
| Ft_ConAgendamento | Ambos | Reutilização |

### 5.3 Anti-Padrões Detectados

| Anti-Padrão | Ocorrências | Impacto |
|-------------|-------------|---------|
| **SQL Hardcoded** | 1+ | CRÍTICO |
| **Colunas DAX em dimensão** | 2+ | ALTO |
| **Tabelas *_HISTORICO** | 4 | MÉDIO |
| **Relacionamentos inativos** | 5 | BAIXO |

---

## 6. Star Schema Compliance

### 6.1 Taxa Utilizacao

| Critério | Status |
|----------|--------|
| Fatos separados de dimensões | ✅ |
| One-to-many | ✅ |
| Single direction | ⚠️ 1 inativo |
| Tabela data única | ✅ |
| Chaves ocultas | ❌ IdEmpresa visível |

### 6.2 Alô Saúde Floripa

| Critério | Status |
|----------|--------|
| Fatos separados de dimensões | ⚠️ Misto |
| One-to-many | ✅ |
| Single direction | ⚠️ 4 inativos |
| Tabela data única | ✅ |
| Snowflake detectado | ⚠️ Sim |

---

## 7. Performance Considerations

### 7.1 Modelo Completo

| Métrica | Taxa Utilizacao | Alô Floripa |
|---------|-----------------|-------------|
| Tabelas | 10 | 36 |
| Relacionamentos | 6 | 28 |
| Tabelas medidas | 2 | 11 |
| Colunas calculadas DAX | 2 | 1+ |
| Complexidade | BAIXA | ALTA |

### 7.2 Riscos de Performance

| Risco | Localização | Mitigação |
|-------|-------------|-----------|
| Coluna calculada em dimensão | Dm_Calendario (Taxa) | Mover para medida |
| Tabelas *_HISTORICO | Alô Floripa | Consolidar |
| Filtros hardcoded | M (Alô Floripa) | RLS |

---

## 8. Gaps de Documentação

| Item | Status |
|------|--------|
| Descrição de tabelas | ❌ Ausente |
| Descrição de medidas | ❌ Ausente |
| Descrição de colunas | ❌ Ausente |
| Data lineage | ❌ Ausente |
| Dicionário de dados | ❌ Ausente |

---

## 9. Recomendações por Prioridade

### URGENTE (Crítico)

1. **M005: Remover SQL hardcoded do Power Query**
   - Implementar RLS no lugar
   - Viabiliza reutilização entre clientes

### ALTA PRIORIDADE

2. **M001: Mover coluna calculada de Dm_Calendario para medida**
   - Corrige violação de Star Schema

3. **M006: Consolidar tabelas *_HISTORICO**
   - Padronizar estratégia de historização

4. **Documentação completa do modelo**
   - Descrições em tabelas, colunas e medidas

### MÉDIA PRIORIDADE

5. **Limpar relacionamentos inativos**
   - Remover ou documentar por que existem

6. **Padronizar estratégia de DataFlow**
   - Avaliar migração Gen1 → Gen2

7. **Criar tabela _Measures única**
   - Alô Floripa tem 11 tabelas de medidas (fragmentado)

---

## 10. Quick Wins Identificados

| Win | Esforço | Impacto |
|-----|---------|---------|
| Adicionar descrições nas medidas | BAIXO | ALTO |
| Remover "medida antiga" | BAIXO | MÉDIO |
| Consolidar tabelas medidas | MÉDIO | ALTO |
| Migrar RLS para M→DAX | MÉDIO | CRÍTICO |

---

## 11. Próximos Passos

### Imediato

1. ✅ Análise de modelos completa
2. ⏳ Acesso ao banco DW_BI_PROD_Diaria
3. ⏳ Mapear estrutura das tabelas SQL

### Curto Prazo

- Criar documento de dicionário de dados
- Propor modelo TO-BE unificado
- Validar com Rafael Faria

---

**Status**: Análise técnica AS-IS concluída
**Próxima fase**: Acesso ao banco + proposta TO-BE
**Data**: 03/03/2026
