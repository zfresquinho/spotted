
// Model: operações SQL relacionadas com os check-ins
const db = require('../config/db');

// Procurar um Spot pelo seu identificador
exports.obterSpotPorId = async (idSpot) => {
    const [rows] = await db.query(
        `SELECT id_spot AS id, latitude, longitude
         FROM spot
         WHERE id_spot = ?`,
        [idSpot]
    );

    return rows[0] || null;
};

// Procurar um Spot através do código QR
exports.obterSpotPorCodigoQR = async (codigoQR) => {
    const [rows] = await db.query(
        `SELECT id_spot AS id, latitude, longitude
         FROM spot
         WHERE codigo_qr = ?`,
        [codigoQR]
    );

    return rows[0] || null;
};

// Consultar check-in ativo de um utilizador num Spot
exports.obterAtivo = async (idUtilizador, idSpot) => {
    const [rows] = await db.query(
        `SELECT id_checkin, id_utilizador, id_spot,
                metodo, feito_em, terminado_em
         FROM checkin
         WHERE id_utilizador = ?
           AND id_spot = ?
           AND terminado_em IS NULL
           AND feito_em >= NOW() - INTERVAL 4 HOUR
         ORDER BY feito_em DESC
         LIMIT 1`,
        [idUtilizador, idSpot]
    );

    return rows[0] || null;
};

// Criar check-in, evitando duplicações concorrentes
exports.criar = async ({ idUtilizador, idSpot, metodo }) => {
    if (!['GPS', 'QR'].includes(metodo)) {
        throw Object.assign(
            new Error('Método de check-in inválido.'),
            { status: 400 }
        );
    }

    const connection = await db.getConnection();

    try {
        await connection.beginTransaction();

        // Bloquear temporariamente o registo do utilizador
        const [utilizadores] = await connection.query(
            `SELECT id_utilizador
             FROM utilizador
             WHERE id_utilizador = ?
             FOR UPDATE`,
            [idUtilizador]
        );

        if (utilizadores.length === 0) {
            throw Object.assign(
                new Error('Utilizador não encontrado.'),
                { status: 404 }
            );
        }

        // Verificar se já existe um check-in ativo no mesmo Spot
        const [ativos] = await connection.query(
            `SELECT id_checkin
             FROM checkin
             WHERE id_utilizador = ?
               AND id_spot = ?
               AND terminado_em IS NULL
               AND feito_em >= NOW() - INTERVAL 4 HOUR
             LIMIT 1`,
            [idUtilizador, idSpot]
        );

        if (ativos.length > 0) {
            await connection.commit();

            return {
                criado: false,
                idCheckin: ativos[0].id_checkin
            };
        }

        const [resultado] = await connection.query(
            `INSERT INTO checkin
                (id_utilizador, id_spot, metodo)
             VALUES (?, ?, ?)`,
            [idUtilizador, idSpot, metodo]
        );

        await connection.commit();

        return {
            criado: true,
            idCheckin: resultado.insertId
        };

    } catch (error) {
        await connection.rollback();
        throw error;

    } finally {
        connection.release();
    }
};

// Listar todos os check-ins ativos de um utilizador
exports.listarAtivos = async (idUtilizador) => {
    const [rows] = await db.query(
        `SELECT
            c.id_checkin,
            c.id_spot,
            c.metodo,
            c.feito_em,
            s.nome AS spot_nome
         FROM checkin c
         JOIN spot s ON s.id_spot = c.id_spot
         WHERE c.id_utilizador = ?
           AND c.terminado_em IS NULL
           AND c.feito_em >= NOW() - INTERVAL 4 HOUR
         ORDER BY c.feito_em DESC`,
        [idUtilizador]
    );

    return rows;
};

// Terminar um check-in pertencente ao utilizador autenticado
exports.terminar = async (idCheckin, idUtilizador) => {
    const [resultado] = await db.query(
        `UPDATE checkin
         SET terminado_em = CURRENT_TIMESTAMP
         WHERE id_checkin = ?
           AND id_utilizador = ?
           AND terminado_em IS NULL`,
        [idCheckin, idUtilizador]
    );

    return resultado.affectedRows > 0;
};
