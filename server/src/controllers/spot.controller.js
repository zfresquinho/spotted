// Controller: valida o pedido, chama o model e formata a resposta
const Spot = require('../models/spot.model');

exports.listar = async (req, res, next) => {
  try {
    const zona = req.query.zona ? Number(req.query.zona) : null;
    res.json(await Spot.listar({ zona }));
  } catch (e) { next(e); }
};

exports.obter = async (req, res, next) => {
  try {
    const spot = await Spot.obterPorId(Number(req.params.id));
    if (!spot) return res.status(404).json({ erro: 'Spot não encontrado' });
    res.json(spot);
  } catch (e) { next(e); }
};
