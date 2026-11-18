
// Configuração da aplicação Express
const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health.routes');
const spotRoutes = require('./routes/spot.routes');
const checkinRoutes = require('./routes/checkin.routes');
const authRoutes = require('./routes/auth.routes'); // Importar as rotas de autenticação
const bebidasRoutes = require("./routes/bebida.routes");
const noiteroutes = require("./routes/noite.routes");

const app = express();

// Configuração CORS para desenvolvimento Flutter Web
const corsOptions = {
  
  origin: /^http:\/\/localhost:\d+$/,
  
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};

app.use(cors(corsOptions));
app.use(express.json());

// Rotas — cada recurso tem routes → controller → model
// TODO Sprint 1: /api/auth   (registo, login)

app.use('/api/auth', authRoutes); // Usar as rotas de autenticação

app.use('/api/spots', spotRoutes); // Usar as rotas de spots

app.use('/api/health', healthRoutes); // Usar as rotas de health

app.use("/api/bebidas", bebidasRoutes);

// TODO Sprint 2: /api/checkins, /api/avaliacoes, /api/noites

app.use('/api/checkins', checkinRoutes);

app.use("/api/noites", noiteroutes);

// TODO Sprint 4: /api/mensagens

// 404 para rotas desconhecidas
app.use((req, res) => {
  res.status(404).json({
    erro: 'Recurso não encontrado',
  });
});

// Tratamento centralizado de erros
app.use((err, req, res, next) => {
  console.error(err);

  res.status(err.status || 500).json({
    erro: err.message || 'Erro interno',
  });
});

module.exports = app;
