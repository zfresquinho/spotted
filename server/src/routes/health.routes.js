const router = require('express').Router();
const db = require('../config/db');

// GET /api/health — confirma que a API está viva e se a BD responde
router.get('/', async (req, res) => {
  let baseDeDados = 'ok';
  try {
    await db.query('SELECT 1');
  } catch (e) {
    baseDeDados = `indisponível (${e.code || e.message})`;
  }
  res.json({ estado: 'ok', servico: 'spotted-api', baseDeDados });
});

module.exports = router;
