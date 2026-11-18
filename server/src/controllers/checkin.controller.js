
const Checkin = require('../models/checkin.model');

// Configurações de GPS
const RAIO_GPS = Number(process.env.CHECKIN_GPS_RADIUS_METERS) || 100;
const PRECISAO_MAXIMA = Number(process.env.CHECKIN_GPS_MAX_ACCURACY_METERS) || 100;

// Calcular distância entre duas coordenadas usando Haversine
function calcularDistancia(lat1, lon1, lat2, lon2) {
    const R = 6371000;
    const radianos = valor => valor * Math.PI / 180;

    const dLat = radianos(lat2 - lat1);
    const dLon = radianos(lon2 - lon1);

    const a =
        Math.sin(dLat / 2) ** 2 +
        Math.cos(radianos(lat1)) *
        Math.cos(radianos(lat2)) *
        Math.sin(dLon / 2) ** 2;

    return 2 * R * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

// Check-in através de GPS
exports.gps = async (req, res, next) => {
    try {
        const idSpot = Number(req.body.idSpot);
        const latitude = Number(req.body.latitude);
        const longitude = Number(req.body.longitude);
        const accuracy = Number(req.body.accuracy);

        if (
            !Number.isInteger(idSpot) || idSpot <= 0 ||
            !Number.isFinite(latitude) || latitude < -90 || latitude > 90 ||
            !Number.isFinite(longitude) || longitude < -180 || longitude > 180 ||
            !Number.isFinite(accuracy) || accuracy < 0
        ) {
            return res.status(400).json({
                erro: 'Dados de localização inválidos.'
            });
        }

        if (accuracy > PRECISAO_MAXIMA) {
            return res.status(422).json({
                erro: 'Precisão GPS insuficiente. Tenta obter uma localização mais precisa.'
            });
        }

        const spot = await Checkin.obterSpotPorId(idSpot);

        if (!spot) {
            return res.status(404).json({
                erro: 'Spot não encontrado.'
            });
        }

        const distancia = calcularDistancia(
            latitude,
            longitude,
            Number(spot.latitude),
            Number(spot.longitude)
        );

        if (distancia > RAIO_GPS) {
            return res.status(403).json({
                erro: 'Estás fora da área permitida para fazer check-in.',
                distancia: Math.round(distancia),
                raioPermitido: RAIO_GPS
            });
        }

        const resultado = await Checkin.criar({
            idUtilizador: req.utilizadorId,
            idSpot,
            metodo: 'GPS'
        });

        return res.status(resultado.criado ? 201 : 200).json({
            mensagem: resultado.criado
                ? 'Check-in GPS realizado com sucesso.'
                : 'Já tens um check-in ativo neste Spot.',
            idCheckin: resultado.idCheckin,
            metodo: 'GPS'
        });

    } catch (error) {
        next(error);
    }
};

// Check-in através de QR Code
exports.qr = async (req, res, next) => {
    try {
        const codigoQR = typeof req.body.codigoQR === 'string'
            ? req.body.codigoQR.trim()
            : '';

        if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(codigoQR)) {
            return res.status(400).json({
                erro: 'Código QR inválido.'
            });
        }

        const spot = await Checkin.obterSpotPorCodigoQR(codigoQR);

        if (!spot) {
            return res.status(404).json({
                erro: 'Código QR não reconhecido.'
            });
        }

        const resultado = await Checkin.criar({
            idUtilizador: req.utilizadorId,
            idSpot: spot.id,
            metodo: 'QR'
        });

        return res.status(resultado.criado ? 201 : 200).json({
            mensagem: resultado.criado
                ? 'Check-in QR realizado com sucesso.'
                : 'Já tens um check-in ativo neste Spot.',
            idCheckin: resultado.idCheckin,
            metodo: 'QR'
        });

    } catch (error) {
        next(error);
    }
};

// Consultar check-ins ativos do utilizador autenticado
exports.listarAtivos = async (req, res, next) => {
    try {
        const checkins = await Checkin.listarAtivos(req.utilizadorId);
        res.json(checkins);
    } catch (error) {
        next(error);
    }
};

// Terminar check-in
exports.checkout = async (req, res, next) => {
    try {
        const idCheckin = Number(req.params.id);

        if (!Number.isInteger(idCheckin) || idCheckin <= 0) {
            return res.status(400).json({
                erro: 'Identificador de check-in inválido.'
            });
        }

        const terminado = await Checkin.terminar(
            idCheckin,
            req.utilizadorId
        );

        if (!terminado) {
            return res.status(404).json({
                erro: 'Check-in ativo não encontrado.'
            });
        }

        res.json({
            mensagem: 'Checkout realizado com sucesso.'
        });

    } catch (error) {
        next(error);
    }
};
