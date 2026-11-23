import 'package:flutter/material.dart';
import 'package:spotted/controllers/spot_controller.dart';
import 'package:spotted/models/spot.dart';
import 'package:spotted/views/widgets/spot_cabecalho_widget.dart';
import 'package:spotted/utils/tema.dart';
import 'package:provider/provider.dart';

class SpotDetalhesScreen extends StatelessWidget {
  const SpotDetalhesScreen({super.key, required this.spot});
  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Spot>(
        future: context.read<SpotController>().obterDetalhes(spot.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Tema.fundo,
              appBar: AppBar(backgroundColor: Tema.fundo),
              body: const Center(
                child: Text("Não foi possível carregar o spot",
                    style: TextStyle(color: Tema.textoSecundario)),
              ),
            );
          }
          final s = snapshot.data ?? spot;
          return Scaffold(
              backgroundColor: Tema.fundo,
              body: SingleChildScrollView(
                child: Column(children: [SpotCabecalhoWidget(spot: s)]),
              ));
        },
    );
  }
}
