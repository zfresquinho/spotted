
const router = require('express').Router();

const checkinController = require('../controllers/checkin.controller');
const authMiddleware = require('../middleware/auth.middleware');

// Todas as rotas exigem autenticação JWT
router.use(authMiddleware);

// Check-in por GPS
router.post('/gps', checkinController.gps);

// Check-in por QR Code
router.post('/qr', checkinController.qr);

// Consultar check-ins ativos
router.get('/ativos', checkinController.listarAtivos);

// Terminar check-in
router.post('/:id/checkout', checkinController.checkout);

module.exports = router;
