import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spotted/utils/tema.dart';

class GraficoNoiteWidget extends StatelessWidget {
  const GraficoNoiteWidget({required this.pontos, required this.t0, super.key});
  final List<(DateTime, double)> pontos;
  final DateTime t0;

  @override
  Widget build(BuildContext context) {
    final spots = pontos
        .map((p) => FlSpot(p.$1.difference(t0).inMinutes / 60, p.$2))
        .toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 0,
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              reservedSize: 36,
              getTitlesWidget: (valor, meta) {
                if (valor % 0.5 != 0) return const SizedBox.shrink();
                return Text(valor.toStringAsFixed(1));
              },
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (valor, meta) {
                final hora = t0.add(Duration(minutes: (valor * 60).round()));
                if (valor % 1 != 0) return const SizedBox.shrink();
                return Text("${hora.hour}h");
              },
            )
          ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 0.5,
                color: Tema.seguranca,
                strokeWidth: 2,
                dashArray: [6, 4],
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              color: Tema.rosa,
              isCurved: false,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              spots: spots,
              belowBarData: BarAreaData(
                show: true,
                color: Tema.rosa.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
