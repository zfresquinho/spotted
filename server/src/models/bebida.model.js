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

