# Vision: Topmed - Mapeamento Ecossistema de Dados

**Cliente**: Topmed Assistência à Saúde Ltda.
**Projeto**: Reestruturação BI - Mapeamento AS-IS
**Data Início**: 03/03/2026
**Gestor**: Rafael Faria (Gerente de Tecnologia)
**Consultor**: Evoluke
**Prazo**: 1 ano (até 31/12/2026)

---

## 1. Contexto do Cliente

### 1.1 Overview

- **Fundação**: Agosto 2006, Florianópolis/SC
- **Porte**: 18 anos, uma das 5 maiores operadoras de telessaúde do Brasil
- **Líder absoluta**: Região Sul
- **Impacto**: +20 milhões de vidas
- **Resolutividade clínica**: 94%
- **NPS (Satisfação)**: 95.4
- **Atendimentos**: 5 milhões (últimos 3 anos, crescimento 120%)
- **Capital Social**: R$ 3,295 milhões
- **Contratos governo**: +R$ 144 milhões

### 1.2 Missão

> "Cuidar das pessoas promovendo atendimento de saúde com qualidade, tecnologia e humanização"

### 1.3 Liderança Executiva

| Executivo | Função | Foco para Consultoria |
|-----------|--------|----------------------|
| **Valda Stange** | CEO | Visão 360, Rentabilidade, Estratégia |
| **Paulo Salvi** | CTO | Infraestrutura, Stack, Integrações |
| **Renata Zobaran** | Diretora Telemedicina | Qualidade Assistencial, Dados Clínicos |
| **Cleones Hostins** | CCO | BI Comercial, CRM, Vendas |

---

## 2. Modelo de Negócio

### 2.1 Segmentação

| Segmento | Descrição | KPIs Principais |
|----------|-----------|-----------------|
| **B2G** (Setor Público) | Municípios, SUS | BPA, Previne Brasil, Repasses |
| **B2B** (Setor Privado) | EAP, Saúde do Colaborador | Sinistralidade, ROI, Absenteísmo |
| **Parcerias** (White Label) | Bancos, Seguradoras | Recorrência, LTV, Churn |

### 2.2 Soluções (Portfólio)

| Solução | Canais | Dados Gerados |
|---------|--------|---------------|
| **Saúde24h / PAV** | WhatsApp, 0800, App, Web | Triagem IA, Resolutividade 93.8% |
| **Teleconsultas** | Plataforma Digital | +30 especialidades, Logs de atendimento |
| **EAP** | Omnichannel | Médica, Jurídica, Financeira, Social |
| **AuroraCare** | Software Dispositivo | IA, Imagens (Câncer de Mama) |
| **Programas Crônicos** | Plataforma | Dados longitudinais, Evolução paciente |

---

## 3. Ecossistema de Dados - AS-IS

### 3.1 Fontes de Dados Identificadas

| Fonte | Tipo | Descrição |
|-------|------|-----------|
| **ERP** | TOTVS (Protheus/Datasul), SAP | Contábil, Financeiro |
| **CRM** | Proprietário | Gestão de contratos, Clientes |
| **Sistemas Assistenciais** | Proprietário | PEP, Prontuários, Logs atendimento |
| **APIs Terceiros** | Externo | Laboratórios, Farmácias, Interoperabilidade |
| **SUS** | Externo | RNDS, BPA, Previne Brasil |
| **AWS** | Cloud | Alexa, IA, Analytics |
| **Planilhas** | Diversos | Áreas diversas (gambiarras) |

### 3.2 Desafios Identificados

- ✗ **SQL Server "capenga"** - infraestrutura limitada
- ✗ **Muitas gambiarras** - soluções paliativas
- ✗ **Silos de dados** - financeiro não conversa com assistencial
- ✗ **Falta de governança** - sem rastreabilidade de fontes
- ✗ **Planilhas everywhere** - shadow IT
- ✗ **Não amarrar ao construído** - tudo pode ser refeito

---

## 4. Stakeholders Mapeados

### 4.1 Executivos (Sponsors)

- **Rafael Faria** - Gerente de Tecnologia (Gestor do Projeto)
- **Paulo Salvi** - CTO (Infraestrutura)
- **Valda Stange** - CEO (Strategic decisions)

### 4.2 Áreas de Negócio

| Área | Responsável | Necessidades de BI |
|------|-------------|-------------------|
| **Financeiro** | ? | Glosas, Rentabilidade, Custo atendimento |
| **Comercial** | Cleones Hostins | Funil vendas, Churn, LTV |
| **Assistencial** | Renata Zobaran | Resolutividade, Qualidade clínica |
| **Marketing** | ? | NPS, Engajamento, Canais |
| **Operação** | ? | Produtividade, Throughput |

---

## 5. KPIs Identificados

### 5.1 Financeiros

- Gestão de Glosas
- Rentabilidade por Contrato
- Custo de Atendimento (por teleconsulta)
- Margem por Cliente (B2B/B2G)

### 5.2 Operacionais/Clínicos

- Resolutividade (94%)
- NPS (95.4)
- Volume de Atendimentos
- Taxa de Triagem IA (Medy)

### 5.3 Comerciais

- Churn Rate
- LTV (Lifetime Value)
- CAC (Custo de Aquisição)
- Engajamento por Canal

---

## 6. Hipótese do Projeto

> "A modernização do parque de dados da Topmed permitirá uma visão 360° do negócio, integrando dados assistenciais, financeiros e operacionais em tempo real, possibilitando decisões baseadas em evidências e sustentando a expansão da empresa."

---

## 7. Escopo Inicial

### Fase 1: AS-IS (Discovery) ← **ESTAMOS AQUI**

- [x] Análise documental realizada
- [ ] Mapeamento completo de fontes de dados
- [ ] Levantamento de dashboards existentes
- [ ] Identificação de "gambiarras"
- [ ] Entrevistas com stakeholders
- [ ] Priorização de projetos

### Fase 2: Proposta de To-Be

- [ ] Arquitetura de dados futura
- [ ] Roadmap de projetos
- [ ] Priorização (Quick Wins vs Long Term)

### Fase 3: Execução

- [ ] Projetos priorizados
- [ ] Treinamento de equipe
- [ ] Operação continuada

---

## 8. Próximos Passos

1. **Entrevistar Rafael Faria** - validar mapeamento, priorizar
2. **Mapear fontes SQL Server** - estrutura, tabelas, volumes
3. **Levantar dashboards existentes** - o que hoje é usado
4. **Identificar primeiros projetos** - Quick Wins
5. **Definir arquitetura target** - proposta de modernização

---

**Status**: Discovery em andamento
**Última atualização**: 03/03/2026
