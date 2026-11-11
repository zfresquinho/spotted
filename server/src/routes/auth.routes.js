const router =require ('express').Router();
const authController = require('../controllers/auth.controller.js');

const token = require('../middleware/auth.middleware.js')

router.post('/registar', authController.registar);

router.post('/login', authController.login);

router.put("/peso", token, authController.adicionarpeso);

router.put("/sexo", token, authController.adicionarsexo);

router.get("/perfil", token, authController.obterPerfil);

module.exports = router;