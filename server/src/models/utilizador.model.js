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