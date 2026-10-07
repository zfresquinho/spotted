import 'package:flutter/material.dart';

class RegisterSpotted extends StatefulWidget {
  const RegisterSpotted({super.key});

  @override
  State<RegisterSpotted> createState() => _RegisterSpottedState();
}

class _RegisterSpottedState extends State<RegisterSpotted> {
  bool aceitarTermos = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void submeter() {
    if (formKey.currentState!.validate()) {
      final String email = emailController.text.trim();
      final int? idade = int.tryParse(idadeController.text.trim());
      if (idade == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Idade inválida.')),
        );
        return;
      }
      if (idade < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deve ter pelo menos 18 anos.')),
        );
        return;
      }
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email inválido.')),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'Primeiro Nome',
                  ),
                ),
                TextFormField(
                  controller: lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Último Nome',
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: idadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Idade',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Password',
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Aceitar Termos e Condições'),
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
              ],
            ),
          ),
        ),
      );
  }
}
