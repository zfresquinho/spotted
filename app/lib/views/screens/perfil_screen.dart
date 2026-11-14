import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/controllers/utilizador_controller.dart';
import 'package:spotted/views/widgets/perfil_cabecalho_widget.dart';
import 'package:spotted/views/widgets/perfil_dados_widget.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UtilizadorController>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<UtilizadorController>();
    if (c.aCarregar) {
      return const Center(child: CircularProgressIndicator());
    }
    if (c.erro != null) {
      return Center(child: Text(c.erro!));
    }
    if (c.utilizador == null) {
      return const SizedBox.shrink();
    }
    final u = c.utilizador!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Perfil",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          PerfilCabecalhoWidget(
              nome: u.nome, email: u.email),
          const SizedBox(height: 24),
          PerfilDadosWidget(dataNascimento: u.dataNascimento, pesoKg: u.pesokg, sexo: u.sexo)
        ],
      ),
    );
  }
}
