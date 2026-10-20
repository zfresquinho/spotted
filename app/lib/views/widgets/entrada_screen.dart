import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/tema.dart';

class EntrarWidget extends StatefulWidget {
  final VoidCallback aoTrocar;
  const EntrarWidget({super.key, required this.aoTrocar});

  @override
  State<EntrarWidget> createState() => _EntrarWidgetState();
}

class _EntrarWidgetState extends State<EntrarWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: Tema.fundo,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 72, 28, 24),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
          const SizedBox(height: 28),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 20),

          if (auth.erro != null)
            Text(auth.erro!, style: const TextStyle(color: Tema.rosa)),

          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: auth.aCarregar
                ? null
                : () => context.read<AuthController>().entrar(
                      emailController.text.trim(),
                      passwordController.text,
                    ),
            child: auth.aCarregar
                ? const CircularProgressIndicator()
                : const Text('Entrar'),
          ),
        ]),
      ),
    );
  }
}
