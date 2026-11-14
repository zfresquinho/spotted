import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/controllers/utilizador_controller.dart';
import 'package:spotted/views/widgets/perfil_cabecalho_widget.dart';
import 'package:spotted/views/widgets/perfil_dados_widget.dart';
import 'package:spotted/views/widgets/perfil_linha_widget.dart';
import 'package:spotted/views/widgets/perfil_seccao_widget.dart';
import 'package:spotted/utils/tema.dart';
import 'package:spotted/controllers/auth_controller.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool localizacao = true;
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
          PerfilCabecalhoWidget(nome: u.nome, email: u.email),
          const SizedBox(height: 24),
          PerfilDadosWidget(
              dataNascimento: u.dataNascimento, pesoKg: u.pesokg, sexo: u.sexo),
          const SizedBox(height: 24),
          const PerfilSeccaoWidget(
            titulo: "AS TUAS NOITES",
            filhos: [
              PerfilLinhaWidget(
                  icone: Icons.history,
                  titulo: "Histórico de noites",
                  subtitulo: "Última: 17 out. · 3 spots",
                  valor: "12 noites"),
              const Divider(height: 1),
              PerfilLinhaWidget(
                  icone: Icons.place_outlined,
                  titulo: "Spots visitados",
                  subtitulo: "Mais recente: Terraço Lua Nova",
                  valor: "8 spots"),
            ],
          ),
          const SizedBox(height: 24),
          PerfilSeccaoWidget(
            titulo: "PRIVACIDADE E DADOS",
            filhos: [
              SwitchListTile(
                secondary: const Icon(Icons.place_outlined,
                    color: Tema.textoSecundario),
                title: const Text("Permitir localização"),
                subtitle: const Text("Só ao usar a app"),
                value: localizacao,
                activeColor: Tema.rosa,
                onChanged: (novo) => setState(() => localizacao = novo),
              ),
              PerfilLinhaWidget(
                  icone: Icons.lock_outline,
                  titulo:
                      "Os teus dados de consumo são privados. Só tu os podes ver.",
                  mostrarSeta: false),
              Divider(height: 1),
              PerfilLinhaWidget(
                  icone: Icons.download_outlined,
                  titulo: "Exportar os meus dados"),
              const Divider(height: 1, color: Tema.borda),
              PerfilLinhaWidget(
                icone: Icons.delete_outline,
                titulo: "Eliminar conta",
                cor: Tema.rosa,
              ),
            ],
          ),
          const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, // botão com a largura toda
                height: 56,
                child: TextButton.icon(
                  onPressed: () => context.read<AuthController>().sair(),
                  icon: const Icon(Icons.logout, color: Tema.rosa),
                  label: const Text(
                    "Terminar sessão",
                    style: TextStyle(
                        color: Tema.rosa,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Tema.superficie,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
        ],
      ),
      
    );
  }
}
