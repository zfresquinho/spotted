import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:spotted/utils/tema.dart';

class ScannerQr extends StatefulWidget {
  const ScannerQr({super.key, required this.onCodigo});
  final Future<bool> Function(String codigo) onCodigo;

  @override
  State<ScannerQr> createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> {
  final _controller = MobileScannerController();
  bool _jaLido = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
            child: MobileScanner(
                controller: _controller,
                onDetect: (capture) async {
                  final codigo = capture.barcodes.firstOrNull?.rawValue;
                  if (codigo == null || _jaLido) return;
                  _jaLido = true;
                  final sucesso = await widget.onCodigo(codigo);
                  if (!sucesso) _jaLido = false;
                }),),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Tema.rosa, width: 4),
                    left: BorderSide(color: Tema.rosa, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Tema.rosa, width: 4),
                    right: BorderSide(color: Tema.rosa, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Tema.rosa, width: 4),
                    left: BorderSide(color: Tema.rosa, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Tema.rosa, width: 4),
                    right: BorderSide(color: Tema.rosa, width: 4),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
