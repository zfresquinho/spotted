import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spotted/utils/tema.dart';
import 'package:spotted/views/widgets/filtros_widget.dart';
import '../../controllers/spot_controller.dart';

/// Ecrã do mapa: logótipo + barra de pesquisa no topo e os spots no mapa.
class SpotsScreen extends StatefulWidget {
  const SpotsScreen({super.key});

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  // Distância à borda esquerda/direita: igual no logótipo e na pesquisa,
  // para ficarem alinhados como no design (mapa.png).
  static const double margem = 20;

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
      appBar: AppBar(
        backgroundColor: Tema.fundo,
        scrolledUnderElevation:
            0, // não muda de cor quando algo passa por baixo
        toolbarHeight: 72,
        centerTitle: false,
        titleSpacing: margem,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            children: [
              TextSpan(text: 'spott'),
              TextSpan(text: 'ed', style: TextStyle(color: Tema.rosa)),
            ],
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: Padding(
            padding: EdgeInsets.fromLTRB(margem, 0, margem, 12),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Procurar spot ou zona...',
                prefixIcon: Icon(Icons.search, color: Tema.textoSecundario),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: margem),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                context: context,
                backgroundColor: Tema.superficie,
                builder: (_) => const FiltrosWidget()
                );
              },
              icon: const Icon(Icons.menu, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Tema.superficie,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                fixedSize: const Size(48, 48),
              ),
            ),
          )
        ],
      ),
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

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(38.7223, -9.1393),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                tileBuilder: darkModeTileBuilder,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: "com.spotted.app",
              ),
              MarkerLayer(
                markers: c.spots.map((s) {
                  return Marker(
                    point: LatLng(s.latitude, s.longitude),
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Tema.rosa,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Tema.rosa.withValues(alpha: 0.6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.nightlife,
                          color: Colors.white, size: 22),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
