import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/controllers/spot_controller.dart';

class FiltrosWidget extends StatelessWidget {
  const FiltrosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SpotController>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tipo",
          style: TextStyle(color: Colors.white)),
          Wrap(
            spacing: 8,
            children: [
              for (final t in c.tipo)
              ChoiceChip(label: Text(t),
               selected: c.filtroTipo == t,
               onSelected: (_) => c.definirTipo(c.filtroTipo == t ? null : t),
               )
            ],),
            const SizedBox(
              height: 16,
            ),
            const Text ("Preço", style: TextStyle(color: Colors.white)),
            Wrap(
              spacing: 8,
              children: [
                for (final p in [1, 2, 3])
                ChoiceChip(
                  label: Text("€" * p),
                 selected: c.filtroPreco == p,
                onSelected: (_)=> c.definirPreco(c.filtroPreco == p ? null : p),
                ),
              ],
            ),
        ],
      )
      );
  }
}
