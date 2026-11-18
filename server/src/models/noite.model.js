const db = require("../config/db");

exports.obterAtiva = async (id_utilizador) => {
    const [rows] = await db.query(
        `SELECT id_noite AS id, id_utilizador AS idUtilizador, iniciada_em AS dataInicio, terminada_em AS dataFim
         FROM noite
         WHERE id_utilizador = ? AND terminada_em IS NULL`,
        [id_utilizador]
    );
    return rows[0]; // Retorna a primeira noite ativa encontrada ou undefined se não houver nenhuma
};


exports.criarNoite = async (id_utilizador) => {
    const [resultado] = await db.query(
        `INSERT INTO noite (id_utilizador, iniciada_em) VALUES (?, NOW())`,
        [id_utilizador]
    );
    return resultado.insertId; // Retorna o ID da nova noite criada
};

exports.adicionarConsumo = async (id_noite, id_bebida, quantidade) => {
    const [resultado] = await db.query(
        `INSERT INTO consumo (id_noite, id_bebida, consumido_em) VALUES (?, ?, NOW())`,
        [id_noite, id_bebida]
    );
    return resultado.insertId; // Retorna o ID do novo consumo criado
};

exports.obterConsumos = async (id_noite) => {
    const [rows] = await db.query(
        `SELECT c.id_consumo   AS id,
       c.consumido_em AS consumidoEm,
       b.id_bebida    AS idBebida,
       b.nome,
       b.categoria,
       b.volume_ml    AS volumeMl,
       b.teor_alcool  AS teorAlcool
FROM consumo c
JOIN bebida b ON b.id_bebida = c.id_bebida
WHERE c.id_noite = ?
ORDER BY c.consumido_em`,
        [id_noite]
    );
    return rows; // Retorna todos os consumos da noite especificada
};

exports.obterConsumo = async (id) => {
    const [rows] = await db.query(
        `SELECT c.id_consumo   AS id,
       c.consumido_em AS consumidoEm,
       b.id_bebida    AS idBebida,
       b.nome,
       b.categoria,
       b.volume_ml    AS volumeMl,
       b.teor_alcool  AS teorAlcool
FROM consumo c
JOIN bebida b ON b.id_bebida = c.id_bebida
WHERE c.id_consumo = ?`,
        [id]
    );
    return rows[0] || null; // Retorna o primeiro consumo da noite especificada ou null se não houver nenhum
};