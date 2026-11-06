
// Configuração da aplicação Express
const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health.routes');
const spotRoutes = require('./routes/spot.routes');
const authRoutes = require('./routes/auth.routes');
const bebidasRoutes = require('./routes/bebida.routes');
const checkinRoutes = require('./routes/checkin.routes');

const app = express();

// Configuração CORS para desenvolvimento Flutter Web
const corsOptions = {
  origin: [
    'http://localhost:8080',
    
  ],
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
};

app.use(cors(corsOptions));
app.use(express.json());

// Rotas da API
app.use('/api/auth', authRoutes);
app.use('/api/spots', spotRoutes);
app.use('/api/health', healthRoutes);
app.use('/api/bebidas', bebidasRoutes);
app.use('/api/checkins', checkinRoutes);

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
