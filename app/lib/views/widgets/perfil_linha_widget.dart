import 'package:flutter/material.dart';
import 'package:spotted/utils/tema.dart';

class PerfilLinhaWidget extends StatelessWidget {
  const PerfilLinhaWidget({
    super.key,
    required this.icone,
    required this.titulo,
    this.subtitulo,
    this.valor,
    this.cor,
    this.onTap,
    this.mostrarSeta = true,
  });

  final IconData icone;
  final String titulo;
  final String? subtitulo;
  final String? valor;
  final Color? cor;
  final VoidCallback? onTap;
  final bool mostrarSeta;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icone, color: cor ?? Tema.textoSecundario),
      title: Text(titulo, style: TextStyle(color: cor)),
      subtitle: subtitulo == null ? null : Text(subtitulo!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(valor != null) Text(valor!, style: const TextStyle(color: Tema.textoSecundario)),
          if (mostrarSeta) const  Icon(Icons.chevron_right, color: Tema.textoSecundario),
        ],
      ),
      onTap: onTap,
    );
  }
}
