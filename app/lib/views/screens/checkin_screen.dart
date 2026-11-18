import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/controllers/checkin_controller.dart';
import 'package:spotted/utils/tema.dart';
import 'package:spotted/views/widgets/scanner_qr_widget.dart';
import 'package:spotted/views/widgets/botao_gps_widget.dart';
import 'package:spotted/controllers/spot_controller.dart';

class CheckinScreen extends StatelessWidget {
  const CheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CheckinController>();

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Check-in",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Aponta a câmara para o código QR que está no balcão do spot.",
            style: TextStyle(color: Tema.textoSecundario, fontSize: 16),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child:
                  ScannerQr(onCodigo: (codigo) => c.iniciarCheckinQr(codigo)),
            ),
          ),
          const SizedBox(height: 24),
          if (c.mensagem != null)
            Text(c.mensagem!, style: const TextStyle(color: Colors.green)),
          if (c.erro != null)
            Text(c.erro!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          BotaoGps(
              onPressed: () => _escolherSpot(context), aCarregar: c.aCarregar),
        ],
      ),
    ));
  }

  void _escolherSpot(BuildContext context) {
    final spots = context.read<SpotController>().spots;

    showModalBottomSheet(
        context: context,
        builder: (_) => ListView(
              children: [
                for (final s in spots)
                  ListTile(
                    title: Text(s.nome),
                    subtitle: Text(s.morada),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<CheckinController>().iniciarCheckin(s.id);
                    },
                  ),
              ],
            ));
  }
}
