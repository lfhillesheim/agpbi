# Power BI Embedded + RLS
## Multi-tenancy para Escala na Topmed

**Data**: Março de 2026
**Contexto**: Análise de arquitetura Embedded Topmed
**Status**: Recomendação Técnica

---

## Resumo Executivo

**PERGUNTA**: "É possível fazer um painel por cliente com RLS ao invés de várias cópias do mesmo?"

**RESPOSTA**: **SIM!** E é a arquitetura RECOMENDADA para ambientes Embedded multi-tenant.

A Topmed hoje usa o modelo "anti-pattern" (1 relatório por cliente), resultando em **1.543 relatórios** para ~73 modelos semânticos. A migração para RLS com Effective Identity API permite:

- De 192 relatórios "Taxa Utilização" → **1 relatório dinâmico**
- De 201 relatórios "Lista Beneficiários" → **1 relatório dinâmico**
- Manutenção: 1 alteração reflete para todos os clientes
- Escalabilidade: Novo cliente = configuração, não novo relatório

---

## 1. Arquitetura Embedded Topmed - Situação Atual

### 1.1 Infraestrutura

| Recurso | Quantidade | Especificação |
|---------|-----------|---------------|
| **Licenças Pro** | 19 | Desenvolvimento interno |
| **Capacity Embedded** | A2 | 5GB RAM, 2 v-Core |
| **Workspaces** | 30 | Workspaces Embedded |
| **Relatórios** | 1.543 | Maioria fragmentada |
| **Modelos Semânticos** | 73 | Em "BI TopMed 2" |

### 1.2 Workspaces Identificados (30)

```
_Data Flows
_Homologação
BI TopMed 2
Lista Beneficiários Cliente
Taxa Utilização
Saúde24h Plus E+
Saúde24h Premium E+
Saúde24h Standard
Saúde24h Smart E+
Saúde24h Smart
Saúde24h Plus
Saúde24h Basic
Saúde Emocional
Entrelaços
EAP/Teleconsulta
Crônicos
Nutrição (Nutricall)
Personalizado - Clientes
Teleorientação Psicológica
Teleconsulta Nutricional
Prudential
Telamed
Vallora
Marista
Mediclick
Bom Abraço
Unimed
Unifique
Tivit
Copel
Vivo
Vivo Values
```

### 1.3 Problema: Fragmentação Extrema

```
┌─────────────────────────────────────────────────────────────────┐
│ MODELO ATUAL: 1 Relatório por Cliente                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Taxa Utilizacao - Prefeitura de Guaratuba                      │
│  Taxa Utilizacao - Prefeitura de Guaramirim                     │
│  Taxa Utilizacao - Prefeitura de Araquari                       │
│  Taxa Utilizacao - ACAERT                                       │
│  Taxa Utilizacao - APAE Palhoca                                 │
│  Taxa Utilizacao - Allpfit                                      │
│  Taxa Utilizacao - A10 Beneficios                               │
│  ... (192 no total)                                             │
│                                                                  │
│  Lista Beneficiários - BrFan                                   │
│  Lista Beneficiários - FABRICA CT                              │
│  Lista Beneficiários - LOGOSUL                                 │
│  ... (201 no total)                                             │
│                                                                  │
│  IMPACTO:                                                       │
│  - Alterar 1 visualização = 192+ alterações manuais            │
│  - Novo cliente = novo relatório manual                         │
│  - Impossível manter                                           │
│  - Não escalável                                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. RLS no Power BI Embedded

### 2.1 Como Funciona

**SIM!** Power BI Embedded suporta RLS através da **Effective Identity API**.

O segredo está no token de embed: quando você gera o token, pode especificar qual identidade (role) será usada para aquele usuário específico.

### 2.2 Fluxo de Autenticação

```
┌─────────────────────────────────────────────────────────────────────────┐
│ FLUXO COMPLETO: EMBEDDED + RLS                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. USUÁRIO FINAL                                                        │
│     │                                                                    │
│     ├── Faz login na aplicação Topmed                                   │
│     │                                                                    │
│  2. BACKEND TOPMED                                                       │
│     │                                                                    │
│     ├── Autentica usuário (JWT/OAuth)                                   │
│     ├── Busca: qual cliente/empresa pertence?                           │
│     │ SELECT IdEmpresa FROM UsuarioEmpresa WHERE Email = @user           │
│     │                                                                    │
│  3. POWER BI API                                                         │
│     │                                                                    │
│     ├── POST /v1.0/capacities/{capacityId}/Workspaces/{wsId}/           │
│     │         Reports/{reportId}/GenerateToken                          │
│     │                                                                    │
│     ├── BODY:                                                            │
│     │   {                                                                │
│     │     "accessLevel": "View",                                        │
│     │     "identities": [                                               │
│     │       {                                                            │
│     │         "username": "usuario@empresa.com",                        │
│     │         "roles": ["RLSCliente"],                                  │
│     │         "datasets": [{"id": "dataset-id"}]                        │
│     │       }                                                            │
│     │     ]                                                              │
│     │   }                                                                │
│     │                                                                    │
│     ├── RESPONSE: Embed Token com RLS aplicado                          │
│     │                                                                    │
│  4. FRONTEND                                                             │
│     │                                                                    │
│     ├── Recebe token já filtrado                                        │
│     ├── Renderiza relatório Power BI                                    │
│     │                                                                    │
│  5. POWER BI ENGINE                                                      │
│     │                                                                    │
│     ├── Aplica RLS: WHERE IdEmpresa = @usuarioEmpresa                   │
│     ├── Retorna SOMENTE dados daquele cliente                          │
│     │                                                                    │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.3 API: GenerateToken com Effective Identity

```javascript
// HTTP Request
POST https://api.powerbi.com/v1.0/capacities/{capacityId}/Workspaces/{workspaceId}/Reports/{reportId}/GenerateToken
Authorization: Bearer {servicePrincipalToken}

{
  "accessLevel": "View",
  "identities": [
    {
      "username": "usuario@cliente.com.br",
      "roles": ["RLSCliente"],
      "datasets": [
        {
          "id": "cf23c5b7-5b7d-4c9e-8f1a-2b3c4d5e6f7a"
        }
      ]
    }
  ]
}

// Response
{
  "tokenId": "embed-token",
  "token": "H4sI...",
  "expiration": "2026-03-07T00:00:00Z"
}
```

---

## 3. Arquitetura RLS vs Cópia

### 3.1 Comparação Visual

```
┌─────────────────────────────────────────────────────────────────────────┐
│ MODELO ATUAL: 1 Relatório por Cliente (ANTI-PATTERN)                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Cliente A ──→ Relatório A (cópia completa)                             │
│  Cliente B ──→ Relatório B (cópia completa)                             │
│  Cliente C ──→ Relatório C (cópia completa)                             │
│  ...                                                                     │
│  Cliente Z ──→ Relatório Z (cópia completa)                             │
│                                                                          │
│  STORAGE: 192 relatórios "Taxa Utilização"                              │
│           201 relatórios "Lista Beneficiários"                          │
│           597 relatórios "Saúde24h"                                     │
│           ─────────────────────────────────                            │
│           1.543 RELATÓRIOS TOTAIS                                       │
│                                                                          │
│  MANUTENÇÃO:                                                             │
│  - Alterar 1 visual = refazer em 192 cópias                            │
│  - Atualizar 1 medida = refazer em 192 cópias                          │
│  - Mudar layout = refazer em 192 cópias                                │
│                                                                          │
│  NOVO CLIENTE:                                                           │
│  - Criar cópia manual                                                   │
│  - Configurar fonte de dados                                           │
│  - Ajustar filtros                                                     │
│  - Publicar                                                             │
│  - Testar                                                               │
│  → 4-8 horas de trabalho                                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ MODELO RLS: 1 Relatório Dinâmico (BEST PRACTICE)                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│                        ┌───────────────────┐                            │
│  Cliente A ──┐         │                   │                            │
│  Cliente B ──┼────────→│ Relatório ÚNICO   │──→ Power BI Embedded      │
│  Cliente C ──┘         │ com RLS dinâmico  │                            │
│  ...                  │                   │                            │
│  Cliente Z ──→        └───────────────────┘                            │
│                                                                          │
│  STORAGE: 1 relatório "Taxa Utilização"                                 │
│           1 relatório "Lista Beneficiários"                             │
│           ~15 relatórios "Saúde24h" (por segmento)                      │
│           ─────────────────────────────────                            │
│           ~50 RELATÓRIOS TOTAIS (97% redução)                          │
│                                                                          │
│  MANUTENÇÃO:                                                             │
│  - Alterar 1 visual = reflete para TODOS                               │
│  - Atualizar 1 medida = reflete para TODOS                             │
│  - Mudar layout = reflete para TODOS                                   │
│                                                                          │
│  NOVO CLIENTE:                                                           │
│  - Adicionar registro em tabela UsuarioEmpresa                          │
│  - Pronto!                                                               │
│  → 5 minutos de trabalho                                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Tabela Comparativa

| Aspecto | Modelo Atual (Cópia) | Modelo RLS |
|---------|---------------------|------------|
| **Relatórios "Taxa Utilização"** | 192 | 1 |
| **Relatórios "Lista Beneficiários"** | 201 | 1 |
| **Tempo alteração visual** | 192 × 30min = 96h | 30min |
| **Tempo setup novo cliente** | 4-8 horas | 5 minutos |
| **Escalabilidade** | Linear (piora com clientes) | Constante |
| **Manutenção** | Impossível | Simples |
| **Storage** | 1.543 artefatos | ~50 artefatos |
| **Governança** | Inexistente | Centralizada |

---

## 4. Implementação Passo a Passo

### 4.1 Modelo Power BI - Criar RLS

**No Power BI Desktop:**

1. Abra o modelo
2. Vá em **Modeling** > **Manage Roles**
3. Criar nova role: `RLSCliente`

```dax
// DAX da Role
[IdEmpresa] IN SELECTCOLUMNS(
    FILTER(
        UsuarioEmpresa,
        [Email] = USERPRINCIPALNAME()
    ),
    "Id", [IdEmpresa]
)
```

4. Testar com **Modeling** > **View as Roles**
5. Salvar e publicar

### 4.2 Tabela de Mapeamento Usuario → Empresa

Criar tabela no modelo (pode vir de SQL ou ser adicionada no Power Query):

```
UsuarioEmpresa
┌─────────────────────────────┬─────────────┬──────────────────┐
│ Email (PK)                  │ IdEmpresa   │ NomeCliente      │
├─────────────────────────────┼─────────────┼──────────────────┤
│ usuario@prefeitura-guaratuba │ 151         │ Guaratuba        │
│ usuario@apaepalhoca          │ 726         │ APAE Palhoca     │
│ gerente@brfan               │ 892         │ BrFan            │
│ ...                         │ ...         │ ...              │
└─────────────────────────────┴─────────────┴──────────────────┘
```

### 4.3 Backend - Gerar Token com Identidade

**C# (.NET):**

```csharp
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;

public class PowerBiEmbedService
{
    private readonly PowerBIClient _client;

    public async Task<string> GenerateEmbedTokenWithRLS(
        string workspaceId,
        string reportId,
        string datasetId,
        string userEmail,
        string userName
    )
    {
        var tokenRequest = new GenerateTokenRequest
        {
            AccessLevel = "View",
            Identities = new List<EffectiveIdentity>
            {
                new EffectiveIdentity
                {
                    Username = userEmail,
                    Roles = new List<string> { "RLSCliente" },
                    Datasets = new List<string> { datasetId }
                }
            }
        };

        var token = await _client.Reports
            .GenerateTokenInGroupAsync(workspaceId, reportId, tokenRequest);

        return token.Token;
    }
}
```

**Python:**

```python
from powerbi.client import PowerBIClient
from powerbi.models import GenerateTokenRequest, EffectiveIdentity

def generate_embed_token_with_rls(
    workspace_id: str,
    report_id: str,
    dataset_id: str,
    user_email: str
) -> str:
    """Gera token de embed com RLS aplicado"""

    token_request = GenerateTokenRequest(
        access_level="View",
        identities=[
            EffectiveIdentity(
                username=user_email,
                roles=["RLSCliente"],
                datasets=[dataset_id]
            )
        ]
    )

    response = client.reports.generate_token_in_group(
        workspace_id, report_id, token_request
    )

    return response.token
```

### 4.4 Frontend - Embed com Token

```javascript
// Embed o relatório com o token que já tem RLS
const embedConfig = {
    type: 'report',
    id: reportId,
    embedUrl: embedUrl,
    accessToken: embedTokenWithRLS,  // Token já com RLS
    tokenType: models.TokenType.Embed,
    settings: {
        filterPaneEnabled: false,
        navContentPaneEnabled: true
    }
};

powerbi.embed(reportContainer, embedConfig);
```

---

## 5. Análise de Custos

### 5.1 Capacity Pricing (Embedded)

| SKU | Preço/mês (USD) | RAM | v-Core | Backend API |
|-----|-----------------|-----|--------|-------------|
| **A1** | $713 | 2.5 GB | 1 | Sim |
| **A2** | $1,426 | 5 GB | 2 | Sim |
| **A3** | $2,849 | 10 GB | 4 | Sim |
| **A4** | $5,698 | 25 GB | 8 | Sim |
| **Pro** | $10/user | - | - | Não |

### 5.2 Topmed: A2 Suficiente?

**Análise:**
- A2 = 5GB RAM, 2 v-Core
- Topmed tem ~50 relatórios (pós-consolidação)
- Carga estimada: 50-100 usuários simultâneos

**Recomendação:**
- A2 é suficiente para operação atual
- Monitorar métricas: `capacityUsage`, `loadTime`
- Se >80% uso consistente, considerar A3

### 5.3 ROI da Migração

| Custo | Modelo Atual | Modelo RLS | Economia |
|-------|-------------|-----------|----------|
| **Capacity** | A2 ($1.426) | A2 ($1.426) | $0 |
| **Manutenção anual** | ~2.000h | ~200h | 90% |
| **Setup novo cliente** | 4-8h | 5min | 99% |
| **Alteração visual** | 96h | 0.5h | 99% |

**Conclusão**: Não há economia de capacity, mas **economia massiva de desenvolvimento**.

---

## 6. Plano de Migração Topmed

### Fase 1: Piloto (2 semanas)
**Produto**: Taxa de Utilização

- 192 relatórios → 1 relatório dinâmico
- 5 clientes piloto selecionados
- Validar Effective Identity API
- Testar performance com RLS

**Checklist:**
- [ ] Criar modelo unificado "Taxa Utilizacao RLS"
- [ ] Implementar role RLSCliente
- [ ] Criar tabela UsuarioEmpresa
- [ ] Mapear 5 clientes piloto
- [ ] Desenvolver endpoint de token
- [ ] Testar em ambiente de homologação
- [ ] Validar com stakeholders
- [ ] Documentar aprendizados

### Fase 2: Expansão (4 semanas)
**Produtos**: Lista Beneficiários, Entrelaços

- Mapear todos os clientes
- Migrar relatórios principais
- Documentar padrão
- Treinar equipe

**Checklist:**
- [ ] Mapear todas as 201 empresas "Lista Beneficiários"
- [ ] Criar modelo unificado "Lista Beneficiarios RLS"
- [ ] Migrar "Entrelaços" (118 relatórios → 2)
- [ ] Criar template de migração
- [ ] Documentar código padrão
- [ ] Treinar devs em Effective Identity

### Fase 3: Saúde24h (8 semanas)
**Produto mais complexo**: 597 relatórios

- Análise de variantes por produto
- Consolidação por segmento
- Migração gradual

**Checklist:**
- [ ] Analisar variantes: Plus, Premium, Standard, Smart
- [ ] Identificar o que é específico vs genérico
- [ ] Criar relatórios por segmento (não por cliente)
- [ ] Migrar gradualmente
- [ ] Testar exaustivamente

### Fase 4: Consolidação Final (2 semanas)

- Remover relatórios legados
- Reorganizar workspaces
- Documentação final

---

## 7. Perguntas Frequentes

**Q: RLS funciona com todos os tipos de fonte de dados?**
A: Sim, RLS é aplicado no nível do modelo Power BI, independente da fonte.

**Q: Posso ter múltiplas roles por usuário?**
A: Sim, pode especificar múltiplas roles no `identities` array.

**Q: E se um usuário acessar dados de outro cliente?**
A: Impossível. O RLS é aplicado no ENGINE do Power BI antes de qualquer dado ser retornado.

**Q: Preciso mudar de capacity?**
A: Não. A2 continua suficiente. RLS não aumenta carga significativamente.

**Q: E relatórios que precisam mostrar dados de múltiplos clientes?**
A: Crie uma role especial `RLSAdmin` ou use um relatório separado sem RLS para visões agregadas.

**Q: Como testar se o RLS está funcionando?**
A: Use Power BI Desktop > Modeling > View as Roles, ou teste via API com diferentes usuários.

---

## 8. Checklist de Implementação

### Pré-requisitos
- [ ] Service Principal com permissões de Workspace
- [ ] Capacity A configurada
- [ ] Tabela UsuarioEmpresa criada e populada
- [ ] Mapeamento completo de clientes

### Modelo Power BI
- [ ] Roles RLS criadas
- [ ] Tabelas de segurança adicionadas
- [ ] Relacionamentos configurados
- [ ] Testado com View as Roles
- [ ] Documentado no modelo

### Backend
- [ ] Endpoint GenerateToken implementado
- [ ] Autenticação funcionando
- [ ] Mapeamento usuario→empresa
- [ ] Error handling robusto
- [ ] Logging de tokens

### Frontend
- [ ] Power BI JS configurado
- [ ] Token sendo passado corretamente
- [ ] Tratamento de erros
- [ ] Loading states

### Testes
- [ ] Teste com usuário válido
- [ ] Teste com usuário inválido
- [ ] Teste com usuário sem permissão
- [ ] Teste de performance
- [ ] Teste de carga

---

## 9. Conclusão

**A Topmed está usando um anti-pattern de arquitetura:**

- 1.543 relatórios para servir ~73 modelos
- Fragmentação por cliente torna manutenção impossível
- Cada novo cliente multiplica a dívida técnica

**A migração para RLS é PRIORITÁRIA e viável:**

- Redução de 97% no número de relatórios
- Manutenção simplificada (1 alteração = todos clientes)
- Setup de novo cliente em minutos (não horas)
- Usa o MESMO capacity A2 existente

**Próximo passo:** Iniciar piloto com "Taxa de Utilização" (192 → 1 relatório).

---

**Documento versão 1.0**
**Data: 06/03/2026**
**Framework AGPBI v3.2**
