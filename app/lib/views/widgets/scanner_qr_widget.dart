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

  Widget _canto({required bool acima, required bool esquerda}) {
    const lado = BorderSide(color: Tema.rosa, width: 4);

    return Positioned(
      top: acima ? 0 : null,
      bottom: acima ? null : 0,
      left: esquerda ? 0 : null,
      right: esquerda ? null : 0,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
          top: acima ? lado : BorderSide.none,
          bottom: acima ? BorderSide.none : lado,
          left: esquerda ? lado : BorderSide.none,
          right: esquerda ? BorderSide.none : lado,
          ),
        ),
      ),
    );
  }

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
                }),
          ),
          _canto(acima: true,  esquerda: true),
          _canto(acima: true,  esquerda: false),
          _canto(acima: false, esquerda: true),
          _canto(acima: false, esquerda: false),
        ],
      ),
    );
  }
}
