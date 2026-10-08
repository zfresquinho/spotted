const router =require ('express').Router();
const authController = require('../controllers/auth.controller.js');

router.post('/registar', authController.registar);

module.exports = router;