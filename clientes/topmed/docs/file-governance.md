# Agente de Governança de Arquivos - Documentação

> **Novo agente especializado em manter o projeto organizado**

## 🎯 Problema Resolvido

**Antes**:
- Arquivos criados em qualquer lugar
- Estrutura de pastas não seguida
- Arquivos temporários acumulando
- Difícil encontrar documentos
- Ninguém responsável pela organização

**Depois**:
- **Agente dedicado** que monitora e organiza
- **Detecção automática** de arquivos fora do lugar
- **Limpeza automática** de arquivos temporários
- **Auditoria periódica** da estrutura
- **Tudo sempre organizado**

---

## 🤖 Agente: File Governance Agent

**Arquivo**: `.claude/agents/file-governance-agent.md`

### O Que Ele Faz

1. **Monitora estrutura** - Verifica se arquivos estão nos lugares corretos
2. **Lê e interpreta documentos** - Entende o conteúdo e categoria
3. **Move arquivos automaticamente** - Coloca cada arquivo no lugar certo
4. **Cria pastas** - Garante que a estrutura exista
5. **Limpa temporários** - Remove arquivos inúteis
6. **Audita periodicamente** - Gera relatórios de governança

### O Que Ele Sabe

#### Estrutura Esperada (De Cor)
```
cliente-x/
├── 00-contexto/          # 4 arquivos permanentes
├── 01-vision/            # 5 arquivos obrigatórios
├── 02-validate/          # 5 arquivos obrigatórios
├── 03-build/             # Build + projetos PBIP
├── 04-reunioes/          # Transcrições
├── 05-atividades/        # Tarefas
└── 06-decisoes/          # Decisões
```

#### Padrões de Nomes
- `cliente.md` → `00-contexto/`
- `escopo.md` → `01-vision/`
- `analise-dados.md` → `02-validate/`
- `ACT-*.md` → `05-atividades/`
- `DEC-*.md` → `06-decisoes/`
- `YYYY-MM-DD-*.md` → `04-reunioes/`

#### Tipos de Conteúdo
- Detecta pelo conteúdo (primeiras 50 linhas)
- Classifica automaticamente
- Move para local correto

---

## ⚡ Skills de Governança

### 1. /verificar-estrutura
**O que faz**: Scan completo e verifica onde cada arquivo está

**Output**:
```markdown
# Verificação de Estrutura

✅ Files Correctly Placed (104)
⚠️ Misplaced Files (18)
  - dashboard_vendas.md → 01-vision/hipotese.md
  - wireframe.png → 03-build/projects/.../imagens/

❌ Missing Mandatory Files (2)
  - 01-vision/stakeholders.md
  - 02-validate/riscos.md

🗑️ Temporary Files (5)
  - _temp/scratch.txt
  - ~$escopo.docx
```

### 2. /organizar-arquivos
**O que faz**: Move arquivos para locais corretos automaticamente

**Processo**:
1. Detecta tipo do arquivo
2. Determina local correto
3. Cria pasta se não existe
4. Move arquivo
5. Atualiza referências

**Exemplo**:
```bash
# Antes
root/
  ├── analise_vendas.txt      # Fora do lugar
  └── dashboard.png            # Fora do lugar

# Depois
02-validate/
  └── analise-dados.md        # Movido e renomeado
03-build/projects/comercial/Documentation/imagens/
  └── dashboard.png            # Movido
```

### 3. /limpar-temporarios
**O que faz**: Remove arquivos temporários e inúteis

**Remove automaticamente**:
- `*.tmp`, `*.temp`, `*.bak`
- `~$*` (Office temp files)
- `.DS_Store`, `Thumbs.db`
- Arquivos em `_temp/` (mais de 7 dias)

**Pergunta antes de deletar**:
- Duplicados
- Arquivos grandes (>10MB)
- Arquivos suspeitos

**Output**:
```markdown
# Limpeza Completada

🗑️ Deletados: 12 arquivos
📦 Arquivados: 5 atividades
💾 Espaço salvo: 2.3 MB
```

### 4. /resumir-documento
**O que faz**: Lê documento e gera resumo estruturado

**Usa para**:
- Entender rapidamente um documento
- Categorizar arquivo
- Gerar contexto

**Output**:
```markdown
# Resumo: [Nome]

📋 Tipo: Vision/Validate/Build
🎯 Propósito: [Descrição]
📌 Pontos Chave: [3-5 pontos]
✅ Decisões: [Se houver]
👥 Responsáveis: [Pessoas]
⚠️ Riscos: [Se houver]
📅 Próximos Passos: [Ações]
```

### 5. /auditoria-arquivos
**O que faz**: Auditoria completa com score

**Checa**:
- Estrutura (30%)
- Localização (25%)
- Completude (20%)
- Qualidade (15%)
- Referências (10%)

**Output**:
```markdown
# Auditoria de Governança

Score: 85/100 - Bom

📊 Breakdown:
- Estrutura: 90/100 ✅
- Localização: 80/100 ⚠️ (3 arquivos fora do lugar)
- Completude: 100/100 ✅
- Qualidade: 75/100 ⚠️
- Referências: 85/100 ✅

⚠️ Issues: 15 encontrados
🎯 Recomendações: 3 ações
```

### 6. /status-arquivos
**O que faz**: Status rápido da organização

**Output rápido**:
```markdown
# Status de Arquivos

Score: 85/100 - Bom
Última verificação: 2 dias atrás

✅ Vision: Completo
✅ Validate: Completo
⚠️ Build: 3 arquivos fora do lugar

🎯 Próxima ação: /organizar-arquivos
```

---

## 🔄 Como Funciona

### Monitoramento Automático

#### Hook de Pré-Writing
Quando um arquivo é criado:

```
USUÁRIO: Criando arquivo "analise.md" no root

FILE GOVERNANCE HOOK:
⚠️ Alerta: Este arquivo parece estar no lugar errado

Tipo detectado: Análise de dados
Local correto: 02-validate/analise-dados.md

Opções:
[1] Criar no local correto
[2] Criar anyway (não recomendado)
[3] Cancelar

> Usuário escolhe 1

✅ Arquivo criado em 02-validate/analise-dados.md
```

#### Hook de Pré-Commit
Antes de fazer commit:

```
GIT COMMIT detectado:

FILE GOVERNANCE HOOK:
⚠️ Você está tentando commitar arquivos temporários:
- _temp/scratch.txt
- ~$documento.docx

Recomendado:
1. Executar /limpar-temporarios primeiro
2. Adicionar ao .gitignore

Continuar commit? [s/N]
```

### Auditoria Periódica

#### Manual
```bash
/auditoria-arquivos
```

#### Automático (Recomendado: Semanal)
```
FILE GOVERNANCE AGENT:
⏰ Hora da auditoria semanal!

Escaneando projeto...
[██████████] 100%

Score: 85/100 - Bom

Encontrados:
- 18 arquivos fora do lugar
- 5 arquivos temporários
- 2 pastas faltando

Posso organizar? [/confirmar]
```

---

## 📋 Exemplo de Uso

### Cenário 1: Arquivo Criado no Lugar Errado

```
USUÁRIO: Vou criar um documento de escopo aqui no root

[Usuário cria escopo_novo.txt no root]

FILE GOVERNANCE:
⚠️ Detectado arquivo fora do lugar!

Arquivo: escopo_novo.txt
Deveria ser: 01-vision/escopo.md

Posso mover automaticamente? [s/N]

USUÁRIO: s

FILE GOVERNANCE:
✅ Movido para 01-vision/escopo.md
✅ Renomeado para padrão
✅ Referências atualizadas (se houver)
```

### Cenário 2: Auditoria Completa

```
USUÁRIO: /auditoria-arquivos

FILE GOVERNANCE:
🔍 Auditando projeto...

Escaneando 127 arquivos...
Categorizando por tipo...
Verificando localização...
Buscando duplicatas...
Validando referências...

[████████████████] 100%

## Score: 72/100 - Precisa melhorar

⚠️ 18 arquivos fora do lugar:
- dashboard_vendas.md → 01-vision/hipotese.md
- wireframe.png → 03-build/projects/.../imagens/
- notas.txt → 04-reunioes/2026-02-27-resumo.md

🗑️ 5 arquivos temporários:
- _temp/scratch.txt
- ~$escopo.docx
- .DS_Store (x2)
- backup.bak

Posso organizar agora?
Isso vai:
- Mover 18 arquivos
- Deletar 5 temporários
- Criar 2 pastas
- Salvar 2.3 MB

[/confirmar] para prosseguir

USUÁRIO: /confirmar

FILE GOVERNANCE:
✅ Organizando...

Movendo: [████████████████] 100%
Deletando: [████████████████] 100%
Criando pastas: [████████████████] 100%

## ✅ Completo!

Score atualizado: 95/100 - Excelente

Mudanças:
- 18 arquivos movidos
- 5 arquivos deletados
- 2 pastas criadas
- Espaço salvo: 2.3 MB
```

### Cenário 3: Limpeza de Temporários

```
USUÁRIO: /limpar-temporarios

FILE GOVERNANCE:
🔍 Buscando arquivos temporários...

Encontrados:
- 3 arquivos .tmp
- 2 arquivos .bak
- 4 arquivos _temp/
- 1 arquivo _temp/scratch.txt (2 dias)

Arquivos a deletar: 10
Espaço recuperável: 1.2 MB

Continuar? [s/N]

USUÁRIO: s

FILE GOVERNANCE:
✅ Deletando...
[████████████████] 100%

✅ 10 arquivos deletados
✅ 2 pastas vazias removidas
💾 1.2 MB liberado

Projeto limpo! ✨
```

---

## 🎓 Comandos Disponíveis

### Verificação
- `/status-arquivos` - Status rápido
- `/verificar-estrutura` - Verificação detalhada
- `/auditoria-arquivos` - Auditoria completa

### Organização
- `/organizar-arquivos` - Auto-organiza tudo
- `/mover-arquivo <file> <dest>` - Move arquivo específico

### Limpeza
- `/limpar-temporarios` - Remove arquivos inúteis

### Documentos
- `/resumir-documento <file>` - Resume documento

### Estrutura
- `/criar-pasta-governanca` - Garante estrutura de pastas

---

## ✅ Checklist de Implementação

### Agente
- [x] File Governance Agent criado
- [x] Conhece estrutura de cor
- [x] Detecta tipos de arquivo
- [x] Move arquivos automaticamente
- [x] Limpa temporários
- [x] Gera auditorias

### Skills
- [x] /verificar-estrutura
- [x] /organizar-arquivos
- [x] /limpar-temporarios
- [x] /resumir-documento
- [x] /auditoria-arquivos
- [x] /status-arquivos

### Hooks
- [x] Hook de pré-writing (avisa local errado)
- [x] Hook de pré-commit (bloqueia temporários)

---

## 🚀 Como Usar

### Manual
```bash
# Ver status
/status-arquivos

# Auditoria completa
/auditoria-arquivos

# Organizar tudo
/organizar-arquivos

# Limpar temporários
/limpar-temporarios
```

### Automático
- Hook avisa quando cria arquivo no lugar errado
- Hook bloqueia commit com temporários
- Agente pode ser chamado periodicamente

---

**Seu projeto sempre organizado automaticamente! 🗂️✨**

Qualquer arquivo fora do lugar?
→ File Governance Agent detecta e corrige

Arquivos temporários acumulando?
→ File Governance Agent limpa automaticamente

Precisa encontrar algo rápido?
→ File Governance Agent sabe onde tudo está
