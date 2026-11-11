const db = require('../config/db');


exports.obteremail = async (email) => {
    const [rows] = await db.query(
        'SELECT id_utilizador FROM utilizador WHERE email = ?',
         [email]
    ); 
    return rows[0] || null;
};

exports.criarutilizador = async (nome, email, passwordHash, datanascimento) => {
    const [resultado] = await db.query(
        'INSERT INTO utilizador (nome, email, password_hash, data_nascimento, aceitou_rgpd_em) VALUES (?, ?, ?, ?,  NOW())',
        [nome, email, passwordHash, datanascimento]
    );
    return resultado.insertId;
};

exports.obterutilizador = async (email, password) => {
    const [rows] = await db.query(
        'SELECT id_utilizador, password_hash FROM utilizador WHERE email = ?',
        [email]
    );
    return rows[0] || null;
};


exports.obterPerfil = async (id) => {
    const [rows] = await db.query(
         `SELECT peso_kg AS pesoKg, sexo
         FROM utilizador
         WHERE id_utilizador = ?`,
        [id]
    );
    return rows[0] || null;
};


exports.adicionarpeso = async (id, pesoKg) => {
    const [resultados] = await db.query(
        'UPDATE utilizador SET peso_kg = ? WHERE id_utilizador = ?',
        [pesoKg, id]
    );
    return resultados.affectedRows > 0;
};

exports.adicionarsexo = async (id, sexo) => {
    const [resultado] =await db.query (
        'UPDATE utilizador SET sexo = ? WHERE id_utilizador = ?',
        [sexo, id]
    )
    return resultado.affectedRows > 0;
}

