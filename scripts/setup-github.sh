#!/usr/bin/env bash
# =============================================================
# Spotted — configuração inicial do GitHub (correr UMA vez)
#
# Pré-requisitos:
#   1. GitHub CLI instalado: https://cli.github.com
#   2. gh auth login               (escolher GitHub.com > HTTPS)
#   3. gh auth refresh -s project  (permissão para criar o quadro do Projects)
#
# Uso (na raiz do repositório):
#   bash scripts/setup-github.sh
# =============================================================
set -euo pipefail

# Trabalhar sempre na raiz do repositório (a pasta acima de scripts/), venha de onde vier
cd "$(dirname "$0")/.."
if [ ! -f README.md ] || [ ! -d Spotted ]; then
  echo "❌ Não encontro a pasta do projeto. Corre o script de dentro da pasta 'spotted'."; exit 1
fi
echo "Pasta do projeto: $(pwd)"

# O Git precisa de nome e email para fazer commits
if [ -z "$(git config user.name || true)" ] || [ -z "$(git config user.email || true)" ]; then
  echo "❌ Falta configurar o Git. Corre (com os teus dados):"
  echo '   git config --global user.name "Nome Apelido"'
  echo '   git config --global user.email "email-da-conta-github@exemplo.pt"'
  exit 1
fi

REPO_NAME="spotted"
VISIBILITY="public"   # "private" se preferirem; nesse caso adicionem os docentes como colaboradores

# ---------- 1. Repositório e branches ----------
[ -d .git ] || git init -b main
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git add .
  git commit -m "Estrutura inicial do repositório"
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --"$VISIBILITY" --source=. --remote=origin --push \
    --description "Spotted — app de vida noturna em Lisboa (Projeto Mobile, IADE 2026/2027)"
else
  git push -u origin main
fi

git branch dev 2>/dev/null || true
git push -u origin dev

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
OWNER=${REPO%%/*}
echo "Repositório: https://github.com/$REPO"

# ---------- 2. Etiquetas ----------
label() { gh label create "$1" --color "$2" --description "$3" --repo "$REPO" --force >/dev/null; }
label "app"            "02569B" "App Flutter"
label "servidor"       "3C873A" "API Node.js"
label "base-de-dados"  "F29111" "MySQL, modelo ER, SQL"
label "design"         "B57BFF" "UX/UI, Figma, testes de usabilidade"
label "documentacao"   "0E8A16" "Relatórios, arquivo, README, API"
label "matematica"     "5319E7" "Matemática Discreta"
label "redes"          "1D76DB" "Redes e Comunicação de Dados"
label "gestao"         "BFD4F2" "Gestão de projeto"
label "must"           "B60205" "Prioridade MoSCoW: Must"
label "should"         "D93F0B" "Prioridade MoSCoW: Should"
label "could"          "FBCA04" "Prioridade MoSCoW: Could"
echo "Etiquetas criadas."

# ---------- 3. Sprints (marcos) ----------
milestone() {
  gh api "repos/$REPO/milestones" -f title="$1" -f due_on="$2T23:59:00Z" -f description="$3" >/dev/null 2>&1 \
    || echo "  (marco '$1' já existia)"
}
milestone "S0 — Proposta"       "2026-10-02" "1.ª entrega: proposta, mockups, repositório"
milestone "S1 — Base técnica"   "2026-10-16" "Modelo ER, auth, app com login e mapa"
milestone "S2 — Núcleo"         "2026-10-30" "Check-in, avaliações, A minha noite"
milestone "S3 — Alfa"           "2026-11-06" "2.ª entrega: integração, doc REST, relatório intermédio"
milestone "S4 — Social"         "2026-11-20" "Chat, avaliação de cocktails, métodos numéricos"
milestone "S5 — Qualidade"      "2026-12-04" "RGPD, testes de usabilidade, correções"
milestone "S6 — Final"          "2026-12-11" "3.ª entrega: poster, vídeo, slides, manual, relatório final"
echo "Sprints criados."

# ---------- 4. Issues iniciais ----------
issue() {  # título | etiquetas | sprint | corpo
  gh issue create --repo "$REPO" --title "$1" --label "$2" --milestone "$3" --body "$4" >/dev/null
  echo "  + $1"
}

echo "A criar issues…"
S0="S0 — Proposta"
issue "Preencher nomes, números e n.º do grupo (README, info.md, proposta)" "documentacao,gestao,must" "$S0" \
"Substituir todos os [Nome completo], [00000000] e gXX. Renomear os ficheiros gXX-* para o n.º do grupo."
issue "Exportar proposta v1 para PDF e entregar no Canvas" "documentacao,must" "$S0" \
"Nome obrigatório: gNN-proposta-v1.pdf. Pôr o PDF em Documentos/ e confirmar o link no README e o link do repositório na capa."
issue "Mockups no Figma e link no README" "design,must" "$S0" \
"Ecrãs: registo, mapa, ficha do spot, check-in QR, avaliação, A minha noite, chat."
issue "Configurar o quadro do GitHub Projects e ligar ao README" "gestao,must" "$S0" \
"Colunas Todo / In Progress / Done; campo Sprint; adicionar todas as issues."
issue "Pitch da proposta" "gestao,documentacao,must" "$S0" "Preparar a apresentação curta da proposta."

S1="S1 — Base técnica"
issue "Modelo ER final e dicionário de dados" "base-de-dados,documentacao,must" "$S1" \
"Desenhar no MySQL Workbench a partir de database/create.sql. Exportar imagem para Spotted/04_Documentacao_Tecnica."
issue "Rever create.sql e alargar populate.sql" "base-de-dados,must" "$S1" \
"Meta: ~20 spots, ~30 utilizadores, ~200 check-ins, todos fictícios."
issue "API: registo e login com JWT (RF01, RF02)" "servidor,must" "$S1" \
"POST /auth/registo (validar ≥ 18 anos e RGPD, bcrypt) e POST /auth/login (devolve JWT). Middleware de autenticação. Documentar em Documentos/api.md."
issue "App: gerar plataformas e correr no emulador" "app,must" "$S1" \
"Seguir app/README.md (flutter create .). Confirmar que a lista de spots aparece com a API local."
issue "App: ecrãs de registo e login" "app,must" "$S1" "Ligados à API; guardar o token."
issue "App: mapa com spots e posição do utilizador (RF03)" "app,must" "$S1" \
"flutter_map + OpenStreetMap + geolocator. Pedir consentimento de localização."
issue "App: filtros de spots por tipo, preço e zona (RF04)" "app,must" "$S1" ""
issue "Figma alta fidelidade e guia de estilo" "design,must" "$S1" "Modo escuro, alvos ≥ 48 dp, cor de segurança separada da cor da marca."
issue "Entrevistas para validar as personas (3 a 5)" "design,should" "$S1" \
"Guião e notas em Spotted/06_Dados_Investigacao; autorizações em 07_Autorizacoes."
issue "Diagrama de arquitetura e de classes (UML)" "documentacao,redes,must" "$S1" \
"Guardar em Spotted/04_Documentacao_Tecnica."

# ---------- 5. Quadro do GitHub Projects ----------
if gh project create --owner "$OWNER" --title "Spotted" --format json >/tmp/spotted_project.json 2>/dev/null; then
  PNUM=$(grep -o '"number":[0-9]*' /tmp/spotted_project.json | head -1 | cut -d: -f2)
  gh project link "$PNUM" --owner "$OWNER" --repo "$REPO" >/dev/null || true
  for n in $(gh issue list --repo "$REPO" --limit 100 --json number -q '.[].number'); do
    gh project item-add "$PNUM" --owner "$OWNER" --url "https://github.com/$REPO/issues/$n" >/dev/null
  done
  echo "Quadro do Projects: https://github.com/users/$OWNER/projects/$PNUM"
else
  echo "⚠ Não foi possível criar o quadro. Corram 'gh auth refresh -s project' e voltem a correr só esta parte, ou criem-no à mão."
fi

echo
echo "✅ Feito. Falta à mão:"
echo "  - Settings > Collaborators: adicionar os colegas (e os docentes, se o repositório for privado)"
echo "  - Settings > Branches: proteger 'main' (exigir pull request)"
echo "  - Pôr os links do repositório, do Figma e do Projects no README"
