const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
    const [tipo, token] = (req.headers.authorization || "").split(" ");
    if (tipo !== "Bearer" || !token){
        return res.status(401).json({message: "sessao em falta" });
    }
    try {
        const dados = jwt.verify(token, process.env.JWT_SECRET);
        req.utilizadorId = dados.id;
        next();
    }catch (e){
        res.status(401).json({message: "Sessão em falta ou expirada."});
    }
};