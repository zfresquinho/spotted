-- =============================================================
-- Spotted — pesquisas relevantes (ilustram o uso da BD na app)
-- Uso: mysql -u root -p spotted < database/queries.sql
-- =============================================================
USE spotted;
SET NAMES utf8mb4;

-- Q1. Spots de uma zona com média global e n.º de avaliações (mapa / lista)
SELECT s.id_spot, s.nome, t.nome AS tipo, s.nivel_preco,
       ROUND(AVG((a.ambiente + a.musica + a.preco + a.servico) / 4), 2) AS media,
       COUNT(a.id_avaliacao) AS n_avaliacoes
FROM spot s
JOIN tipo_spot t        ON t.id_tipo = s.id_tipo
LEFT JOIN checkin c     ON c.id_spot = s.id_spot
LEFT JOIN avaliacao_spot a ON a.id_checkin = c.id_checkin
WHERE s.id_zona = 2
GROUP BY s.id_spot, s.nome, t.nome, s.nivel_preco
ORDER BY media DESC;

-- Q2. Top 5 spots por média bayesiana (C = 5 avaliações, m = média global)
WITH notas AS (
  SELECT c.id_spot, (a.ambiente + a.musica + a.preco + a.servico) / 4 AS nota
  FROM avaliacao_spot a JOIN checkin c ON c.id_checkin = a.id_checkin
), global AS (SELECT AVG(nota) AS m FROM notas)
SELECT s.nome,
       COUNT(n.nota) AS n,
       ROUND((5 * g.m + SUM(n.nota)) / (5 + COUNT(n.nota)), 2) AS media_bayesiana
FROM spot s JOIN notas n ON n.id_spot = s.id_spot CROSS JOIN global g
GROUP BY s.id_spot, s.nome, g.m
ORDER BY media_bayesiana DESC
LIMIT 5;

-- Q3. Pessoas com check-in nas últimas 4 horas por spot ("quem está lá agora")
SELECT s.nome, COUNT(DISTINCT c.id_utilizador) AS pessoas_agora
FROM spot s
JOIN checkin c ON c.id_spot = s.id_spot
WHERE c.feito_em >= NOW() - INTERVAL 4 HOUR
GROUP BY s.id_spot, s.nome
ORDER BY pessoas_agora DESC;

-- Q4. Cocktail mais bem avaliado em cada spot
SELECT nome_spot, bebida, media FROM (
  SELECT s.nome AS nome_spot,
         COALESCE(bs.nome_na_carta, b.nome) AS bebida,
         ROUND(AVG(ab.nota), 2) AS media,
         RANK() OVER (PARTITION BY s.id_spot ORDER BY AVG(ab.nota) DESC) AS pos
  FROM avaliacao_bebida ab
  JOIN bebida_spot bs ON bs.id_bebida_spot = ab.id_bebida_spot
  JOIN bebida b       ON b.id_bebida = bs.id_bebida
  JOIN spot s         ON s.id_spot = bs.id_spot
  WHERE b.categoria = 'Cocktail'
  GROUP BY s.id_spot, s.nome, bs.id_bebida_spot, bebida
) r WHERE pos = 1;

-- Q5. Gramas de álcool por consumo numa noite (entrada do cálculo de Widmark na app)
SELECT c.consumido_em, b.nome, b.volume_ml, b.teor_alcool,
       ROUND(b.volume_ml * b.teor_alcool / 100 * 0.789, 1) AS gramas_alcool
FROM consumo c JOIN bebida b ON b.id_bebida = c.id_bebida
WHERE c.id_noite = 1
ORDER BY c.consumido_em;

-- Q6. O utilizador tem check-in ativo no spot? (controlo de acesso ao chat)
SELECT EXISTS (
  SELECT 1 FROM checkin
  WHERE id_utilizador = 1 AND id_spot = 1 AND feito_em >= NOW() - INTERVAL 4 HOUR
) AS pode_entrar_no_chat;

-- Q7. Limpeza das mensagens expiradas (corre às 06:00 no servidor)
-- DELETE FROM mensagem WHERE enviada_em < CURDATE() + INTERVAL 6 HOUR;
