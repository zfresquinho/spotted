const bcrypt = require('bcrypt');  
const Utilizador = require('../models/utilizador.model.js');

function calcularIdade(dataNascimento) {
    const hoje = new Date();
    const nascimento = new Date(dataNascimento);
    let idade = hoje.getFullYear() - nascimento.getFullYear();
    const menoridade = hoje.getMonth() < nascimento.getMonth() || (hoje.getMonth() === nascimento.getMonth() && hoje.getDate() < nascimento.getDate()); // se o dia de hoje for menor que o dia de anos nao passa ou se o mes de hoje for menor q o mes de aniversario e o dia de hoje é menor q o dia de aniversario entao a idade perde um ano. 
    if (menoridade) {
        idade--;
    }
    return idade;
}

exports.registar = async (req, res, next) => {
    try {
        const { nome, email, password, data_nascimento, aceitou_rgpd } = req.body;
        console.log('Recebido:', req.body);
        if (!nome || !email || !password || !data_nascimento || !aceitou_rgpd) {
            return res.status(400).json({ message: 'Faltam prencher campos obrigatórios.' });
        }
        if (!email.includes('@') || !email.includes('.')) {
            return res.status(400).json({ message: 'Email inválido.' });
        }
        if (password.length < 8) {
            return res.status(400).json({ message: 'A password deve ter pelo menos 8 caracteres.' });
        }
        if (isNaN(new Date(data_nascimento).getTime())) {
            return res.status(400).json({ message: 'Data de nascimento inválida.' });
        }
        if (calcularIdade(data_nascimento) < 18) {
            return res.status(400).json({ message: 'É necessário ter pelo menos 18 anos para se registar.' });
        }
        if (aceitou_rgpd !== true) {
            return res.status(400).json({ message: 'É necessário aceitar os termos de privacidade.' });
        }
        if (await Utilizador.obteremail(email)) {
            return res.status(400).json({ message: 'Email já registado.' });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const id = await Utilizador.criarutilizador(nome, email, hashedPassword, data_nascimento, aceitou_rgpd);
        res.status(201).json({ message: 'Utilizador registado com sucesso.', id });
    } catch (error) {
        next(error);
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: 'Faltam preencher campos obrigatórios.' });
        }
        const utilizador = await Utilizador.obterutilizador(email);
        if (!utilizador) {
            return res.status(401).json({ message: 'Credenciais inválidas.' });
        }
        const passwordMatch = await bcrypt.compare(password, utilizador.password_hash);
        if (!passwordMatch) {
            return res.status(401).json({ message: 'Credenciais inválidas.' });
        }
        const id = utilizador.id_utilizador; // Assuming the user object has an id_utilizador property
        res.status(200).json({ message: 'Login bem-sucedido.', id });    
    } catch (error) {
        next(error);

    }
}