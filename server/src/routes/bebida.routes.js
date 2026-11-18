const router =require ('express').Router();
const authController = require('../controllers/bebida.controller.js');


router.get("/", authController.listar);

module.exports = router;