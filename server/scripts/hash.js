// Gera um hash bcrypt para colocar no populate.sql
// Uso: npm run hash -- "Spotted2026!"
const bcrypt = require('bcrypt');
const pwd = process.argv[2];
if (!pwd) { console.error('Uso: npm run hash -- <palavra-passe>'); process.exit(1); }
bcrypt.hash(pwd, 10).then((h) => console.log(h));
