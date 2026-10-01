import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/spot_controller.dart';

/// View provisória: lista de spots vinda da API.
/// No Sprint 1 passa a mapa (flutter_map) com esta lista no cartão inferior.
class SpotsScreen extends StatefulWidget {
  const SpotsScreen({super.key});

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SpotController>().carregar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SpotController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Spotted')),
      body: RefreshIndicator(
        onRefresh: () => c.carregar(),
        child: Builder(builder: (_) {
          if (c.aCarregar && c.spots.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.erro != null) {
            return ListView(children: [
              Padding(padding: const EdgeInsets.all(24), child: Text(c.erro!)),
            ]);
          }
          return ListView.separated(
            itemCount: c.spots.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final s = c.spots[i];
              return ListTile(
                title: Text(s.nome),
                subtitle: Text('${s.tipo} · ${s.zona} · ${s.precoEmEuros}'),
                trailing: Text(
                  s.media == null ? '—' : '${s.media!.toStringAsFixed(1)} ★',
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
