# Problemas conhecidos

Lista de problemas encontrados durante o desenvolvimento e ainda por resolver. Atualizado a 5 de novembro de 2026.

Quando um problema for resolvido, mover para a secção **Resolvidos** com a data e o commit.

## A minha noite

| # | Problema | Onde | Impacto | Correção proposta | Prioridade |
|---|---|---|---|---|---|
| N3 | Não é possível apagar um consumo registado por engano | Servidor e app | Um toque a mais fica na estimativa para sempre | Rota `DELETE /api/noites/atual/consumos/:id` e gesto de apagar na lista | Média |
| N4 | Não há limite para valores absurdos | `bac_calculador.dart` | A app mostra taxas impossíveis (ex.: 15 g/L) sem aviso | Avisar quando a estimativa ultrapassa um valor plausível | Baixa |
| N5 | Cada botão regista sempre a primeira bebida da categoria por ordem alfabética | `bebida_botton_widget.dart` | Cerveja regista sempre Caneca (500 ml), nunca Imperial; afeta a estimativa | Deixar escolher a bebida dentro da categoria | Média |
| N7 | Não há forma de terminar a noite | Servidor e app | A noite fica ativa para sempre; bebidas de dias diferentes entram na mesma noite | Rota e botão "Terminar noite" (`terminada_em = NOW()`) | Média |
| N8 | Modelo simples desconta eliminação mesmo quando a taxa já estava a zero | `bac_calculador.dart` | Com bebidas muito espaçadas a taxa é subestimada | Fase 2: absorção gradual e simulação passo a passo (Newton/bisseção para a hora) | Média |

## Registo e autenticação

| # | Problema | Onde | Impacto | Correção proposta | Prioridade |
|---|---|---|---|---|---|
| A2 | A validação de email aceita `@.` | `register_widget.dart`, `auth.controller.js` | Contas com emails inválidos (já existe uma: utilizador 5) | Validar com expressão regular nos dois lados | Média |
| A4 | O registo não pede peso nem sexo | `register_widget.dart` | Contas novas não têm estimativa de alcoolemia | Pedir no registo ou no ecrã de perfil | Média |

## Outros

| # | Problema | Onde | Impacto | Correção proposta | Prioridade |
|---|---|---|---|---|---|

## Dados de teste a limpar

- Noite 3 do utilizador 5 (`@.`) com 25 Caipirinhas. Fechar com `UPDATE noite SET terminada_em = NOW() WHERE id_noite = 3;`
- Noite 2 da Inês com os consumos dos testes da API (Mojito e Água).

## Resolvidos

| # | Problema | Data | Commit |
|---|---|---|---|
| A1 | O servidor escreve o corpo do registo na consola | 08/11/2026 | já corrigido antes |
| A3 | A confirmação da palavra-passe não é comparada | 08/11/2026 | 7123720 |
| A5 | Após o registo a app não muda para o login | 08/11/2026 | 7123720 |
| O1 | O teste de widget não compila | 08/11/2026 | já corrigido antes |
| O4 | `api.md` desatualizado | 08/11/2026 | ea4ab84 |
| N1 | A hora "abaixo de 0,5 g/L" mostra só hora e minutos, sem o dia | 08/11/2026 | 5aada8e |
| N2 | Tocar num botão de bebida não dá feedback | 08/11/2026 | ba84ba2 |
| N6 | O ecrã não se atualiza com o tempo | 08/11/2026 | 5aada8e |
| N9 | `serie()` usa `?? DateTime.now()` | 08/11/2026 | 5aada8e |
| O2 | O filtro de preço só vai até 3 | 08/11/2026 | 86c764c |
| O3 | O `AndroidManifest.xml` principal não declara permissões | 08/11/2026 | ebff853 |
