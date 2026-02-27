# Melhores Práticas AGPBI

> Guia de boas práticas para consultoria de dados com Power BI

## 📖 Índice

1. [Metodologia](#metodologia)
2. [Power BI](#power-bi)
3. [DAX](#dax)
4. [Power Query](#power-query)
5. [Documentação](#documentação)
6. [Comunicação](#comunicação)
7. [Git e Versionamento](#git-e-versionamento)
8. [Trabalho com IA](#trabalho-com-ia)

---

## Metodologia

### ✅ Sempre Faça

1. **Complete Vision antes de Validate**
   - Todos os 5 documentos são obrigatórios
   - Escopo DEVE ser aprovado
   - Stakeholders engajados

2. **Valide antes de Construir**
   - Números batem com negócio
   - Wireframe aprovado
   - Viabilidade técnica confirmada

3. **Documente enquanto Constrói**
   - Não deixe para o final
   - Documentação é tão importante quanto código

4. **Teste antes de Entregar**
   - Todas as medidas validadas
   - Performance testada
   - Usabilidade testada

### ❌ Nunca Faça

1. **Pule fases**
   - Vision → Validate → Build é sagrado
   - Gates existem por um motivo

2. **Assuma em vez de Validar**
   - "Os dados devem estar corretos" = perigo
   - Valide tudo com negócio

3. **Deixe para Documentar Depois**
   - Documentação tardia = documentação inexistente
   - Faça junto com implementação

4. **Entregue sem Sign-off**
   - Cliente precisa aprovar formalmente
   - Email de aceite é suficiente

---

## Power BI

### Modelagem

#### Star Schema

**✅ DO**:
- Fat tables: apenas medidas (números)
- Dimension tables: apenas atributos (descrições)
- Relacionamentos: 1:* de dimensão para fato
- Cross-filter: single direction (padrão)

**❌ DON'T**:
- Fat tables com texto descritivo
- Dimension tables com medidas
- Múltiplas fat tables diretamente conectadas
- Bi-directional filters sem motivo forte

#### Exemplo

```dax
// ✅ CORRETO - Star Schema
Vendas (Fato)
- VendaID (PK)
- DataID (FK)
- ClienteID (FK)
- ProdutoID (FK)
- Quantidade (medida)
- ValorTotal (medida)

Clientes (Dimensão)
- ClienteID (PK)
- NomeCliente
- Cidade
- Segmento

Relacionamento: Clientes.ClienteID → Vendas.ClienteID
Cardinalidade: 1:* (one to many)
Cross-filter: Single (Clientes filtram Vendas)
```

### Relacionamentos

#### Cardinalidade

**Padrão**: One-to-many (1:*)
- One side: Dimension (único)
- Many side: Fact (múltiplos)

**Exceções** (raras):
- One-to-one (1:1): Perfil único
- Many-to-many (*:*: Precisa de bridge table

#### Cross-Filter Direction

**✅ Single Direction** (padrão):
- Dimension filtra Fact
- Performance melhor
- Ambiguidade menor

**⚠️ Bi-Directional** (exceção):
- Use apenas quando necessário
- Documente POR QUÊ
- Esteja ciente de impactos na performance

### Colunas

#### Visibilidade

**✅ Esconda** (isHidden: true):
- Chaves primárias (ID)
- Chaves estrangeiras (FK)
- Colunas técnicas
- Colunas usadas apenas em relacionamentos

**✅ Mostre**:
- Nomes descritivos
- Atributos de negócio
- Colunas usadas em visuais

#### Tipos de Dados

**Regra**:
- Use o tipo mais específico possível
- Whole number para inteiros
- Decimal para números com casas decimais
- Text para strings
- Date para datas
- True/False para booleanos

---

## DAX

### Medidas vs Colunas Calculadas

#### ✅ USE Medidas para

- Agregações (SUM, AVG, COUNT, etc)
- Cálculos que mudam por contexto
- KPIs e métricas de negócio
- Time intelligence (YTD, MTD, etc)

#### ❌ NÃO USE Colunas Calculadas para

- Agregações que poderiam ser medidas
- Coisas que mudam por contexto
- Coisas complexas

#### Exemplo

```dax
// ✅ CORRETO - Medida para agregação
Total Vendas = SUM(Vendas[ValorTotal])

// ❌ ERRADO - Coluna calculada para agregação
// Não faça: coluna calculada na tabela Vendas
// TotalVendas = Vendas[Quantidade] * Vendas[ValorUnitario]

// ✅ CORRETO - Use medida
Total Vendas =
SUMX(
    Vendas,
    Vendas[Quantidade] * Vendas[ValorUnitario]
)
```

### Padrões DAX

#### Variáveis para Clareza

```dax
// ✅ BOM - Com variáveis (legível, performático)
YTD Sales =
VAR CurrentDate = MAX('Date'[Date])
VAR YearStart = DATE(YEAR(CurrentDate), 1, 1)
RETURN
    CALCULATE(
        [Total Sales],
        DATESBETWEEN('Date'[Date], YearStart, CurrentDate)
    )

// ⚠️ ACEITÁVEL - Sem variáveis (menos legível)
YTD Sales =
CALCULATE(
    [Total Sales],
    DATESYTD('Date'[Date])
)
```

#### Error Handling

```dax
// ✅ BOM - Com DIVIDE (trata divisão por zero)
Markup % =
DIVIDE(
    [Profit],
    [Cost],
    BLANK()  // Retorna blank se divisor for 0
)

// ❌ RUIM - Sem tratamento (erro se divisor for 0)
Markup % = [Profit] / [Cost]
```

#### Formatação

**Regra**: TODA medida deve ter format string

```dax
// ✅ CORRETO - Com formatação
Total Vendas = SUM(Vendas[ValorTotal])
// Format String: R$ #,##0.00

// ❌ ERRADO - Sem formatação
Total Vendas = SUM(Vendas[ValorTotal])
// Format String: (vazio)
```

### Comentários DAX

```dax
// AIDEV-NOTE: performance-critical - avoid iterators on large fact table
// AIDEV-ANSWER: Business rule: only active customers (LastSaleDate within 365 days)
Total Vendas Ativas =
VAR LastSaleDate = MAX(Vendas[DataVenda])
VAR OneYearAgo = TODAY() - 365
RETURN
    CALCULATE(
        [Total Vendas],
        Vendas[DataVenda] >= OneYearAgo
    )
```

---

## Power Query

### Query Folding

**O que é**: Power Query "dobrando" consultas para SQL nativo

**✅ Faça**:
- Use funções nativas do Power Query
- Evite funções que impedem folding
- Teste com "Native Query" preview

**❌ Evite**:
- Text.From() (impede folding)
- List.Transform() (pode impedir)
- Funções custom complexas

### Estrutura

```powerquery
// ✅ BOM - Passos descritivos
let
    Source = Sql.Database("server", "database"),
    dbo_Vendas = Source{[Schema="dbo",Item="Vendas"]}[Data],
    FiltrarVendasAtivas = Table.SelectRows(dbo_Vendas, each [Status] = "Ativo"),
    TiposCorrigidos = Table.TransformColumnTypes(FiltrarVendasAtivas, {...}),
    ColunasSelecionadas = Table.SelectColumns(TiposCorrigidos, {...})
in
    ColunasSelecionadas

// ❌ RUIM - Passos genéricos
let
    Source = Sql.Database("server", "database"),
    Step1 = Source{[Schema="dbo",Item="Vendas"]}[Data],
    Step2 = Table.SelectRows(Step1, each [Status] = "Ativo"),
    Step3 = Table.TransformColumnTypes(Step2, {...}),
    Step4 = Table.SelectColumns(Step3, {...})
in
    Step4
```

---

## Documentação

### Tabelas

```markdown
## Tabela: Vendas

### Descrição
Contém todas as transações de vendas da empresa.

### Granularidade
Uma linha por transação de venda.

### Volume
~5 milhões de linhas
~2 GB em disco

### Colunas Principais
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| VendaID | Int | Identificador único da venda |
| DataID | Int | FK para dimensão Data |
| ClienteID | Int | FK para dimensão Cliente |
| ValorTotal | Decimal | Valor total da venda |
```

### Medidas

```dax
// Total Vendas: Soma de todas as vendas
// Usada em: Visuais de resumo de vendas
Total Vendas = SUM(Vendas[ValorTotal])

// Formato: R$ #,##0.00
```

### Relacionamentos

```markdown
## Relacionamento: Clientes → Vendas

- **De**: Clientes.ClienteID
- **Para**: Vendas.ClienteID
- **Cardinalidade**: One-to-many (1:*)
- **Cross-filter**: Single direction
- **Ativo**: Sim
- **Descrição**: Um cliente pode ter muitas vendas. Cada venda pertence a um único cliente.
```

---

## Comunicação

### Com Clientes

**✅ DO**:
- Seja proativo na comunicação
- Use linguagem de negócio, não técnica
- Documente todas as interações
- Defina expectativas claras

**❌ DON'T**:
- Deixe para último momento
- Use jargão técnico sem explicar
- Assuma que o cliente entende
- Mude escopo sem aprovação formal

### Status Updates

**Frequência**:
- Semanal com time interno
- Quinzenal com cliente
- Ad-hoc quando crítico

**Formato**:
```markdown
# Status Update - Semana X

## O que foi feito
- Item 1
- Item 2

## O que está em andamento
- Item 1 (responsável, prazo)

## O que vem a seguir
- Item 1
- Item 2

## Bloqueadores
- Bloqueador 1 (impacto, ação necessária)
```

---

## Git e Versionamento

### Branch Strategy

```
main (produção)
  ↓
vision/[feature]
  ↓
validate/[feature]
  ↓
build/[feature]
```

### Commit Messages

```bash
# ✅ BOM
git commit -m "vision: mapear stakeholders do cliente [AI]

Mapeado todos os stakeholders com papéis e responsabilidades.

AI-assisted: Estrutura gerada pela IA, conteúdo validado por humano."

# ❌ RUIM
git commit -m "atualizações"
```

### .gitignore

```
# Power BI
*.pbip/
*.pbit
*.bim

# Arquivos temporários
~$*
*.tmp

# Logs
*.log

# OS
.DS_Store
Thumbs.db
```

---

## Trabalho com IA

### O que IA FAZ BEM

- Gerar código boilerplate
- Sugerir melhorias
- Explicar conceitos
- Revisar código
- Documentar código
- Encontrar padrões

### O que IA NÃO FAZ BEM

- Entender contexto específico do cliente
- Validar números com negócio
- Tomar decisões de escopo
- Entender política da empresa
- Lidar com ambiguidade de negócio

### Melhores Práticas

#### 1. Seja Específico

```bash
# ❌ VAGO
"Adicione uma medida de vendas"

# ✅ ESPECÍFICO
"Crie uma medida de Total Vendas que soma a coluna Vendas[ValorTotal],
formate como moeda (R$), e adicione descrição: 'Soma de todas as vendas'"
```

#### 2. Dê Contexto

```bash
# ❌ SEM CONTEXTO
"Conecte no ERP"

# ✅ COM CONTEXTO
"Conecte no ERP SAP usando o conector SAP BW,
schema ZVENDAS, autenticação SSO,
e liste as tabelas disponíveis"
```

#### 3. Verifique Sempre

```bash
# ❌ CONFIAR CEGO
"IA disse que está pronto, então entrego"

# ✅ VERIFICAR
"IA gerou o código, vou:
1. Testar localmente
2. Validar com negócio
3. Revisar qualidade
4. Documentar
5. Entregar"
```

### Prompt Engineering

#### Padrões Úteis

**Explique**:
```
"Explique como funciona [conceito] no contexto de [situação específica]"
```

**Compare**:
```
"Compare [abordagem A] vs [abordagem B] para [caso de uso].
Liste prós, contras e recomende."
```

**Critique**:
```
"Revise este código DAX e aponte:
1. Problemas de performance
2. Anti-padrões
3. Sugestões de melhoria"
```

---

## Próximos Passos

1. **Practice**: Aplique essas práticas no próximo projeto
2. **Share**: Ensine a equipe
3. **Improve**: Contribua com novas práticas

**Leia também**:
- [CLAUDE.md](../CLAUDE.md)
- [Metodologia](metodologia.md)
- [Guia de Início Rápido](guia-inicio-rapido.md)
