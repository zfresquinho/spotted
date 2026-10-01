<div class="capa">

# Spotted

**Descobre o spot, junta-te à noite, volta bem a casa.**

Proposta Inicial de Projeto — versão 1 (1.ª entrega)

| | |
|---|---|
| **Universidade** | Universidade Europeia |
| **Faculdade** | IADE — Faculdade de Design, Tecnologia e Comunicação |
| **Curso** | Licenciatura em Engenharia Informática — 2.º ano, 3.º semestre |
| **Ano letivo** | 2026/2027 |
| **Projeto** | Projeto Multidisciplinar Mobile |
| **Grupo** | gXX |
| **Elementos** | [Nome completo] — n.º [00000000]<br>[Nome completo] — n.º [00000000]<br>[Nome completo] — n.º [00000000]<br>[Nome completo] — n.º [00000000] |
| **Repositório GitHub** | https://github.com/[utilizador]/spotted |
| **Data** | 2 de outubro de 2026 |

</div>

## 1. Palavras-chave

Vida noturna · Geolocalização · Check-in por QR Code · Avaliações · Chat por local · Consumo responsável · Estimativa de alcoolemia · Flutter · Node.js · MySQL

## 2. A app e o problema

**Spotted** é uma app móvel para a vida noturna de Lisboa. Mostra num mapa os *spots* de saída (bares, discotecas, rooftops), deixa o utilizador fazer **check-in** no local através de um código QR ou do GPS, **avaliar** o spot e os cocktails, **conversar** com quem está no mesmo sítio e acompanhar a sua noite com um **contador de bebidas** que estima a taxa de álcool no sangue e o avisa quando não deve conduzir.

**O problema.** Hoje, escolher onde sair implica saltar entre várias apps. O Google Maps tem avaliações genéricas, muitas vezes antigas e sem prova de que a pessoa lá esteve. As apps de eventos vendem bilhetes, mas não dizem como está o sítio *agora*. As apps de controlo de consumo existem, mas ninguém as abre a meio da noite. Não há um lugar que junte três perguntas: *onde vale a pena ir hoje?*, *como está o ambiente neste momento?* e *estou em condições de voltar a casa sozinho?*

## 3. Objetivos e motivação

**Motivação.** A noite é um contexto de utilização móvel por excelência: o utilizador está na rua, com pouca luz, com pressa e com o telemóvel na mão. Isso obriga a decisões de interface pouco comuns e a usar várias capacidades do dispositivo (GPS, câmara, mapas, tempo real). Ao mesmo tempo, a componente de consumo responsável dá ao projeto um propósito social. A condução sob o efeito do álcool continua a ser uma das principais causas de sinistralidade grave em Portugal, e uma estimativa visível no momento certo pode mudar uma decisão.

**Objetivos do projeto**

1. Desenvolver uma app Flutter com mapa de spots, check-in verificado (QR/GPS) e avaliações por critério.
2. Implementar um contador de bebidas com estimativa de alcoolemia calculada por métodos numéricos (Matemática Discreta).
3. Criar um chat por spot, acessível apenas a quem fez check-in, com mensagens efémeras.
4. Construir uma API REST em Node.js sobre uma base de dados relacional MySQL, documentada e com dados fictícios coerentes.
5. Validar a usabilidade com utilizadores reais (testes com guiões e avaliação heurística).
6. Cumprir o RGPD desde a conceção: consentimento, minimização de dados, eliminação de conta e restrição a maiores de 18 anos.

## 4. Público-alvo

| Segmento | Descrição | O que procura na Spotted |
|---|---|---|
| **Primário** | Jovens adultos dos 18 aos 30 anos, estudantes e jovens profissionais, que saem à noite em Lisboa pelo menos 2 vezes por mês | Descobrir spots, ver onde há ambiente agora, combinar com o grupo |
| **Secundário** | Turistas e estudantes Erasmus que não conhecem a cidade | Recomendações fiáveis, avaliações verificadas, orientação no mapa |
| **Terciário** | Quem quer controlar o próprio consumo sem uma app "de saúde" | Um contador rápido, sem julgamentos, integrado na noite |

**Proto-personas** (a validar com entrevistas no Sprint 1):

- **Inês, 22 anos, estudante de Design.** Sai às sextas no Bairro Alto com amigas. Escolhe os sítios pelo Instagram e acaba muitas vezes em bares cheios e caros. *Quer saber onde há bom ambiente antes de se deslocar.*
- **Lukas, 24 anos, Erasmus alemão.** Chegou a Lisboa em setembro e não fala português. *Quer avaliações em que possa confiar e falar com quem já está no sítio.*
- **Ricardo, 28 anos, engenheiro.** Vai de carro para o Cais do Sodré. *Quer saber, sem fazer contas, se está em condições de conduzir ou se deve chamar um TVDE.*

## 5. Pesquisa de mercado

| App | O que faz bem | O que falta face à Spotted |
|---|---|---|
| **Google Maps** | Cobertura total, avaliações e horários | Avaliações não verificadas e genéricas; não mostra o ambiente em tempo real; sem chat nem noção de "noite" |
| **XCEED** | Eventos e bilhetes para discotecas em Lisboa, listas VIP, entrada por QR | Focada na venda de bilhetes; sem avaliação de bares nem de bebidas; sem componente de segurança |
| **Untappd** | Check-in e avaliação de bebidas, badges, locais próximos, atalho para transporte | Centrada na bebida e não no spot; não avalia ambiente, música ou serviço; sem chat por local |
| **MyDrinkaware** | Registo de bebidas em unidades e calorias, metas, resumos semanais | Sem componente social; não foi pensada para usar rapidamente durante a noite; sem ligação a locais |
| **DrinkControl** | Registo rápido de bebidas e despesas, histórico, estatísticas | Não estima a evolução da taxa ao longo da noite; sem mapa nem avaliações |

**Posicionamento.** Nenhuma destas apps junta o **local** (onde ir), o **momento** (quem está lá agora) e a **pessoa** (como está a minha noite). A Spotted diferencia-se por três pontos: (1) avaliações **verificadas por check-in**; (2) **chat efémero por spot**, que só existe para quem lá está; (3) consumo responsável **integrado na experiência** e não numa app à parte.

## 6. Guiões de teste (versão preliminar)

### Caso de uso 1 (core) — Descobrir um spot, fazer check-in e avaliá-lo

**Ator:** utilizador registado. **Pré-condições:** sessão iniciada; localização autorizada; o spot tem código QR afixado.

1. O utilizador abre a app e vê o **mapa** centrado na sua posição, com os spots próximos marcados com a respetiva classificação.
2. Filtra por **"Rooftop"** e toca no pin do *Terraço Lua Nova* (4,8 ★, 37 pessoas com check-in).
3. No cartão inferior toca em **"Ver spot"** e consulta a avaliação por critério e os cocktails mais bem avaliados.
4. Já no local, toca em **"Fazer check-in"**. A câmara abre e o utilizador lê o **código QR** do balcão.
5. A app confirma o check-in e valida que o utilizador está a menos de 100 m do spot.
6. Mais tarde, toca em **"Avaliar spot"**, dá estrelas a Ambiente, Música, Preço e Serviço, escreve um comentário e toca em **"Publicar"**.
7. A avaliação aparece no spot com o selo **"Visita verificada"** e a média do spot é recalculada.

**Resultado esperado:** check-in registado e avaliação publicada em menos de 2 minutos, sem ajuda.
**Fluxo alternativo:** sem QR, o utilizador escolhe **"Check-in por GPS"**, que só é aceite se estiver dentro do raio do spot.

### Caso de uso 2 — Registar a noite e consultar a estimativa

**Ator:** utilizador registado com peso e sexo preenchidos no perfil (opcionais, necessários para a estimativa). **Pré-condições:** existe uma noite ativa (é criada automaticamente no primeiro registo).

1. O utilizador abre o separador **"A minha noite"**.
2. Toca em **"Cocktail"** e escolhe *Mojito da Casa* da carta do spot onde fez check-in (o teor alcoólico vem do catálogo).
3. Repete para as bebidas seguintes. Regista também **água**, que não entra no cálculo mas aparece no resumo.
4. A app mostra a **taxa estimada atual**, o gráfico da noite e **a que horas a estimativa desce abaixo de 0,5 g/L**.
5. Com a estimativa acima do limite, surge o aviso **"Não conduzas esta noite"** e o botão **"Pedir transporte para casa"**.
6. No fim, o utilizador toca em **"Terminar noite"** e a noite passa para o histórico do perfil.

**Resultado esperado:** adicionar uma bebida em **no máximo 3 toques**; o aviso aparece sempre que a estimativa for ≥ 0,5 g/L.

### Caso de uso 3 — Conversar no chat do spot e denunciar uma mensagem

**Ator:** utilizador com check-in ativo. **Pré-condições:** check-in feito no spot há menos de 4 horas.

1. No ecrã do spot, o utilizador toca no ícone de **chat**.
2. Vê a indicação *"As mensagens desaparecem às 06:00"* e as mensagens de quem está no spot.
3. Escreve *"Fila no bar de baixo está enorme, o de cima está vazio"* e envia.
4. A mensagem aparece para os outros utilizadores em tempo real.
5. Surge uma mensagem ofensiva. O utilizador faz **toque longo** sobre ela e escolhe **"Denunciar"** e depois **"Bloquear utilizador"**.
6. A mensagem deixa de ser visível para ele e a denúncia fica registada para moderação.

**Resultado esperado:** um utilizador sem check-in **não consegue** abrir o chat; uma denúncia demora menos de 10 segundos a fazer.

## 7. Descrição da solução

### 7.1 Descrição genérica

A Spotted tem quatro módulos: **Descobrir** (mapa, filtros e ficha do spot), **Check-in** (QR/GPS, que desbloqueia avaliações e chat), **A minha noite** (contador de bebidas e estimativa) e **Perfil** (dados pessoais, histórico, privacidade). O âmbito foi dividido por prioridade para caber em dois meses de desenvolvimento:

| Fase | Funcionalidades | Entrega |
|---|---|---|
| **Núcleo** | Registo/login, mapa com filtros, ficha do spot, check-in QR/GPS, avaliação do spot, contador de bebidas com estimativa simples | 2.ª entrega (alfa, 6 nov) |
| **Segunda fase** | Chat do spot em tempo real, avaliação de cocktails, métodos numéricos completos, perfil e histórico, eliminação de conta | 3.ª entrega (11 dez) |
| **Extras** (se houver tempo) | Badges, "spots em alta agora", notificações | — |

### 7.2 Enquadramento nas unidades curriculares

| Unidade curricular | Contributo |
|---|---|
| **Projeto de Desenvolvimento Móvel** | Gestão ágil em sprints de 2 semanas no GitHub Projects, relatórios, arquivo documental, apresentações |
| **Programação de Dispositivos Móveis** | App em Flutter/Dart (mapa, GPS, leitura de QR, gráficos), servidor Node.js REST, arquitetura MVC, Git, documentação REST |
| **Bases de Dados** | Modelo ER e MySQL: utilizadores, spots, check-ins, avaliações, catálogo de bebidas, noites, consumos, mensagens; consultas do tipo "top 5 spots por critério e zona" e "cocktail mais bem avaliado por spot" |
| **Redes e Comunicação de Dados** | Arquitetura cliente-servidor, HTTPS/JSON, autenticação por token, comparação *polling* vs. WebSockets no chat |
| **Interfaces e Usabilidade** | Pesquisa de utilizadores, personas, guia de estilo, mockups Figma, UI para uso noturno (modo escuro, alvos grandes, poucos toques), avaliação heurística e testes |
| **Matemática Discreta** | Modelo de alcoolemia com método de Newton e bisseção, integração numérica e estatística das avaliações (secção 7.3) |

### 7.3 Componente de Matemática Discreta

**Modelo.** A estimativa baseia-se na fórmula de Widmark, com absorção de primeira ordem para cada bebida *i* ingerida no instante *tᵢ*:

$$C(t) = \sum_{i:\,t_i<t} \frac{A_i}{r \cdot W}\left(1 - e^{-k_a (t - t_i)}\right) - \beta\,(t - t_0)$$

onde *Aᵢ* são os gramas de álcool da bebida (volume × teor × 0,789), *W* o peso em kg, *r* o fator de Widmark (≈ 0,68 homens; ≈ 0,55 mulheres), *kₐ* a constante de absorção e *β* ≈ 0,15 g/L/h a taxa de eliminação.

- **Método de Newton** (com **bisseção** como alternativa garantida no intervalo [pico, pico + 8 h]): resolver *C(t) = 0,5* para obter **a hora a partir da qual a estimativa fica abaixo do limite legal**. A equação não é linear por causa dos termos exponenciais, por isso justifica-se um método numérico.
- **Integração numérica** (regra dos trapézios / Simpson): área sob *C(t)*, usada como indicador de exposição total na noite e para comparar noites no histórico.
- **Estatística:** média, desvio-padrão e **média bayesiana** das avaliações, *(C·m + Σ notas)/(C + n)*, para que um spot com uma única avaliação de 5 ★ não fique à frente de um com 200 avaliações de 4,6 ★.

![Exemplo de estimativa: 4 bebidas, homem de 75 kg. Newton e bisseção convergem para 02:38.](img/alcoolemia_exemplo.png)

> A app apresenta sempre o valor como **estimativa**, nunca sugere que o utilizador pode conduzir e mostra o botão de transporte sempre que o valor está acima do limite.

### 7.4 Requisitos funcionais

| ID | Requisito | Prioridade | Fase |
|---|---|---|---|
| RF01 | Registar conta com confirmação de idade ≥ 18 e aceitação da política de privacidade | Must | Núcleo |
| RF02 | Iniciar e terminar sessão (email + palavra-passe) | Must | Núcleo |
| RF03 | Mostrar mapa com spots e posição do utilizador (com consentimento) | Must | Núcleo |
| RF04 | Filtrar spots por tipo, preço, zona e classificação | Must | Núcleo |
| RF05 | Consultar ficha do spot: horário, média por critério, pessoas com check-in | Must | Núcleo |
| RF06 | Fazer check-in por QR Code | Must | Núcleo |
| RF07 | Fazer check-in por GPS dentro de um raio de 100 m | Should | Núcleo |
| RF08 | Avaliar o spot (4 critérios, 1 a 5 ★, comentário) apenas após check-in | Must | Núcleo |
| RF09 | Registar bebidas numa noite a partir de um catálogo | Must | Núcleo |
| RF10 | Calcular e mostrar a estimativa atual e a hora abaixo de 0,5 g/L | Must | Núcleo |
| RF11 | Mostrar aviso "Não conduzas" e atalho para transporte quando ≥ 0,5 g/L | Must | Núcleo |
| RF12 | Chat do spot só para quem tem check-in ativo | Should | Fase 2 |
| RF13 | Apagar automaticamente as mensagens às 06:00 | Should | Fase 2 |
| RF14 | Denunciar mensagens e bloquear utilizadores | Should | Fase 2 |
| RF15 | Avaliar cocktails da carta de um spot e ver o ranking | Should | Fase 2 |
| RF16 | Consultar histórico de noites e spots visitados | Could | Fase 2 |
| RF17 | Exportar e eliminar a conta e todos os dados pessoais | Must | Fase 2 |
| RF18 | Mostrar "spots em alta agora" pelo número de check-ins | Could | Extra |

### 7.5 Requisitos não funcionais

| ID | Categoria | Requisito |
|---|---|---|
| RNF01 | Usabilidade | Modo escuro por omissão, contraste WCAG AA, alvos de toque ≥ 48 dp; adicionar bebida em ≤ 3 toques |
| RNF02 | Desempenho | Mapa com spots carregado em < 2 s em 4G; resposta da API < 500 ms (p95) |
| RNF03 | Segurança | HTTPS; palavras-passe com bcrypt; autenticação JWT com expiração; validação de todas as entradas |
| RNF04 | Privacidade (RGPD) | Consentimento explícito para localização; peso/sexo opcionais; dados de consumo privados e nunca partilhados; direito ao apagamento |
| RNF05 | Arquitetura | MVC no frontend e no backend; API REST; código separado em módulos (models, services, controllers, views) |
| RNF06 | Compatibilidade | Android 8+ e iOS 13+; testado em pelo menos um dispositivo físico |
| RNF07 | Dados | Base de dados MySQL relacional; todos os spots e utilizadores são fictícios |
| RNF08 | Manutenção | Repositório GitHub com README, documentação REST (formato Bocoup) e *commits* frequentes |

### 7.6 Modelo do domínio

![Modelo do domínio (preliminar)](img/dominio.png)

O **CheckIn** é a entidade central: liga o utilizador ao spot e é o que dá acesso à avaliação verificada e ao chat. A **Noite** agrupa os **Consumos** de uma saída e é privada. A **BebidaSpot** representa a carta de cada spot, o que permite avaliar "o Mojito do spot X" e não apenas "o Mojito".

### 7.7 Arquitetura da solução (provisória)

![Arquitetura cliente-servidor](img/arquitetura.png)

A app comunica com o servidor por HTTPS/JSON. O servidor segue MVC (rotas → controladores → modelos/DAO) e acede ao MySQL. O chat usa *polling* na versão alfa e **Socket.io** na versão final. O cálculo da estimativa é feito **no dispositivo** (`BacCalculator`), para que os dados de consumo não precisem de sair do telemóvel para produzir o resultado.

### 7.8 Tecnologias (provisórias)

| Camada | Tecnologias |
|---|---|
| App | Flutter 3 / Dart, `flutter_map` + OpenStreetMap, `geolocator`, `mobile_scanner` (QR), `http`, `provider`, `fl_chart` |
| Servidor | Node.js 20, Express, `mysql2`, `jsonwebtoken`, `bcrypt`, Socket.io |
| Base de dados | MySQL 8, MySQL Workbench |
| Design | Figma (mockups e protótipo), FigJam (fluxos) |
| Gestão | GitHub, GitHub Projects (Kanban por sprint), Postman |

### 7.9 Mockups e interfaces

Mockups de média fidelidade dos ecrãs principais. A versão de alta fidelidade e o protótipo interativo serão feitos no **Figma** no Sprint 1 (ver Anexo A).

<div class="mock-grid">

![Mapa](img/mockup_02_mapa.png)
![Ficha do spot](img/mockup_03_detalhe_spot.png)
![Check-in QR](img/mockup_04_checkin_qr.png)
![A minha noite](img/mockup_06_minha_noite.png)

</div>

**Decisões de interface:** modo escuro para uso noturno e para não encandear; uma barra inferior com 4 separadores; ações principais em botões grandes com a cor de destaque; a informação de segurança usa uma cor própria (laranja), que não se confunde com a cor da marca.

## 8. Planeamento e calendarização

### 8.1 Project Charter

| | |
|---|---|
| **Projeto** | Spotted — app de vida noturna com check-in, avaliações e consumo responsável |
| **Patrocinadores** | Docentes das UC do 3.º semestre de L-EI (IADE) |
| **Gestor de projeto** | [Nome] (rotativo por sprint, se o grupo assim decidir) |
| **Objetivo** | Entregar até 11/12/2026 uma app Flutter funcional, instalada em telemóvel, com API REST e BD MySQL, que cumpra os requisitos Must |
| **Âmbito incluído** | App móvel, API, BD com dados fictícios, documentação, testes de usabilidade, poster, vídeo e apresentação |
| **Fora do âmbito** | Publicação nas lojas, pagamentos, reservas, integração real com TVDE (o botão abre a app externa), painel para donos de bares |
| **Marcos** | 02/10 proposta · 06/11 versão alfa · 11/12 versão final |
| **Pressupostos** | Grupo de 4 elementos com ~8 h/semana cada; acesso a um dispositivo Android físico |
| **Restrições** | Flutter, Node.js, MySQL, Figma e GitHub obrigatórios; dados fictícios; RGPD |
| **Principais riscos** | Âmbito excessivo → priorização MoSCoW e fases · Chat em tempo real complexo → *polling* na alfa · Tema do álcool mal interpretado → foco em consumo responsável · Falta de membros → tarefas em pares |
| **Critério de sucesso** | Os 3 guiões de teste executados com sucesso por utilizadores externos; todos os requisitos Must implementados |

### 8.2 WBS

![Work Breakdown Structure](img/wbs.png)

### 8.3 Plano de trabalhos e distribuição de tarefas

Metodologia ágil (Scrum simplificado): sprints de 2 semanas, *backlog* e quadro Kanban no GitHub Projects, reunião curta semanal e revisão no fim de cada sprint.

| Sprint | Datas | Objetivo | Resultado |
|---|---|---|---|
| S0 | 21/09 – 02/10 | Proposta | Relatório v1, mockups, repositório |
| S1 | 05/10 – 16/10 | Base técnica | Modelo ER, `create.sql`, API de auth e spots, app com login e mapa, Figma alta fidelidade |
| S2 | 19/10 – 30/10 | Núcleo | Check-in, avaliações, "A minha noite", `populate.sql`, `queries.sql` |
| S3 | 02/11 – 06/11 | **Alfa** | Integração, doc REST v1, dicionário de dados, relatório intermédio |
| S4 | 09/11 – 20/11 | Social | Chat Socket.io, avaliação de cocktails, métodos numéricos e estatística |
| S5 | 23/11 – 04/12 | Qualidade | Perfil e RGPD, testes de usabilidade, avaliação heurística, correções |
| S6 | 01/12 – 11/12 | **Final** | Poster, vídeo, slides, manual, relatório final, app no telemóvel |

| Área | Responsável | Apoio |
|---|---|---|
| Gestão, GitHub Projects, relatórios, arquivo | Elemento 1 | Todos |
| UX/UI: pesquisa, personas, Figma, testes | Elemento 2 | Elemento 1 |
| App Flutter | Elemento 3 | Elemento 2 |
| API Node.js e Redes | Elemento 4 | Elemento 3 |
| Base de dados MySQL | Elemento 4 | Elemento 1 |
| Matemática Discreta (modelo e métodos) | Elemento 1 | Elemento 3 |

### 8.4 Gráfico de Gantt

![Gráfico de Gantt](img/gantt.png)

## 9. Conclusão

A Spotted responde a uma necessidade real de quem sai à noite: saber onde ir, como está o sítio agora e se está em condições de voltar para casa. O projeto usa várias capacidades do telemóvel (mapas, GPS, câmara/QR, tempo real) e liga naturalmente todas as unidades curriculares do semestre, com destaque para a aplicação de métodos numéricos a um problema concreto.

**Objetivos a atingir até à versão final:** (1) todos os requisitos *Must* implementados e testados; (2) os três guiões executados com sucesso por utilizadores externos ao grupo; (3) API documentada e BD populada com dados fictícios coerentes; (4) estimativa de alcoolemia validada contra exemplos calculados à mão; (5) app instalada num telemóvel para a apresentação final. O âmbito foi dividido em núcleo, segunda fase e extras para garantir que existe um produto funcional na versão alfa, mesmo que as funcionalidades sociais atrasem.

## 10. Bibliografia

- Universidade Europeia / IADE (2026). *Projeto Mobile — Project Briefing (L-EI), 2026-2027, 3.º semestre.*
- Widmark, E. M. P. (1932). *Die theoretischen Grundlagen und die praktische Verwendbarkeit der gerichtlich-medizinischen Alkoholbestimmung.* Berlin: Urban & Schwarzenberg.
- Burden, R. L., Faires, J. D. & Burden, A. M. (2016). *Numerical Analysis* (10.ª ed.). Cengage Learning.
- Miller, E. (2009). *How Not To Sort By Average Rating.* https://www.evanmiller.org/how-not-to-sort-by-average-rating.html
- Nielsen, J. (1994). *10 Usability Heuristics for User Interface Design.* Nielsen Norman Group.
- Regulamento (UE) 2016/679 — Regulamento Geral sobre a Proteção de Dados (RGPD).
- Código da Estrada, art. 81.º — Condução sob influência de álcool.
- Decreto-Lei n.º 50/2013 — Regime de disponibilização e venda de bebidas alcoólicas (idade mínima de 18 anos).
- Bocoup (2013). *Documenting Your API.* https://bocoup.com/blog/documenting-your-api
- Flutter. *Documentation.* https://docs.flutter.dev · Express. https://expressjs.com · MySQL 8.0 Reference Manual. https://dev.mysql.com/doc · Socket.IO. https://socket.io/docs
- XCEED. https://xceed.me/en/lisboa/events · Untappd. https://untappd.com · MyDrinkaware. https://www.drinkaware.co.uk/tools/mydrinkaware-app · DrinkControl. https://apps.apple.com/app/id456207840

<div class="page-break"></div>

## Anexo A — Mockups (média fidelidade)

![Todos os ecrãs: registo, mapa, ficha do spot, check-in, avaliação, a minha noite, chat](img/mockups_overview.png)

Ficheiros individuais em alta resolução (1560 × 3376 px) em `Documentos/img/` e em `Spotted/02_Imagens/`.
