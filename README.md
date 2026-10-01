# Spotted

**Descobre o spot, junta-te à noite, volta bem a casa.**

App móvel de vida noturna em Lisboa: mapa de *spots* (bares, discotecas, rooftops), check-in por QR Code ou GPS, avaliações verificadas, chat efémero por spot, avaliação de cocktails e contador de bebidas com estimativa de alcoolemia para consumo responsável.

> Projeto Multidisciplinar Mobile — Licenciatura em Engenharia Informática, 2.º ano, 3.º semestre
> IADE — Faculdade de Design, Tecnologia e Comunicação · Universidade Europeia · 2026/2027

---

## 📄 Documentação

| Documento | Entrega | Markdown | PDF |
|---|---|---|---|
| Proposta inicial (v1) | 02/10/2026 | [gXX-proposta-v1.md](Documentos/gXX-proposta-v1.md) | [gXX-proposta-v1.pdf](Documentos/gXX-proposta-v1.pdf) |
| Proposta (v2), se existir | 06/11/2026 | — | — |
| Relatório intermédio | 06/11/2026 | — | — |
| Relatório final | 11/12/2026 | — | — |
| Documentação REST | 06/11/2026 | [api.md](Documentos/api.md) | — |
| Manual do utilizador | 11/12/2026 | — | — |

- 📁 [Memória e arquivo documental](Spotted/) (estrutura obrigatória do ponto 9.2.3 do briefing) · [guia do arquivo](Documentos/guia-arquivo.md)
- 🎨 Figma: *[link a adicionar]*
- 📋 GitHub Projects: *[link a adicionar]*

## 👥 Equipa — grupo gXX

| Nome | N.º de estudante | Área principal |
|---|---|---|
| [Nome completo] | [00000000] | Gestão de projeto, Matemática Discreta |
| [Nome completo] | [00000000] | UX/UI e usabilidade |
| [Nome completo] | [00000000] | App Flutter |
| [Nome completo] | [00000000] | API Node.js, Redes e Base de Dados |

## 🧱 Estrutura do repositório

```
spotted/
├── app/            # App Flutter (Dart) — MVC
├── server/         # API REST Node.js + Express — MVC
├── database/       # create.sql, populate.sql, queries.sql
├── Documentos/     # Propostas, relatórios (md + pdf), documentação REST
├── Spotted/        # Memória e arquivo documental (estrutura obrigatória)
├── scripts/        # setup-github.sh (configuração inicial do GitHub)
└── .github/        # Modelos de issues e pull requests
```

## 🛠️ Tecnologias

| Camada | Tecnologias |
|---|---|
| App | Flutter 3 / Dart, flutter_map + OpenStreetMap, geolocator, mobile_scanner, http, provider, fl_chart |
| Servidor | Node.js 20, Express, mysql2, jsonwebtoken, bcrypt, Socket.io |
| Base de dados | MySQL 8 |
| Design | Figma, FigJam |
| Gestão | GitHub, GitHub Projects, Postman |

## 🚀 Como executar

### Base de dados
```bash
mysql -u root -p < database/create.sql
mysql -u root -p spotted < database/populate.sql
```

### Servidor
```bash
cd server
cp .env.example .env      # preencher credenciais
npm install
npm run dev               # http://localhost:3000/api/health
```

### App
```bash
cd app
flutter create . --project-name spotted --org pt.iade.spotted --platforms android,ios   # só na 1.ª vez
flutter pub get
flutter run
```
Mais detalhes (emulador vs. telemóvel, HTTP no Android) em [app/README.md](app/README.md).

### Utilizadores de teste
`ines@exemplo.pt`, `lukas@exemplo.pt`, `ricardo@exemplo.pt` — palavra-passe `Spotted2026!`

## 🔀 Convenções de trabalho

- **Branches:** `main` (estável, só por pull request) · `dev` (integração) · `feature/<n.º-issue>-descricao` (ex.: `feature/12-checkin-qr`)
- **Commits:** em português, no imperativo, com o n.º da issue — ex.: `Adiciona ecrã de check-in por QR (#12)`
- **Issues:** cada tarefa do GitHub Projects é uma issue com responsável, sprint e etiqueta
- **Pull requests:** revistos por pelo menos um colega antes de entrar em `dev`

## 📅 Marcos

| Marco | Data |
|---|---|
| 1.ª entrega — Proposta | 02/10/2026 |
| 2.ª entrega — Versão alfa | 06/11/2026 |
| 3.ª entrega — Versão final | 11/12/2026 |

---

*Todos os spots, utilizadores e dados usados na app são fictícios. A estimativa de alcoolemia é apenas indicativa e nunca deve ser usada para decidir conduzir.*
