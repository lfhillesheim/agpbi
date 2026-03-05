# Topmed - Análise COMPLETA de Qualidade Power BI

**Data**: 03/03/2026
**Artefatos Analisados**: 3 PBIPs
**Escopo**: ETL + Power Query + DAX + Relacionamentos + Visuais + Design + Documentação

---

## Resumo Executivo

| Dimensão | Saúde24h Plus E+ | Taxa Utilizacao | Alô Floripa | Status Geral |
|----------|------------------|-----------------|-------------|--------------|
| **ETL / Power Query** | DataFlow Gen1 | DataFlow Gen1 | DataFlow Gen1 | 🔴 Legado |
| **Modelagem** | N/A (dataset compartilhado) | 10 tabelas | 36 tabelas | ⚠️ Aceitável |
| **DAX** | N/A | ✅ Bom | ✅ Bom | ✅ Bom |
| **Relacionamentos** | N/A | ⚠️ 1 inativo | ⚠️ 4 inativos | ⚠️ Alerta |
| **Visuais / UX** | 19 páginas | 1 página | 22 páginas | ⚠️ Complexo |
| **Design** | ✅ Tema customizado | ❌ Sem tema | ✅ Tema customizado | ⚠️ Inconsistente |
| **Documentação** | ❌ Ausente | ❌ Ausente | ❌ Ausente | 🔴 Crítico |

**Status Geral**: 🟡 AMARELO - Vários problemas críticos mas funcionando

---

## 1. ETL / POWER QUERY (M)

### 1.1 Fontes de Dados

| Dashboard | Fonte | Tipo | Problema |
|-----------|-------|------|----------|
| Taxa Utilizacao | DataFlow (Clientes Diário) | Gen1 | Legado |
| Alô Floripa | DataFlow (Clientes Diário) | Gen1 | Legado |
| Saúde24h Plus E+ | Dataset compartilhado | Gen1 | Legado |

### 1.2 Problemas Críticos Identificados

| ID | Problema | Localização | Severidade |
|----|----------|-------------|------------|
| **ETL-001** | **SQL hardcoded no Power Query** | Alô Floripa: `IdEmpresa = 151 OR 726` | 🔴 CRÍTICO |
| **ETL-002** | Data hardcoded no calendário | `#date(2023, 06, 01)` | 🟡 ALTA |
| **ETL-003** | DataFlow Gen1 (legado) | Todos | 🟡 ALTA |
| **ETL-004** | Query folding não aplicável | DataFlow | 🟡 MÉDIA |

**ETL-001 Explicação**:
```m
// PROBLEMA: Filtro hardcoded impossibilita reutilização
#"Filtro Empresa" = Table.SelectRows(
    Ft_AcoAtendimentoHistorico1,
    each ([IdEmpresa] = 151 or [IdEmpresa] = 726)
)
```
**Impacto**: Cada cliente precisa de um modelo separado. Explicação da explosão de relatórios "Taxa Utilização - [Município]".

### 1.3 Qualidade do Código M

| Aspecto | Status | Observação |
|---------|--------|------------|
| **Nomes de passos** | ✅ BOM | Descritivos em português |
| **Comentários** | ✅ BOM | Bem documentado |
| **Boas práticas** | ⚠️ REGULAR | Hardcoded values |
| **Query Folding** | ❌ N/A | DataFlow não folding |

---

## 2. MODELAGEM DE DADOS

### 2.1 Taxa Utilizacao (10 tabelas)

```
┌─────────────────────────────────────────────────────────┐
│                    MODELO: 10 Tabelas                    │
├─────────────────────────────────────────────────────────┤
│ DIMENSÕES (5)                                           │
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

### 2.2 Alô Saúde Floripa (36 tabelas)

```
┌─────────────────────────────────────────────────────────────┐
│                  MODELO: 36 Tabelas                         │
├─────────────────────────────────────────────────────────────┤
│ DIMENSÕES (4)                                               │
│  Dm_Calendario, Dm_Produto, Dm_SubEmpresa, Dm_TipoData...  │
├─────────────────────────────────────────────────────────────┤
│ FATOS (13)                                                  │
│  Ft_AcoAtendimentoHistorico, Ft_AcoAtendimentoQuestionário  │
│  Ft_AvaliacaoNpsQrCode, Ft_BeneficiarioHistoricoProduto     │
│  Ft_ConAgendamento, Ft_ConFilaProntoAtendimento            │
│  Ft_ConfirmacaoExames, Ft_ConIndicadores, etc.             │
├─────────────────────────────────────────────────────────────┤
│ FATOS HISTÓRICOS (4) *_HISTORICO                            │
├─────────────────────────────────────────────────────────────┤
│ MEDIDAS (11 tabelas fragmentadas)                          │
│  MedidasReceptivos, MedidasBeneficiarios, MedidasTelefonia  │
│  MedidasFaturamentoPMF, MedidasFila, MedidasTeleconsulta    │
│  MedidasIndicadores, MedidasNpsQrCode, etc.                │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Star Schema Compliance

| Critério | Taxa Utilizacao | Alô Floripa |
|----------|-----------------|-------------|
| Fatos separados de dimensões | ✅ | ⚠️ Misto |
| One-to-many | ✅ | ✅ |
| Single direction | ⚠️ 1 inativo | ⚠️ 4 inativos |
| Tabela data única | ✅ | ✅ |
| Chaves ocultas | ❌ IdEmpresa visível | ❌ Chaves visíveis |
| Snowflake | ❌ Não | ⚠️ Simdetectado |

---

## 3. DAX

### 3.1 Qualidade do Código DAX

| Aspecto | Status | Observação |
|---------|--------|------------|
| **Uso de VAR** | ✅ EXCELENTE | Todas as medidas usam VAR/RETURN |
| **DIVIDE()** | ✅ EXCELENTE | Usa DIVIDE() em vez de / |
| **Formatação** | ✅ BOM | Format strings definidos |
| **Nomes descritivos** | ⚠️ REGULAR | "Ativos (medida antiga)" = débito |
| **Organização** | ⚠️ FRAGMENTADO | 11 tabelas de medidas (Alô Floripa) |
| **Documentação** | 🔴 CRÍTICO | Sem descrições nas medidas |

### 3.2 Exemplo de DAX BOM

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

### 3.3 Problemas DAX Identificados

| ID | Problema | Localização | Severidade |
|----|----------|-------------|------------|
| **DAX-001** | Coluna calculada em dimensão dependendo de fato | Dm_Calendario: MaiorDataCadastroInicial | 🟡 ALTA |
| **DAX-002** | Medida "Ativos (medida antiga)" não removida | Taxa Utilizacao | 🟡 MÉDIA |
| **DAX-003** | Tabela _Measures ausente | Ambos | 🟡 ALTA |
| **DAX-004** | +0 no final (workaround) | Várias medidas | 🟢 BAIXA |

---

## 4. RELACIONAMENTOS

### 4.1 Taxa Utilizacao (6 relacionamentos)

| De | Para | Tipo | Direção | Status |
|-----|------|------|---------|--------|
| Ft_BeneficiarioHistoricoProduto.IdEmpresa | Dm_Empresa.IdEmpresa | Many-to-One | Single | ✅ |
| Ft_ConAgendamento.IdEmpresa | Dm_Empresa.IdEmpresa | Many-to-One | Single | ✅ |
| Ft_ConAgendamento.DataAgendamento | Dm_Calendario.Data | Many-to-One | **Inactive** | ⚠️ |
| Ft_BeneficiarioHistoricoProduto.IdSubEmpresa | Dm_SubEmpresa.IdSubEmpresa | Many-to-One | Single | ✅ |
| Ft_ConAgendamento.IdSubEmpresa | Dm_SubEmpresa.IdSubEmpresa | Many-to-One | Single | ✅ |
| Ft_ConAgendamento.Empresa | Dm_EmpresaURL.Empresa | Many-to-One | Single | ✅ |

### 4.2 Alô Saúde Floripa (28 relacionamentos)

- 24 ativos
- 4 inativos
- Todos single-direction ✅
- Auto-detected: 2 ⚠️

### 4.3 Problemas de Relacionamento

| ID | Problema | Impacto |
|----|----------|---------|
| **REL-001** | Relacionamento DataAgendamento inativo | Confusão de filtro |
| **REL-002** | AutoDetected relationships | Não documentado |
| **REL-003** | Múltiplos caminhos possíveis | Ambiguidade |

---

## 5. VISUAIS E UX

### 5.1 Estrutura de Páginas

| Dashboard | Páginas | Primeira Página | Tema |
|-----------|--------|-----------------|------|
| **Saúde24h Plus E+** | 19 páginas | "Sumário" | TOPMED882830 (custom) |
| **Taxa Utilizacao** | 1 página | "Página 1" | CY25SU12 (base) |
| **Alô Saúde Floripa** | 22 páginas | "Sumário" | CY21SU07 (base) |

### 5.2 Tipos de Visuais Detectados

| Tipo | Uso | Status |
|------|-----|--------|
| **Slicer (Dropdown)** | Filtros de período/subempresa | ✅ BOM |
| **Card** | KPIs principais | ✅ BOM |
| **Textbox** | Títulos e cabeçalhos | ✅ BOM |
| **Custom Visual** | simpleImage | ⚠️ Dep. de terceiros |

### 5.3 Problemas Visuais Identificados

| ID | Problema | Dashboard | Severidade |
|----|----------|-----------|------------|
| **VIS-001** | 19-22 páginas por dashboard | Todos | 🟡 ALTA |
| **VIS-002** | Tamanhos hardcoded (720x1280) | Todos | 🟡 MÉDIA |
| **VIS-003** | Background images como wallpapers | Alô Floripa, Saúde24h | 🟡 MÉDIA |
| **VIS-004** | Sem bookmark navigation detectado | Todos | 🟡 BAIXA |
| **VIS-005** | Slow data source settings habilitados | Alô Floripa, Saúde24h | 🟡 MÉDIA |

### 5.4 Background Images - Análise

**Saúde24h Plus E+**: 13 imagens de background!
- `Background-Teleconsulta.png`
- `Background_produtos_TOPMED*.png` (10 variações!)
- Vários ícones e botões

**Alô Saúde Floripa**: 11 imagens de background
- `Background_Home.png`
- `Background_Páginas_Nominais*.png` (4 variações)
- `Background_Páginas_Telefonia*.png` (6 variações)

**Problema**: Background images hardcoded impossibilitam responsividade e manutenção.

### 5.5 Configurações de Filtros

**Saúde24h Plus E+**:
```
1. Dm_Calendario.Data >= 2023-12-01 (hardcoded!)
2. Dm_Calendario.FlagMesAtual = false
3. Dm_SubEmpresa.IdEmpresa = 718 (hardcoded!)
4. Dm_Calendario.MaiorDataCadastroInicial = 'Sim'
```

**Problema**: Filtros hardcoded no nível de relatório!

---

## 6. DESIGN E TEMA

### 6.1 Temas

| Dashboard | Tema Base | Tema Custom | Status |
|-----------|-----------|------------|--------|
| Saúde24h Plus E+ | CY20SU09 | TOPMED882830.json | ✅ Customizado |
| Taxa Utilizacao | CY25SU12 | - | ❌ Base apenas |
| Alô Saúde Floripa | CY21SU07 | - | ❌ Base apenas |

### 6.2 Cores Detectadas

| Cor | Hex | Uso |
|-----|-----|-----|
| Azul principal | #24516D | Títulos, cabeçalhos |
| Azul claro | #CBD8DE | Fundo de slicers |
| Branco | #FFFFFF | Fundos |

### 6.3 Problemas de Design

| ID | Problema | Impacto |
|----|----------|---------|
| **DES-001** | Temas inconsistentes entre dashboards | Marca fraca |
| **DES-002** | Cores hardcoded em visuais | Manutenção difícil |
| **DES-003** | Font sizes hardcoded (32px, etc.) | Responsividade ruim |

---

## 7. DOCUMENTAÇÃO

### 7.1 Status Atual: 🔴 CRÍTICO

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

### 7.2 Exemplo de Falta de Documentação

```dax
// SEM DESCRIÇÃO - O que essa medida faz?
'% Prescrição de Medicamentos' = ...
```

```dax
// POR QUE existe essa medida?
'Ativos (medida antiga)' = ...
```

---

## 8. BOAS PRÁTICAS - CHECKLIST

### 8.1 Modelagem

| Prática | Status | Observação |
|---------|--------|------------|
| Star Schema | ⚠️ Parcial | Snowflake em Alô Floripa |
| Tabela _Measures | ❌ Ausente | Fragmentado em 11 tabelas |
| Chaves ocultas | ❌ Não implementado | IDs visíveis |
| Auto Date/Time desabilitado | ✅ Sim | ✅ |
| Tabela de Data explícita | ✅ Sim | Dm_Calendario |

### 8.2 DAX

| Prática | Status | Observação |
|---------|--------|------------|
| VAR/RETURN | ✅ Sim | Boas práticas |
| DIVIDE() | ✅ Sim | Evita divisão por zero |
| Medidas (não colunas calculadas) | ✅ Sim | Para agregações |
| Formatação definida | ✅ Sim | Format strings |
| Descrições | ❌ Não | Documentação ausente |

### 8.3 Power Query

| Prática | Status | Observação |
|---------|--------|------------|
| Nomes descritivos | ✅ Sim | Passos em português |
| Comentários | ✅ Sim | Bem documentado |
| Query folding | ❌ N/A | DataFlow |
| Parâmetros | ❌ Não | Hardcoded values |
| Schema稳妥 (Stable) | ⚠️ Parcial | Data hardcoded |

### 8.4 Visuais/UX

| Prática | Status | Observação |
|---------|--------|------------|
| Títulos descritivos | ✅ Sim | |
| Tooltips habilitados | ✅ Sim | useEnhancedTooltips |
| Bookmark navigation | ❌ Não | Detectado não usado |
| Botões/actions | ⚠️ Parcial | Imagens customizadas |
| Responsividade | ⚠️ Parcial | 720x1280 fixo |
| Drill habilitado | ✅ Sim | defaultDrillFilterOtherVisuals |

---

## 9. PROBLEMAS POR SEVERIDADE

### 🔴 CRÍTICOS (Ação Imediata)

| ID | Problema | Impacto | Solução |
|----|----------|---------|---------|
| **ETL-001** | SQL hardcoded no M | Impossível reutilizar | Mover para RLS |
| **DOC-001** | Documentação ZERO | Manutenção impossível | Criar dicionário |
| **VIS-001** | Filtros hardcoded no relatório | Dados incorretos | Usar parâmetros |

### 🟡 ALTOS (Curto Prazo)

| ID | Problema | Impacto | Solução |
|----|----------|---------|---------|
| **ETL-003** | DataFlow Gen1 legado | Performance/risco | Migrar Gen2 |
| **DAX-001** | Coluna calculada em dimensão | Quebra Star Schema | Mover para medida |
| **DAX-003** | Sem tabela _Measures | Fragmentação | Consolidar |
| **VIS-002** | 19-22 páginas por dashboard | UX complexa | Simplificar |
| **REL-001** | Relacionamentos inativos | Confusão | Remover/ativar |

### 🟢 MÉDIOS (Médio Prazo)

| ID | Problema | Impacto | Solução |
|----|----------|---------|---------|
| **DES-001** | Temas inconsistentes | Marca fraca | Padronizar |
| **ETL-002** | Data hardcoded | Manutenção | Parâmetros |
| **VIS-003** | Background images | Performance | CSS/tema |

---

## 10. QUICK WINS (Fácil Implementação)

| Win | Esforço | Impacto | Timeline |
|-----|---------|---------|----------|
| Adicionar descrições nas medidas | 1 hora | ALTO | Imediato |
| Remover "medida antiga" | 5 min | BAIXO | Imediato |
| Criar tabela _Measures única | 2 horas | ALTO | 1 semana |
| Documentar datasources | 1 hora | MÉDIO | 1 semana |
| Padronizar nomes de páginas | 1 hora | BAIXO | Imediato |

---

## 11. MATRIZ DE RISCOS

| Área | Risco | Probabilidade | Impacto | Mitigação |
|------|-------|---------------|---------|-----------|
| **ETL** | DataFlow Gen1 descontinuado | ALTA | ALTO | Migrar Gen2 |
| **Modelo** | Explosão de modelos por cliente | ALTA | ALTO | Implementar RLS |
| **DAX** | Débito técnico acumulado | MÉDIA | MÉDIO | Refatoração |
| **Visuais** | Performance com backgrounds | MÉDIA | MÉDIO | Remover imagens |
| **Doc** | Perda de conhecimento | ALTA | ALTO | Documentar |

---

## 12. ARQUITETURA TO-BE SUGERIDA

### 12.1 Modelo Unificado

```
┌─────────────────────────────────────────────────────────────┐
│                  DW_BI_PROD_Diaria (SQL)                   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   DataFlow Gen2 (Lakehouse)                │
│  - ÚNICO para todos os clientes                            │
│  - Partitioned by IdEmpresa                                │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              MODELO SEMÂNTICO ÚNICO (Fabric)                │
│  - Tabela _Measures (centralizada)                         │
│  - Estrela perfeita                                        │
│  - RLS por IdEmpresa                                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│               RELATÓRIOS POR PÁGINA (dinâmicos)             │
│  - Filtro de Cliente no topo                               │
│  - 1 conjunto de visuais para todos                        │
└─────────────────────────────────────────────────────────────┘
```

### 12.2 Benefícios

| Antes (AS-IS) | Depois (TO-BE) |
|---------------|----------------|
| 26+ modelos semânticos | 1 modelo unificado |
| 28+ relatórios por cliente | 1 relatório dinâmico |
| SQL hardcoded no M | RLS dinâmico |
| 11 tabelas de medidas | 1 tabela _Measures |
| DataFlow Gen1 | DataFlow Gen2 |
| Sem documentação | Dicionário completo |

---

## 13. PRÓXIMOS PASSOS

### Imediato (Esta semana)

1. ✅ Análise completa realizada
2. ⏳ Apresentar diagnóstico para Rafael
3. ⏳ Priorizar quick wins

### Curto Prazo (2 semanas)

4. Criar documentação mínima
5. Consolidar tabelas de medidas
6. Propor piloto TO-BE

### Médio Prazo (1 mês)

7. Migrar DataFlow Gen1 → Gen2
8. Implementar RLS
9. Criar modelo unificado

---

## 14. MÉTRICAS DE QUALIDADE

| Métrica | AS-IS | TO-BE (Meta) |
|---------|-------|--------------|
| Modelos semânticos | 26+ | 1 |
| Relatórios | 28+ | 5-10 |
| Tabelas de medidas | 11 | 1 |
| Documentação | 0% | 100% |
| Hardcoded values | 10+ | 0 |
| Páginas por dashboard | 19-22 | 5-8 |
| Tempo de manutenção | Alta | Baixa |

---

**Status**: Análise COMPLETA concluída
**Próxima fase**: Apresentação + Priorização com Rafael
**Data**: 03/03/2026
