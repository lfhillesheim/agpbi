# Guia de Início Rápido

> Comece a usar o AGPBI Framework em 15 minutos

## 🎯 Objetivo

Este guia vai te ajudar a:
1. Entender a estrutura básica do framework
2. Criar seu primeiro projeto cliente
3. Executar o ciclo Vision-Validate-Build

## 📋 Pré-requisitos

- [ ] Claude Code CLI instalado
- [ ] Power BI Desktop instalado
- [ ] Conta Power BI Service (Pro ou Premium)
- [ ] Git instalado
- [ ] Editor de texto (VS Code recomendado)

## 🚀 Passo 1: Instalação (5 min)

### 1.1 Clone o Repositório

```bash
git clone https://github.com/seu-usuario/agpbi-framework.git
cd agpbi-framework
```

### 1.2 Explore a Estrutura

```bash
# Veja os agentes disponíveis
ls .claude/agents/

# Veja os skills/workflows
ls .claude/skills/

# Veja os templates
ls templates/cliente/
```

### 1.3 Leia o CLAUDE.md

```bash
# Este é o coração do framework
cat CLAUDE.md
```

## 🎯 Passo 2: Criar Primeiro Projeto (5 min)

### 2.1 Copie o Template

```bash
# Crie novo projeto para cliente
cp -r templates/cliente ../cliente-exemplo
cd ../cliente-exemplo
```

### 2.2 Preencha o Contexto Básico

Edite `00-contexto/cliente.md`:

```markdown
# Contexto do Cliente

## Visão Geral
**Nome do Cliente**: Exemplo Ltda
**Segmento**: Varejo
**Tamanho**: 500 funcionários

## Objetivos Estratégicos
1. Aumentar vendas em 20%
2. Reduzir estoque parado

[... continue preenchendo ...]
```

## 🔭 Passo 3: Executar Vision (10 min)

### 3.1 Inicie o Skill Vision

No Claude Code:

```
/vision
```

### 3.2 Responda as Perguntas

O agente vai perguntar:
- Qual o nome do cliente?
- Qual o nome do projeto?
- Qual problema estamos resolvendo?
- Quais são os stakeholders?
- Quais são as fontes de dados?

### 3.3 Revise os Documentos Gerados

```bash
# Verifique o que foi criado
ls 01-vision/

# Deve conter:
# - contexto-cliente.md
# - escopo.md
# - stakeholders.md
# - mapeamento-dados.md
# - hipotese.md
```

### 3.4 Valide com o Cliente

Antes de prosseguir:
- [ ] Apresente o escopo ao cliente
- [ ] Obtenha aprovação formal
- [ ] Confirme prazos e expectativas

## ✓ Passo 4: Executar Validate (10 min)

### 4.1 Inicie o Skill Validate

```
/validate
```

### 4.2 Conecte aos Dados

O agente vai:
- Listar conexões disponíveis
- Conectar às fontes de dados
- Explorar estrutura dos dados

### 4.3 Valide os Números

- Extraia amostra de dados
- Calcule métricas chave manualmente
- Compare com o que o negócio espera
- Documente discrepâncias

### 4.4 Crie o Wireframe

- Desenhe o layout do dashboard
- Valide com stakeholders
- Obtenha aprovação

### 4.5 Tomada de Decisão

**GO**: Prosseguir para Build
**GO com condições**: Prosseguir com ressalvas
**NO-GO**: Revisar abordagem

## 🔨 Passo 5: Executar Build (30 min)

### 5.1 Inicie o Skill Build

```
/build
```

### 5.2 Siga o Ciclo de 10 Passos

1. **Conexão**: Configure todas as fontes
2. **ETL**: Construa o Power Query
3. **Modelagem**: Crie o Star Schema
4. **Relacionamentos**: Configure as ligações
5. **Cálculos**: Escreva as medidas DAX
6. **Visuais**: Construa os gráficos
7. **Design**: Aplique o tema
8. **Orquestração**: Configure refresh
9. **Documentação**: Escreva os docs
10. **Segurança**: Configure RLS (se necessário)

### 5.3 Teste e Valide

- [ ] Abra no Power BI Desktop
- [ ] Verifique todos os visuais
- [ ] Teste os filtros
- [ ] Valide as medidas
- [ ] Teste o refresh

### 5.4 Entregue

- [ ] Publique no Power BI Service
- [ ] Configure o gateway
- [ ] Treine os usuários
- [ ] Obtenha sign-off

## 📊 Passo 6: Gerenciar o Projeto

### Ver Status

```
/status
```

Isso mostra:
- Fase atual
- Documentos completos
- Atividades pendentes
- Riscos identificados

### Transcrever Reuniões

```
/transcrever-reuniao
```

Cole a transcrição e o agente vai:
- Extrair action items
- Documentar decisões
- Identificar gargalos
- Atualizar atividades

### Revisar Modelo

```
/revisar-modelo
```

O agente vai analisar:
- Star Schema
- Relacionamentos
- Medidas DAX
- Performance
- Documentação

## 🎓 Dicas Importantes

### ✅ Sempre Faça

- Documente tudo
- Valide com o negócio
- teste antes de entregar
- Use versionamento (git)
- Faça commits frequentes

### ❌ Nunca Faça

- Pule o Vision
- Assuma que os dados estão corretos
- Deixe para documentar depois
- Ignore a opinião do usuário
- Entregue sem testar

### 🚨 Sempre que Travou

1. **Use `/status`** para ver onde está
2. **Leia o CLAUDE.md** para contexto
3. **Consulte os docs** em `docs/`
4. **Pergunte** - não assuma

## 📚 Próximos Passos

1. **Aprenda a Metodologia**
   - Leia [docs/metodologia.md](metodologia.md)

2. **Melhores Práticas**
   - Leia [docs/melhores-praticas.md](melhores-praticas.md)

3. **Power BI Skills**
   - Explore as skills em `.claude/skills/`

4. **Personalize**
   - Adapte templates para sua realidade
   - Crie novos agentes se necessário
   - Contribua com melhorias

## 🆘 Problemas Comuns

### Problema: Agentes não funcionam

**Solução**:
- Verifique se Claude Code está instalado
- Confirme que está na pasta do projeto
- Leia o CLAUDE.md para contexto

### Problema: Não consigo ir para Validate

**Solução**:
- Complete TODOS os documentos do Vision
- Obtenha aprovação do escopo
- O hook vai bloquear se algo faltar

### Problema: Dados não conectam

**Solução**:
- Verifique credenciais
- Confirme acesso ao gateway
- Teste com Power BI Desktop primeiro
- Consulte o TI do cliente

### Problema: Medidas DAX erradas

**Solução**:
- Use `/revisar-modelo`
- Valide com o negócio
- Consulte referências DAX
- Teste incrementalmente

## 💬 Feedback

Este guia foi útil? Tem sugestões?

- Abra uma issue no GitHub
- Entre em contato com o time
- Contribua com melhorias

---

**Bom trabalho!** 🚀

Próxima leitura: [Metodologia Completa](metodologia.md)
