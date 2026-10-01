// Configuração da aplicação Express (separada do server.js para facilitar testes)
const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health.routes');
const spotRoutes = require('./routes/spot.routes');

const app = express();
app.use(cors());
app.use(express.json());

// Rotas — cada recurso tem routes → controller → model
app.use('/api/health', healthRoutes);
app.use('/api/spots', spotRoutes);
// TODO Sprint 1: /api/auth   (registo, login)
// TODO Sprint 2: /api/checkins, /api/avaliacoes, /api/noites
// TODO Sprint 4: /api/mensagens

// 404 para rotas desconhecidas
app.use((req, res) => res.status(404).json({ erro: 'Recurso não encontrado' }));

// Tratamento de erros centralizado
app.use((err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).json({ erro: err.message || 'Erro interno' });
});

module.exports = app;
