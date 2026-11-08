import 'package:flutter/material.dart';
import 'package:spotted/utils/tema.dart';

class BotaoGps extends StatelessWidget {
  const BotaoGps({required this.onPressed, this.aCarregar = false, super.key});
  final VoidCallback? onPressed;
  final bool aCarregar;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: aCarregar ? null : onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Tema.superficie),
      child: aCarregar
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2))
          : const Text("Sem QR? Check-in por GPS"),
    );
  }
}
