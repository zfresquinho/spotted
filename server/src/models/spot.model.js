// Model: único sítio onde se escreve SQL para a entidade Spot
const db = require('../config/db');

const BASE = `
  SELECT s.id_spot AS id, s.nome, s.descricao, s.morada,
         s.latitude, s.longitude, s.nivel_preco AS nivelPreco,
         s.hora_abertura AS horaAbertura, s.hora_fecho AS horaFecho,
         z.nome AS zona, t.nome AS tipo,
         ROUND(AVG((a.ambiente + a.musica + a.preco + a.servico) / 4), 2) AS media,
         COUNT(a.id_avaliacao) AS nAvaliacoes
  FROM spot s
  JOIN zona z ON z.id_zona = s.id_zona
  JOIN tipo_spot t ON t.id_tipo = s.id_tipo
  LEFT JOIN checkin c ON c.id_spot = s.id_spot
  LEFT JOIN avaliacao_spot a ON a.id_checkin = c.id_checkin`;

const GROUP = ' GROUP BY s.id_spot, z.nome, t.nome';

exports.listar = async ({ zona }) => {
  const sql = BASE + (zona ? ' WHERE s.id_zona = ?' : '') + GROUP + ' ORDER BY s.nome';
  const [rows] = await db.query(sql, zona ? [zona] : []);
  return rows;
};

exports.obterPorId = async (id) => {
  const [rows] = await db.query(BASE + ' WHERE s.id_spot = ?' + GROUP, [id]);
  const spot = rows[0];
  if(!spot) return null;
  const [detalhe] = await db.query(`
    SELECT ROUND(AVG(a.ambiente), 1) AS mediaAmbiente,
           ROUND(AVG(a.musica), 1)   AS mediaMusica,
           ROUND(AVG(a.preco), 1)    AS mediaPreco,
           ROUND(AVG(a.servico), 1)  AS mediaServico,
           (SELECT COUNT(*) FROM checkin c2
             WHERE c2.id_spot = ?
               AND c2.terminado_em IS NULL
               AND c2.feito_em > NOW() - INTERVAL 4 HOUR) AS pessoasAgora
    FROM checkin c
    LEFT JOIN avaliacao_spot a ON a.id_checkin = c.id_checkin
    WHERE c.id_spot = ?`, [id, id]);

    const [cocktails] = await db.query(`
  SELECT COALESCE(bs.nome_na_carta, b.nome) AS nome,
         ROUND(AVG(ab.nota), 1)              AS media
  FROM bebida_spot bs
  JOIN bebida b            ON b.id_bebida = bs.id_bebida
  JOIN avaliacao_bebida ab ON ab.id_bebida_spot = bs.id_bebida_spot
  WHERE bs.id_spot = ?
  GROUP BY bs.id_bebida_spot, nome
  ORDER BY media DESC
  LIMIT 3`, [id]);

  return  {...spot, ...detalhe[0], cocktails };
};
