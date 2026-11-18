# Memória Descritiva — Spotted

> Documento vivo: é preenchido ao longo do semestre e fechado na 3.ª entrega (11/12/2026).
> As secções marcadas com ✅ já têm conteúdo de base retirado da proposta v1.

## a. Identificação

| | |
|---|---|
| **Nome do projeto** | Spotted |
| **Ano letivo** | 2026/2027 |
| **Semestre** | 3.º semestre |
| **Unidade(s) curricular(es)** | Projeto de Desenvolvimento Móvel · Programação de Dispositivos Móveis · Bases de Dados · Redes e Comunicação de Dados · Interfaces e Usabilidade · Matemática Discreta |
| **Docente(s)** | Fabio Guilherme (Projeto de Desenvolvimento Móvel) · João Monge (Programação de Dispositivos Móveis) · Miguel Boavida (Bases de Dados) · Nathan Campos e Pedro Rosa (Redes e Comunicação de Dados) · Paula Neves (Interfaces e Usabilidade) · André Torcato e Ricardo Sousa (Matemática Discreta) |

## b. Resumo

*(300 a 500 palavras — escrever no fim do projeto, descrevendo o que foi efetivamente construído.)*

## c. Contexto

### i. Problema abordado ✅
Escolher onde sair à noite implica saltar entre várias apps. As avaliações existentes são genéricas e não provam que a pessoa esteve no local, as apps de eventos não dizem como está o sítio *agora*, e as apps de controlo de consumo não são usadas a meio da noite. Não há um lugar que responda a três perguntas: *onde vale a pena ir hoje?*, *como está o ambiente neste momento?* e *estou em condições de voltar a casa sozinho?*

### ii. Motivação ✅
A noite é um contexto móvel exigente (pouca luz, pressa, telemóvel na mão) e obriga a usar várias capacidades do dispositivo: GPS, câmara, mapas e tempo real. A componente de consumo responsável dá ao projeto um propósito social.

### iii. Objetivos ✅
1. App Flutter com mapa de spots, check-in verificado (QR/GPS) e avaliações por critério.
2. Contador de bebidas com estimativa de alcoolemia calculada por métodos numéricos.
3. Chat por spot, só para quem fez check-in, com mensagens efémeras.
4. API REST em Node.js sobre MySQL, documentada e com dados fictícios.
5. Validação da usabilidade com utilizadores reais.
6. Cumprimento do RGPD desde a conceção.

## d. Processo

### i. Metodologia utilizada
Scrum simplificado: sprints de 2 semanas, backlog e quadro Kanban no GitHub Projects, reunião semanal e revisão no fim de cada sprint. *(Completar com o que correu bem e mal.)*

### ii. Ferramentas utilizadas
GitHub, GitHub Projects, Figma, FigJam, Visual Studio Code, Android Studio, MySQL Workbench, Postman.

### iii. Tecnologias utilizadas
Flutter 3 / Dart, Node.js 20, Express, Socket.io, MySQL 8, OpenStreetMap.

### iv. Estrutura da equipa

| Elemento | Papel principal |
|---|---|
| [Nome] | Gestão de projeto, Matemática Discreta |
| [Nome] | UX/UI e usabilidade |
| [Nome] | App Flutter |
| [Nome] | API Node.js, Redes e Base de Dados |

## e. Resultados

### i. Descrição da solução desenvolvida
*Estado na versão alfa (2.ª entrega, novembro de 2026). A rever na 3.ª entrega.*

A Spotted é composta por uma app em Flutter/Dart e uma API REST em Node.js/Express, ambas organizadas em MVC, sobre uma base de dados MySQL com 14 tabelas e dados fictícios. A app comunica com a API por HTTP/JSON e autentica-se com um token JWT. A estimativa de alcoolemia é calculada no dispositivo (modelo de Widmark) e a validação do check-in é feita no servidor, para não poder ser contornada. Arquitetura e diagrama de classes em [`04_Documentacao_Tecnica`](../04_Documentacao_Tecnica/README.md); documentação REST em [`Documentos/api.md`](../../Documentos/api.md).

### ii. Funcionalidades principais
Implementadas na versão alfa:

| Funcionalidade | O que faz |
|---|---|
| Registo e login | Conta só para maiores de 18 anos, com aceitação do RGPD e confirmação da palavra-passe; palavra-passe guardada com bcrypt; sessão com JWT |
| Mapa e lista de spots | Mapa OpenStreetMap com a posição do utilizador; pesquisa por nome ou zona e filtros por tipo e preço |
| Check-in por QR Code | Lê o código único afixado no spot |
| Check-in por GPS | Aceite só a menos de 100 m do spot e com precisão GPS até 100 m (fórmula de Haversine); fica ativo 4 horas |
| A minha noite | Registo de bebidas a partir do catálogo, estimativa da taxa de álcool, gráfico da noite, hora a que fica abaixo de 0,5 g/L e aviso para não conduzir; a noite recomeça quando a taxa chega a 0 |

Previstas para a 3.ª entrega: avaliações de spots e cocktails, chat por spot com denúncias, ficha do spot na app, perfil (peso, sexo, histórico), terminar a noite, eliminação de conta e métodos numéricos (Newton/bisseção).

*(Na versão final, juntar uma captura de ecrã de cada funcionalidade em `02_Imagens`.)*

### iii. Contributos relevantes
- **Check-in verificado** por QR ou GPS, validado no servidor, como base para avaliações e chat só de quem esteve no local.
- **Estimativa de alcoolemia integrada na noite**: um toque por bebida e a hora a partir da qual a estimativa desce abaixo do limite legal, validada pelo questionário (10 em 10 respostas consideraram-na útil).
- **Questionário a 10 utilizadores** que validou as personas e mudou a prioridade do mapa: serve também para ver o estado dos sítios habituais, e não só para descobrir sítios novos ([análise](../06_Dados_Investigacao/questionario-analise.md)).

## f. Reflexão

### i. Lições aprendidas
*(a preencher)*

### ii. Limitações
*(a preencher)*

### iii. Trabalho futuro
*(a preencher)*
