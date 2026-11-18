const db = require("../config/db");

exports.listar = async () => {
    const [rows] = await db.query (
        `SELECT id_bebida AS id, nome, categoria,
            volume_ml AS volumeMl, teor_alcool AS teorAlcool
     FROM bebida
     ORDER BY categoria, nome` 
    )
    return rows;
};


exports.obterporId = async (id) => {
    const [rows] = await db.query(
        `SELECT id_bebida AS id, nome, categoria,
            volume_ml AS volumeMl, teor_alcool AS teorAlcool
         FROM bebida
         WHERE id_bebida = ?`,
        [id]
    );
    return rows[0] || null; // Retorna a primeira bebida encontrada ou null se não houver nenhuma
};
