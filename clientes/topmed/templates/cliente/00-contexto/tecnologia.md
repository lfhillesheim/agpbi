# Stack Tecnológico

> **Mapear toda a infraestrutura tecnológica do cliente**

## Arquitetura de Sistemas

### Diagrama de Alto Nível
```
[Descrever ou colar diagrama mostrando como os sistemas se conectam]
```

## Sistemas Transacionais

### ERP
| Item | Detalhes |
|------|----------|
| Sistema | |
| Versão | |
| Fornecedor | |
| Localização | On-premise / Cloud / Híbrido |
| Acesso | SQL Server / API / Outro |
| Responsável | |
| Documentação | |

### CRM
| Item | Detalhes |
|------|----------|
| Sistema | |
| Versão | |
| Fornecedor | |
| Localização | |
| Acesso | |
| Responsável | |
| Documentação | |

### Outros Sistemas
| Sistema | Tipo | Versão | Fornecedor | Acesso |
|---------|------|--------|------------|--------|
| | | | | |

## Infraestrutura de Dados

### Data Warehouse
| Item | Detalhes |
|------|----------|
| Existe DW? | [ ] Sim [ ] Não |
| Tecnologia | SQL Server / Snowflake / Redshift / Outro |
| Versão | |
| Tamanho | |
| Modelo | Star Schema / Outro |
| Responsável | |
| Documentação | |

### Data Lake / Outros
| Item | Detalhes |
|------|----------|
| Tecnologia | ADLS / S3 / Outro |
| Uso | Raw / Processed / Curated |
| Tamanho | |
| Responsável | |

## Power BI

### Capacidade
| Item | Detalhes |
|------|----------|
| Tipo | Pro / Premium / Embedded |
| Capacidade | [Nome se Premium/Embedded] |
| Workspace | [Nome] |
| Admin | [Nome] |
| Domínio | [domínio.powerbi.com] |

### Gateway
| Item | Detalhes |
|------|----------|
| Gateway | [ ] Sim [ ] Não |
| Tipo | Standard / Personal |
| Versão | |
| Máquina | |
| Serviço roda como | |
| Modo | |
| Responsável | |

### Licenças
| Tipo | Quantidade | Custo mensal |
|------|------------|--------------|
| Pro | | |
| Premium per user | | |
| Premium capacity | | |

## Rede e Conectividade

### Locais
| Local | Tipo de conexão | Velocidade | Restrições |
|-------|-----------------|------------|-------------|
| Sede | | | |
| Filial 1 | | | |
| Cloud (Azure/AWS) | | | |

### VPN / Firewall
- VPN necessária: [ ] Sim [ ] Não
- Portas liberadas:
- Restrições de IP:
- Whitelist:

## Segurança

### Autenticação
- Método: Azure AD / Outro
- MFA: [ ] Sim [ ] Não
- Single Sign-On: [ ] Sim [ ] Não

### Autorização
- Método: RBAC / Groups / Outro
- Administração:
- Usuários finais:

### Auditoria
- Logs ativados: [ ] Sim [ ] Não
- Onde ficam os logs:
- Retenção:

## Governança de Dados

### Qualidade de Dados
- Processo de qualidade: [ ] Sim [ ] Não
- Ferramenta: [Nome se houver]
- Responsável:
- Métricas de qualidade:

### Catálogo de Dados
- Catálogo: [ ] Sim [ ] Não
- Ferramenta:
- Documentado até que nível:

### Privacidade
- Dados pessoais: [ ] Sim [ ] Não
- LGPD: [ ] Compliance total [ ] Parcial [ ] Não
- Anonimização: [ ] Sim [ ] Não [ ] Parcial

## Suporte e Manutenção

### Janelas de Manutenção
- Sistema 1: [Horários]
- Sistema 2: [Horários]
- Power BI: [Horários]

### Contingência
- Plano de disaster recovery: [ ] Sim [ ] Não
- Backup dos relatórios: [ ] Sim [ ] Não
- RTO (Recovery Time Objective):
- RPO (Recovery Point Objective):

## Performance

### SLOs (Service Level Objectives)
| Sistema | Disponibilidade | Latência | Throughput |
|---------|-----------------|-----------|------------|
| | | | |

### Capacidade Planejada
- Crescimento esperado (dados): % ao ano
- Crescimento esperado (usuários): % ao ano
- Projetos futuros que impactarão:

## Anexos
- [Diagrama de arquitetura atual]
- [Diagrama de rede]
- [Documentação de APIs]
- [Manuais de sistemas]
- [Contatos de fornecedores]

---
**Última atualização**: YYYY-MM-DD
**Responsável**: [Nome]
