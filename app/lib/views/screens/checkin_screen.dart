import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/controllers/checkin_controller.dart';
import 'package:spotted/utils/tema.dart';
import 'package:spotted/views/widgets/scanner_qr_widget.dart';
import 'package:spotted/views/widgets/botao_gps_widget.dart';

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
            const Text("Check-in", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text("Aponta a câmara para o código QR que está no balcão do spot.", style: TextStyle(color: Tema.textoSecundario, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
            child: ScannerQr(onCodigo: (codigo) => c.iniciarCheckinQr(codigo)),
            ),
            ),
            const SizedBox(height: 24),
            BotaoGps(onPressed: null, aCarregar: c.aCarregar),            
          ],
        ),)
    );
  }
}
