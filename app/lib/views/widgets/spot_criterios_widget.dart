

import 'package:flutter/material.dart';
import 'package:spotted/utils/tema.dart';
import 'package:spotted/models/spot.dart';

class SpotCriteriosWidget extends StatelessWidget{
final Spot spot;
const SpotCriteriosWidget({super.key, required this.spot});

  Widget _linha(String nome, double? media) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        SizedBox(width: 90, child: Text(nome)),       
        Expanded(child: LinearProgressIndicator(value: (media ?? 0) / 5, color: Colors.amber, backgroundColor: Tema.borda, minHeight: 8, borderRadius: BorderRadius.circular(4)),
        ),
        SizedBox(width: 40, child: Text(media?.toStringAsFixed(1) ?? "–", textAlign: TextAlign.end)),         
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Tema.superficie,
        border: Border.all(color: Tema.borda),
      ),
      child: Column(
        children: [
          _linha("Ambiente", spot.mediaAmbiente),
          _linha("Música", spot.mediaMusica),
          _linha("Preço", spot.mediaPreco),
          _linha("Serviço", spot.mediaServico),
        ],
      ),
    );   
  }
}