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
  return rows[0] || null;
};
