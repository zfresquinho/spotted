const bebida = require("../models/bebida.model");


exports.listar = async (req, res, next) => {
try{
res.json(await bebida.listar());
} catch (e) {next (e) };
};