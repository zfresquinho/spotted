

import 'bebida.dart';

class Consumo {
  final int id;
  final DateTime consumidoEm;
  final Bebida bebida;

  const Consumo({required this.id, required this.consumidoEm, required this.bebida});

  factory Consumo.fromJson(Map<String, dynamic> json) => Consumo(
    id: json["id"] as int,
    consumidoEm: DateTime.parse(json["consumidoEm"] as String),
    bebida: Bebida(
      id:json["idBebida"] as int,
      nome:json["nome"] as String,
      categoria:json ["categoria"] as String,
      volumeMl: json["volumeMl"] as int,
      teorAlcool:(json["teorAlcool"] as num).toDouble(),
  ),
);

double get gramasAlcool => bebida.gramasAlcool;
}