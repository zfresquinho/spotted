import 'package:flutter/material.dart';
import 'package:spotted/models/spot.dart';
import 'package:spotted/utils/tema.dart';

class SpotCabecalhoWidget extends StatelessWidget {
  final Spot spot;

  const SpotCabecalhoWidget({super.key, required this.spot});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient:const  LinearGradient(
                colors: [Tema.destaque, Tema.rosa, Tema.seguranca],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 170, left: 16, right: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Tema.superficie,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(spot.nome, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("${spot.tipo} · ${spot.morada} · ${spot.precoEmEuros}", style: const TextStyle(color: Tema.textoSecundario)),
                  const SizedBox(height: 8),
                   Row(
                    children: [
                       const Icon(Icons.star, color: Colors.amber, size: 18),
                       Text(spot.media?.toStringAsFixed(1) ?? "–"),
                       Text(" · ${spot.nAvaliacoes} avaliações", style: const TextStyle(color: Tema.textoSecundario)),
                       const SizedBox(width: 12),
                       const Icon(Icons.circle, color: Tema.rosa, size: 10),
                       Text(" ${spot.pessoasAgora ?? 0} aqui", style: const TextStyle(color: Tema.rosa)),
                    ],
                  )
                  ],
                ),
              ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.black26),),))
      ],
    );
  }
}
