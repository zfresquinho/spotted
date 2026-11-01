import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/views/widgets/bebida_botton_widget.dart';

import '../../controllers/bebida_controller.dart';
import '../../utils/tema.dart';

class NoiteScreen extends StatefulWidget {
  const NoiteScreen({super.key});

  @override
  State<NoiteScreen> createState() => _NoiteScreenState();
}

class _NoiteScreenState extends State<NoiteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoiteController>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<NoiteController>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
        const Text("A minha noite",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      if (c.aCarregar) const Center(child: CircularProgressIndicator()),
      if (c.erro != null) Text(c.erro!, style:const TextStyle(color:Tema.seguranca)),
        const Text("ADICIONAR BEBIDA", 
        style:  TextStyle(color: Tema.textoSecundario, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        const BotoesBebida(),
        ],
      )
      );
  }
}
