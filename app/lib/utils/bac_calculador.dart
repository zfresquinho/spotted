import "dart:math";

import '../models/consumo.dart';

/// Estimativa da taxa de álcool no sangue (modelo de Widmark, absorção imediata).
class BACCalculador {
  static const double beta = 0.15; // g/L eliminados por hora

  final double pesoKg;
  final String sexo; // 'M' ou 'F', como vem da API
  final List<Consumo> _todos; // só bebidas com álcool, por ordem de hora

  BACCalculador({
    required this.pesoKg,
    required this.sexo,
    required List<Consumo> consumos,
  }) : _todos = consumos
            .where((c) => c.gramasAlcool > 0)
            .toList() // tira a água
          ..sort((a, b) =>
              a.consumidoEm.compareTo(b.consumidoEm)); // ordena por hora

  // Fator de Widmark
  double get r => sexo == 'M' ? 0.68 : 0.55;

  /// Taxa em g/L num dado momento.
  double taxaEm(DateTime momento) {
    // 1. Sem bebidas com álcool, ou antes da primeira: taxa zero
    if (consumos.isEmpty || momento.isBefore(consumos.first.consumidoEm)) {
      return 0;
    }
    final t0 = consumos.first.consumidoEm;

    // 2. Gramas de álcool bebidos até ao momento
    final gramas = consumos
        .where((c) => !c.consumidoEm.isAfter(momento))
        .fold<double>(0, (soma, c) => soma + c.gramasAlcool);

    // 3. Horas desde a primeira bebida
    final horas = momento.difference(t0).inSeconds / 3600;

    // 4. Widmark menos a eliminação, nunca abaixo de zero
    return max(0.0, gramas / (r * pesoKg) - beta * horas);
  }

  DateTime? horaAbaixoDe(double limite) {
    // 1. Sem bebidas com álcool, ou já abaixo do limite: retorna null
    if (consumos.isEmpty || taxaEm(consumos.last.consumidoEm) < limite) {
      return null;
    }
    // 2. Hora da primeira bebida
    final t0 = consumos.first.consumidoEm;

    // 3. Gramas de álcool bebidos até agora
    final gramas = consumos.fold<double>(0, (soma, c) => soma + c.gramasAlcool);

    // 4. Horas até atingir o limite
    final horas = (gramas / (r * pesoKg) - limite) / beta;

    // 5. Hora estimada de atingir o limite
    return t0.add(Duration(seconds: (horas * 3600).round()));
  }

  List<(DateTime, double)> serie(
      {Duration passo = const Duration(minutes: 5)}) {
    if (consumos.isEmpty) {
      return [];
    }
    final t0 = consumos.first.consumidoEm;
    final tf = horaAbaixoDe(0) ?? t0;
    final List<(DateTime, double)> resultado = [];
    for (var t = t0; !t.isAfter(tf); t = t.add(passo)) {
      resultado.add((t, taxaEm(t)));
    }
    resultado.add((tf, 0));
    return resultado;
  }

  late final List<Consumo> consumos = _desdeUltimoZero();
  List<Consumo> _desdeUltimoZero() {
    var inicio = 0;
    double gramas = 0;
    for (var i = 0; i < _todos.length; i++) {
      final horas = _todos[i].consumidoEm.difference(_todos[inicio].consumidoEm).inSeconds / 3600;

      // Se antes desta bebida a taxa já estava a 0, a noite recomeça aqui
      if (i > inicio && gramas / (r * pesoKg) - beta * horas <= 0) {
        inicio = i;
        gramas = 0;
      }
      gramas += _todos[i].gramasAlcool;
    }
    return _todos.sublist(inicio);
  }
}
