const router =require ('express').Router();
const noitecontroller = require('../controllers/noite.controller.js');
const auth = require("../middleware/auth.middleware.js");



router.post("/atual/consumos", auth, noitecontroller.registarConsumo);

router.get("/atual", auth, noitecontroller.obterConsumos);

module.exports = router;