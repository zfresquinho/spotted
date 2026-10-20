import 'package:flutter/material.dart';
import "../../services/api_service.dart";
import '../../utils/tema.dart';

class RegisterSpotted extends StatefulWidget {
  const RegisterSpotted({super.key});

  @override
  State<RegisterSpotted> createState() => _RegisterSpottedState();
}

class _RegisterSpottedState extends State<RegisterSpotted> {
  bool aceitarTermos = false;
  DateTime? datenacimento;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();


      int calculateage(DateTime? datenacimento) {
        if (datenacimento == null) return 0;
        final today = DateTime.now();
        int age = today.year - datenacimento.year;
        if (today.month < datenacimento.month ||
            (today.month == datenacimento.month && today.day < datenacimento.day)) {
          age--;
        }
        return age;
      }

  void dataNascimento() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != datenacimento) {
      setState(() {
        datenacimento = picked;
      });
    }
  
  }
    Future<void> submeter() async {
      if (formKey.currentState!.validate())  {
        final String email = emailController.text.trim();

        if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email inválido.')),
          );
          return;
        }
        if (datenacimento == null || datenacimento!.isAfter(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data de nascimento inválida.')),
          );
          return;
        }
        if (calculateage(datenacimento) < 18) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('É necessário ter pelo menos 18 anos.')),
          );
          return;
        }
        if (!aceitarTermos) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('É necessário aceitar os termos.')),
          );
          return;
        }
      }
      final erro = await ApiService().registar(
        nome: nomeController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        datenacimento: datenacimento!,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text( erro  ?? 'A submeter...')),
      );
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Tema.fundo,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 72, 28, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo: "spott" branco + "ed" rosa
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: 'spott'),
                      TextSpan(text: 'ed', style: TextStyle(color: Tema.rosa)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Descobre os melhores spots da noite, vê quem lá está e volta a casa em segurança.',
                  style: TextStyle(fontSize: 16, color: Tema.textoSecundario),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  // idade
                  readOnly: true,
                  onTap: dataNascimento,
                  controller: TextEditingController(
                    text: datenacimento != null
                        ? '${datenacimento!.day}/${datenacimento!.month}/${datenacimento!.year}'
                        : '',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Data de nascimento',
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Tema.textoSecundario,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Password',
                  ),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Aceitar Termos e Condições',
                    style: TextStyle(color: Tema.textoSecundario),
                  ),
                  value: aceitarTermos,
                  onChanged: (value) {
                    setState(() {
                      aceitarTermos = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: submeter,
                  child: const Text('Submeter'),
                ),
                const SizedBox(height: 20),
                // Rodapé: "Entrar" a rosa (só visual, ainda sem navegação)
                Center(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Tema.textoSecundario),
                      children: [
                        TextSpan(text: 'Já tens conta? '),
                        TextSpan(
                          text: 'Entrar',
                          style: TextStyle(
                            color: Tema.rosa,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

