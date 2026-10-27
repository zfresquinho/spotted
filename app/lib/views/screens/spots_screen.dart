import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spotted/utils/tema.dart';
import 'package:spotted/views/widgets/filtros_widget.dart';
import '../../controllers/spot_controller.dart';
import 'package:geolocator/geolocator.dart';

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

  final _mapa = MapController();
  LatLng? _eu;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpotController>().carregar();
      _obterlocalizacao();
    });
  }

  Future<void> _obterlocalizacao() async {
    bool localizacaoativa;
    LocationPermission permission;

    localizacaoativa = await Geolocator.isLocationServiceEnabled();

    if (!localizacaoativa) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _eu = LatLng(pos.latitude, pos.longitude);
      _mapa.move(_eu!, 15);
    });
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(margem, 0, margem, 12),
            child: TextField(
              onChanged: c.definirPesquisa,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Procurar spot ou zona...',
                prefixIcon: Icon(Icons.search, color: Tema.textoSecundario),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Tema.superficie,
                    builder: (_) => const FiltrosWidget());
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
            mapController: _mapa,
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
                markers: c.spotsFiltrados.map((s) {
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
              if (_eu != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _eu!,
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }
}
