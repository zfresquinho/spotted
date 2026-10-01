# Spotted — Documentação da API REST

Formato: [Bocoup — Documenting your API](https://bocoup.com/blog/documenting-your-api).
URL base (desenvolvimento): `http://localhost:3000/api`
Todas as respostas são JSON em UTF-8. Erros têm a forma `{ "erro": "mensagem" }`.

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
* **Resposta de erro:** não aplicável (se a BD falhar, `baseDeDados` indica o motivo)
* **Exemplo de chamada:** `curl http://localhost:3000/api/health`
* **Notas:** usado para testar a ligação a partir da app.

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

## Endpoints planeados

| Método | URL | Descrição | Sprint |
|---|---|---|---|
| POST | `/auth/registo` | Criar conta (≥ 18 anos, RGPD) | S1 |
| POST | `/auth/login` | Iniciar sessão, devolve JWT | S1 |
| POST | `/checkins` | Check-in por QR (`codigoQr`) ou GPS (`latitude`, `longitude`) | S2 |
| POST | `/spots/:id/avaliacoes` | Avaliar spot (exige check-in) | S2 |
| GET | `/bebidas` | Catálogo de bebidas | S2 |
| POST | `/noites/atual/consumos` | Registar bebida na noite ativa | S2 |
| GET | `/spots/:id/mensagens` | Mensagens do chat (exige check-in ativo) | S4 |
| POST | `/mensagens/:id/denuncias` | Denunciar mensagem | S4 |
| DELETE | `/utilizadores/me` | Apagar conta e dados (RGPD) | S5 |
