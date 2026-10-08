// Configuração da aplicação Express (separada do server.js para facilitar testes)
const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health.routes');
const spotRoutes = require('./routes/spot.routes');
const authRoutes = require('./routes/auth.routes'); // Importar as rotas de autenticação

const app = express();
app.use(cors());
app.use(express.json());

// Rotas — cada recurso tem routes → controller → model
// TODO Sprint 1: /api/auth   (registo, login)

app.use('/api/auth', authRoutes); // Usar as rotas de autenticação

app.use('/api/spots', spotRoutes); // Usar as rotas de spots

app.use('/api/health', healthRoutes); // Usar as rotas de health

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
