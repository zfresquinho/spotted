# Problemas conhecidos

Lista de problemas encontrados durante o desenvolvimento e ainda por resolver. Atualizado a 5 de novembro de 2026.

Quando um problema for resolvido, mover para a secção **Resolvidos** com a data e o commit.

## A minha noite

| # | Problema | Onde | Impacto | Correção proposta | Prioridade |
|---|---|---|---|---|---|
| N1 | A hora "abaixo de 0,5 g/L" mostra só hora e minutos, sem o dia | `noite_screen.dart` | Com taxas altas a hora real pode ser dias depois (ex.: 15 g/L → segunda-feira às 20:08) e o ecrã sugere que é daqui a uma hora. Perigoso numa app sobre condução | Se a hora não for hoje, mostrar também o dia (ex.: "seg. 9/11 às 20:08") | Alta |
| N2 | Tocar num botão de bebida não dá feedback | `noite_screen.dart`, `bebida_botton_widget.dart` | O utilizador toca várias vezes; num teste ficaram 21 Caipirinhas registadas em 4 segundos | Mostrar a lista de bebidas da noite e um SnackBar após cada registo | Alta |
| N3 | Não é possível apagar um consumo registado por engano | Servidor e app | Um toque a mais fica na estimativa para sempre | Rota `DELETE /api/noites/atual/consumos/:id` e gesto de apagar na lista | Média |
| N4 | Não há limite para valores absurdos | `bac_calculador.dart` | A app mostra taxas impossíveis (ex.: 15 g/L) sem aviso | Avisar quando a estimativa ultrapassa um valor plausível | Baixa |
| N5 | Cada botão regista sempre a primeira bebida da categoria por ordem alfabética | `bebida_botton_widget.dart` | Cerveja regista sempre Caneca (500 ml), nunca Imperial; afeta a estimativa | Deixar escolher a bebida dentro da categoria | Média |
| N6 | O ecrã não se atualiza com o tempo | `noite_screen.dart` | A taxa só muda quando o ecrã se redesenha | `Timer.periodic` de 1 minuto no `State`, cancelado no `dispose` | Média |
| N7 | Não há forma de terminar a noite | Servidor e app | A noite fica ativa para sempre; bebidas de dias diferentes entram na mesma noite | Rota e botão "Terminar noite" (`terminada_em = NOW()`) | Média |
| N8 | Modelo simples desconta eliminação mesmo quando a taxa já estava a zero | `bac_calculador.dart` | Com bebidas muito espaçadas a taxa é subestimada | Fase 2: absorção gradual e simulação passo a passo (Newton/bisseção para a hora) | Média |
| N9 | `serie()` usa `?? DateTime.now()` | `bac_calculador.dart:67` | Não é usado na prática, mas torna a função dependente do relógio | Trocar por `?? t0` | Baixa |

## Registo e autenticação

| # | Problema | Onde | Impacto | Correção proposta | Prioridade |
|---|---|---|---|---|---|
| A2 | A validação de email aceita `@.` | `register_widget.dart`, `auth.controller.js` | Contas com emails inválidos (já existe uma: utilizador 5) | Validar com expressão regular nos dois lados | Média |
| A4 | O registo não pede peso nem sexo | `register_widget.dart` | Contas novas não têm estimativa de alcoolemia | Pedir no registo ou no ecrã de perfil | Média |

## Outros

| # | Problema | Onde | Impacto | Correção proposta | Prioridade |
|---|---|---|---|---|---|
| O2 | O filtro de preço só vai até 3 | `filtros_widget.dart:35` | Spots de nível 4 nunca são selecionáveis | Acrescentar o nível 4 | Baixa |
| O3 | O `AndroidManifest.xml` principal não declara permissões | `app/android/app/src/main/` | Em Android: sem GPS e sem acesso ao servidor por HTTP | Declarar localização, internet e tráfego local | Média |

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
