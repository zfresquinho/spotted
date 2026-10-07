import 'package:flutter/material.dart';

class RegisterSpotted extends StatefulWidget {
  const RegisterSpotted({super.key});

  @override
  State<RegisterSpotted> createState() => _RegisterSpottedState();
}

class _RegisterSpottedState extends State<RegisterSpotted> {
  bool aceitarTermos = false;
  DateTime? datenacimento;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
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
    void submeter() {
      if (formKey.currentState!.validate()) {
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
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
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

