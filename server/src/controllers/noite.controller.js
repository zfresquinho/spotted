const Noite = require("../models/noite.model.js");
const Bebida = require("../models/bebida.model.js");
const Utilizador = require("../models/utilizador.model.js");



exports.registarConsumo = async (req, res, next) => {
    try{
        const idBebida = Number(req.body?.idBebida);
        if(!Number.isInteger(idBebida) || idBebida <= 0){
            return res.status(400).json({message: "idBebida inválido"});
        }
        const bebida = await Bebida.obterporId(idBebida);
        if(!bebida){
            return res.status(404).json({message: "Bebida não encontrada"});
        }
        const noite = await Noite.obterAtiva(req.utilizadorId);
        const idNoite = noite ? noite.id : await Noite.criarNoite(req.utilizadorId);

        const idConsumo = await Noite.adicionarConsumo(idNoite, idBebida);
        const consumo = await Noite.obterConsumo(idConsumo);
        res.status(201).json(consumo);
    }catch (e){
        next(e);
    }
    };

    exports.obterConsumos = async (req, res, next) => {
        try{
            const noite = await Noite.obterAtiva(req.utilizadorId);
            const perfil = await Utilizador.obterPerfil(req.utilizadorId);
            if(!perfil){
                return res.status(404).json({message: "Perfil não encontrado"});
            }
            if(!noite){
                return res.json({id: null, iniciadaEm: null, pesoKg: perfil.pesoKg, sexo: perfil.sexo, consumos: []});
            }
            const consumos = await Noite.obterConsumos(noite.id);
            res.status(200).json({id: noite.id, iniciadaEm: noite.dataInicio, pesoKg: perfil.pesoKg, sexo: perfil.sexo, consumos});
        }catch (e){
            next(e);
        }
    };

    

