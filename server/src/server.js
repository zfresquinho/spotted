// Ponto de entrada: arranca o servidor HTTP (e, mais tarde, o Socket.io do chat)
require('dotenv').config();
const http = require('http');
const app = require('./app');

const PORT = process.env.PORT || 3000;
const server = http.createServer(app);

// TODO Sprint 4: ligar Socket.io para o chat do spot
// const { Server } = require('socket.io');
// const io = new Server(server, { cors: { origin: '*' } });

server.listen(PORT, () => {
  console.log(`Spotted API a correr em http://localhost:${PORT}/api/health`);
});
