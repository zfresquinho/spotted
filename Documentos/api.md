# Spotted — Documentação da API REST

Formato: [Bocoup — Documenting your API](https://bocoup.com/blog/documenting-your-api).
URL base (desenvolvimento): `http://localhost:3000/api`
Todas as respostas são JSON em UTF-8.

**Erros:** a maior parte dos endpoints devolve `{ "erro": "mensagem" }`. Os endpoints de autenticação, de noite e o middleware de sessão ainda devolvem `{ "message": "mensagem" }` (ver [Notas gerais](#notas-gerais)).

**Autenticação:** os endpoints marcados com 🔒 exigem o cabeçalho
`Authorization: Bearer <token>`, com o token devolvido pelo login. Sem token, ou com um token inválido ou expirado, a resposta é:

* **Código:** 401 — `{ "message": "sessao em falta" }` (sem cabeçalho) ou `{ "message": "Sessão em falta ou expirada." }` (token inválido)

## Índice

| Método | URL | Descrição | 🔒 |
|---|---|---|---|
| GET | `/health` | Estado da API e da BD | |
| POST | `/auth/registar` | Criar conta | |
| POST | `/auth/login` | Iniciar sessão (devolve JWT) | |
| GET | `/spots` | Listar spots | |
| GET | `/spots/:id` | Obter um spot | |
| GET | `/bebidas` | Catálogo de bebidas | |
| POST | `/checkins/gps` | Check-in por GPS | 🔒 |
| POST | `/checkins/qr` | Check-in por código QR | 🔒 |
| GET | `/checkins/ativos` | Check-ins ativos do utilizador | 🔒 |
| POST | `/checkins/:id/checkout` | Terminar um check-in | 🔒 |
| GET | `/noites/atual` | Noite ativa com consumos | 🔒 |
| POST | `/noites/atual/consumos` | Registar uma bebida na noite ativa | 🔒 |

---

## Estado da API

Confirma que o servidor está a correr e se a base de dados responde.

* **URL:** `/health`
* **Método:** `GET`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200
  * **Conteúdo:** `{ "estado": "ok", "servico": "spotted-api", "baseDeDados": "ok" }`
* **Resposta de erro:** não aplicável (se a BD falhar, `baseDeDados` indica o motivo, ex.: `"indisponível (ECONNREFUSED)"`)
* **Exemplo de chamada:** `curl http://localhost:3000/api/health`
* **Notas:** usado para testar a ligação a partir da app.

---

## Criar conta

Regista um novo utilizador. Só são aceites maiores de 18 anos que aceitem os termos de privacidade (RGPD).

* **URL:** `/auth/registar`
* **Método:** `POST`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:**
  * Obrigatórios:
    * `nome=[texto]`
    * `email=[texto]`
    * `password=[texto]` — mínimo 8 caracteres
    * `data_nascimento=[data AAAA-MM-DD]` — idade ≥ 18
    * `aceitou_rgpd=[booleano]` — tem de ser `true`
  ```json
  {
    "nome": "Ana Silva",
    "email": "ana@exemplo.pt",
    "password": "segredo123",
    "data_nascimento": "2000-05-14",
    "aceitou_rgpd": true
  }
  ```
* **Resposta de sucesso:**
  * **Código:** 201
  * **Conteúdo:** `{ "message": "Utilizador registado com sucesso.", "id": 7 }`
* **Resposta de erro:**
  * **Código:** 400 — `{ "message": "Faltam prencher campos obrigatórios." }`
  * **Código:** 400 — `{ "message": "Email inválido." }`
  * **Código:** 400 — `{ "message": "A password deve ter pelo menos 8 caracteres." }`
  * **Código:** 400 — `{ "message": "Data de nascimento inválida." }`
  * **Código:** 400 — `{ "message": "É necessário ter pelo menos 18 anos para se registar." }`
  * **Código:** 400 — `{ "message": "É necessário aceitar os termos de privacidade." }`
  * **Código:** 400 — `{ "message": "Email já registado." }`
* **Exemplo de chamada:**
  ```bash
  curl -X POST http://localhost:3000/api/auth/registar \
    -H "Content-Type: application/json" \
    -d '{"nome":"Ana Silva","email":"ana@exemplo.pt","password":"segredo123","data_nascimento":"2000-05-14","aceitou_rgpd":true}'
  ```
* **Notas:** a password é guardada com bcrypt (custo 10). A data de aceitação do RGPD fica em `aceitou_rgpd_em`. O registo não pede peso nem sexo, por isso a estimativa de alcoolemia não funciona em contas novas (ver `problemas-conhecidos.md`, A4).

---

## Iniciar sessão

Valida as credenciais e devolve um JWT para usar nos endpoints 🔒.

* **URL:** `/auth/login`
* **Método:** `POST`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:**
  * Obrigatórios: `email=[texto]`, `password=[texto]`
  ```json
  { "email": "ana@exemplo.pt", "password": "segredo123" }
  ```
* **Resposta de sucesso:**
  * **Código:** 200
  * **Conteúdo:** `{ "message": "Login bem-sucedido", "id": 7, "token": "eyJhbGciOi…" }`
* **Resposta de erro:**
  * **Código:** 400 — `{ "message": "Faltam preencher campos obrigatórios." }`
  * **Código:** 401 — `{ "message": "Credenciais inválidas." }` (email inexistente ou password errada; a mensagem é a mesma de propósito)
* **Exemplo de chamada:**
  ```bash
  curl -X POST http://localhost:3000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"ana@exemplo.pt","password":"segredo123"}'
  ```
* **Notas:** o token contém `{ id }` e a validade é definida por `JWT_EXPIRES_IN` no `.env`. A app guarda-o em `SharedPreferences`.

---

## Listar spots

Devolve todos os spots, com média das avaliações, opcionalmente filtrados por zona.

* **URL:** `/spots`
* **Método:** `GET`
* **Parâmetros de URL:**
  * Opcionais: `zona=[inteiro]` — id da zona
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200
  * **Conteúdo:**
    ```json
    [
      {
        "id": 1, "nome": "Terraço Lua Nova", "descricao": "Rooftop com vista…",
        "morada": "Rua Fictícia do Alecrim, 12",
        "latitude": 38.7089, "longitude": -9.1433, "nivelPreco": 3,
        "horaAbertura": "18:00:00", "horaFecho": "02:00:00",
        "zona": "Cais do Sodré", "tipo": "Rooftop", "media": 4, "nAvaliacoes": 2
      }
    ]
    ```
* **Resposta de erro:**
  * **Código:** 500 — `{ "erro": "…" }`
* **Exemplo de chamada:** `curl "http://localhost:3000/api/spots?zona=2"`
* **Notas:** `media` é `null` quando o spot ainda não tem avaliações.

---

## Obter um spot

* **URL:** `/spots/:id`
* **Método:** `GET`
* **Parâmetros de URL:**
  * Obrigatórios: `id=[inteiro]`
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200 — um objeto com os mesmos campos da lista
* **Resposta de erro:**
  * **Código:** 404 — `{ "erro": "Spot não encontrado" }`
* **Exemplo de chamada:** `curl http://localhost:3000/api/spots/1`

---

## Catálogo de bebidas

Devolve todas as bebidas, ordenadas por categoria e nome. Usado pelo contador de "A minha noite".

* **URL:** `/bebidas`
* **Método:** `GET`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200
  * **Conteúdo:**
    ```json
    [
      { "id": 1, "nome": "Imperial", "categoria": "Cerveja", "volumeMl": 200, "teorAlcool": 5.0 },
      { "id": 4, "nome": "Mojito", "categoria": "Cocktail", "volumeMl": 250, "teorAlcool": 10.0 }
    ]
    ```
* **Resposta de erro:**
  * **Código:** 500 — `{ "erro": "…" }`
* **Exemplo de chamada:** `curl http://localhost:3000/api/bebidas`
* **Notas:** `categoria` é uma de `Cerveja`, `Vinho`, `Cocktail`, `Shot`, `Destilado`, `Sem alcool`. `teorAlcool` está em % vol.

---

## Check-in por GPS 🔒

Faz check-in num spot se o utilizador estiver dentro do raio permitido.

* **URL:** `/checkins/gps`
* **Método:** `POST`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:**
  * Obrigatórios:
    * `idSpot=[inteiro > 0]`
    * `latitude=[número entre -90 e 90]`
    * `longitude=[número entre -180 e 180]`
    * `accuracy=[número ≥ 0]` — precisão do GPS em metros
  ```json
  { "idSpot": 1, "latitude": 38.70892, "longitude": -9.14331, "accuracy": 12 }
  ```
* **Resposta de sucesso:**
  * **Código:** 201 — `{ "mensagem": "Check-in GPS realizado com sucesso.", "idCheckin": 15, "metodo": "GPS" }`
  * **Código:** 200 — `{ "mensagem": "Já tens um check-in ativo neste Spot.", "idCheckin": 15, "metodo": "GPS" }`
* **Resposta de erro:**
  * **Código:** 400 — `{ "erro": "Dados de localização inválidos." }`
  * **Código:** 401 — sessão em falta ou expirada
  * **Código:** 403 — `{ "erro": "Estás fora da área permitida para fazer check-in.", "distancia": 340, "raioPermitido": 100 }`
  * **Código:** 404 — `{ "erro": "Spot não encontrado." }`
  * **Código:** 422 — `{ "erro": "Precisão GPS insuficiente. Tenta obter uma localização mais precisa." }`
* **Exemplo de chamada:**
  ```bash
  curl -X POST http://localhost:3000/api/checkins/gps \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d '{"idSpot":1,"latitude":38.70892,"longitude":-9.14331,"accuracy":12}'
  ```
* **Notas:** a distância é calculada com a fórmula de Haversine. O raio (`CHECKIN_GPS_RADIUS_METERS`) e a precisão máxima (`CHECKIN_GPS_MAX_ACCURACY_METERS`) vêm do `.env` e valem 100 m por omissão. Um check-in conta como ativo durante 4 horas ou até ser feito o checkout. O utilizador pode ter check-ins ativos em vários spots ao mesmo tempo, mas não dois no mesmo spot (a criação usa uma transação com `FOR UPDATE` para evitar duplicados).

---

## Check-in por QR 🔒

Faz check-in no spot cujo código QR foi lido.

* **URL:** `/checkins/qr`
* **Método:** `POST`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:**
  * Obrigatórios: `codigoQR=[UUID]`
  ```json
  { "codigoQR": "7c1e4b2a-0001-4a1b-9c00-000000000001" }
  ```
* **Resposta de sucesso:**
  * **Código:** 201 — `{ "mensagem": "Check-in QR realizado com sucesso.", "idCheckin": 16, "metodo": "QR" }`
  * **Código:** 200 — `{ "mensagem": "Já tens um check-in ativo neste Spot.", "idCheckin": 16, "metodo": "QR" }`
* **Resposta de erro:**
  * **Código:** 400 — `{ "erro": "Código QR inválido." }` (não é um UUID)
  * **Código:** 401 — sessão em falta ou expirada
  * **Código:** 404 — `{ "erro": "Código QR não reconhecido." }`
* **Exemplo de chamada:**
  ```bash
  curl -X POST http://localhost:3000/api/checkins/qr \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d '{"codigoQR":"7c1e4b2a-0001-4a1b-9c00-000000000001"}'
  ```
* **Notas:** cada spot tem um UUID único na coluna `codigo_qr`, que é o conteúdo do QR afixado no local.

---

## Check-ins ativos 🔒

Lista os check-ins ativos do utilizador autenticado (sem checkout e feitos há menos de 4 horas), do mais recente para o mais antigo.

* **URL:** `/checkins/ativos`
* **Método:** `GET`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200
  * **Conteúdo:**
    ```json
    [
      {
        "id_checkin": 16, "id_spot": 1, "metodo": "QR",
        "feito_em": "2026-11-07 23:10:00", "spot_nome": "Terraço Lua Nova"
      }
    ]
    ```
* **Resposta de erro:**
  * **Código:** 401 — sessão em falta ou expirada
* **Exemplo de chamada:** `curl -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/checkins/ativos`
* **Notas:** devolve `[]` quando não há check-ins ativos. Os campos vêm em `snake_case`, ao contrário dos outros endpoints.

---

## Terminar check-in 🔒

Faz checkout de um check-in ativo do próprio utilizador.

* **URL:** `/checkins/:id/checkout`
* **Método:** `POST`
* **Parâmetros de URL:**
  * Obrigatórios: `id=[inteiro > 0]` — id do check-in
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200 — `{ "mensagem": "Checkout realizado com sucesso." }`
* **Resposta de erro:**
  * **Código:** 400 — `{ "erro": "Identificador de check-in inválido." }`
  * **Código:** 401 — sessão em falta ou expirada
  * **Código:** 404 — `{ "erro": "Check-in ativo não encontrado." }` (não existe, já terminou ou é de outro utilizador)
* **Exemplo de chamada:** `curl -X POST -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/checkins/16/checkout`

---

## Noite ativa 🔒

Devolve a noite ativa do utilizador, as bebidas registadas e o peso e o sexo do perfil. A app usa estes dados para calcular a estimativa de alcoolemia (Widmark).

* **URL:** `/noites/atual`
* **Método:** `GET`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:** nenhum
* **Resposta de sucesso:**
  * **Código:** 200
  * **Conteúdo:**
    ```json
    {
      "id": 3,
      "iniciadaEm": "2026-11-07 22:30:00",
      "pesoKg": 70,
      "sexo": "F",
      "consumos": [
        {
          "id": 21, "consumidoEm": "2026-11-07 22:31:05",
          "idBebida": 4, "nome": "Mojito", "categoria": "Cocktail",
          "volumeMl": 250, "teorAlcool": 10.0
        }
      ]
    }
    ```
* **Resposta de erro:**
  * **Código:** 401 — sessão em falta ou expirada
  * **Código:** 404 — `{ "message": "Perfil não encontrado" }`
* **Exemplo de chamada:** `curl -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/noites/atual`
* **Notas:** sem noite ativa, responde 200 com `id` e `iniciadaEm` a `null` e `consumos: []`. `pesoKg` e `sexo` podem vir a `null`; nesse caso a app não mostra estimativa.

---

## Registar consumo 🔒

Regista uma bebida na noite ativa. Se o utilizador ainda não tiver noite ativa, é criada uma automaticamente.

* **URL:** `/noites/atual/consumos`
* **Método:** `POST`
* **Parâmetros de URL:** nenhum
* **Parâmetros de dados:**
  * Obrigatórios: `idBebida=[inteiro > 0]`
  ```json
  { "idBebida": 4 }
  ```
* **Resposta de sucesso:**
  * **Código:** 201
  * **Conteúdo:**
    ```json
    {
      "id": 22, "consumidoEm": "2026-11-07 23:02:40",
      "idBebida": 4, "nome": "Mojito", "categoria": "Cocktail",
      "volumeMl": 250, "teorAlcool": 10.0
    }
    ```
* **Resposta de erro:**
  * **Código:** 400 — `{ "message": "idBebida inválido" }`
  * **Código:** 401 — sessão em falta ou expirada
  * **Código:** 404 — `{ "message": "Bebida não encontrada" }`
* **Exemplo de chamada:**
  ```bash
  curl -X POST http://localhost:3000/api/noites/atual/consumos \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d '{"idBebida":4}'
  ```
* **Notas:** a hora do consumo é a do servidor (`NOW()`). O consumo ainda não fica associado ao spot do check-in (`consumo.id_spot` fica a `NULL`).

---

## Notas gerais

* **Rotas desconhecidas:** qualquer URL que não exista devolve 404 `{ "erro": "Recurso não encontrado" }`.
* **Erros internos:** são tratados num middleware central, que devolve `{ "erro": "<mensagem>" }` com o código do erro ou 500.
* **Tipos:** os decimais (latitude, teor alcoólico, peso…) chegam como número (`decimalNumbers`) e as datas como texto `"AAAA-MM-DD HH:MM:SS"` na hora do servidor, sem fuso (`dateStrings`).
* **CORS:** em desenvolvimento só está autorizada a origem `http://localhost:8080` (Flutter Web).
* **Inconsistências conhecidas:** os endpoints `/auth/*`, `/noites/*` e o middleware de sessão usam a chave `message` nos erros, e os restantes usam `erro`. A mensagem de sucesso também alterna entre `message` e `mensagem`. `/checkins/ativos` devolve campos em `snake_case`. Fica para uniformizar numa próxima versão.

---

## Endpoints planeados

| Método | URL | Descrição | Sprint |
|---|---|---|---|
| POST | `/spots/:id/avaliacoes` | Avaliar spot (exige check-in) | S4 |
| POST | `/noites/atual/terminar` | Terminar a noite ativa | S4 |
| GET | `/spots/:id/mensagens` | Mensagens do chat (exige check-in ativo) | S4 |
| POST | `/mensagens/:id/denuncias` | Denunciar mensagem | S4 |
| GET | `/utilizadores/me` | Ver perfil | S5 |
| PATCH | `/utilizadores/me` | Atualizar peso e sexo | S5 |
| GET | `/noites` | Histórico de noites terminadas | S5 |
| DELETE | `/utilizadores/me` | Apagar conta e dados (RGPD) | S5 |
