const router = require('express').Router();
const spotController = require('../controllers/spot.controller');

router.get('/', spotController.listar);       // GET /api/spots?zona=2
router.get('/:id', spotController.obter);     // GET /api/spots/1

module.exports = router;
