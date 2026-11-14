import 'package:flutter/widgets.dart';
import 'package:spotted/utils/tema.dart';

class PerfilSeccaoWidget extends StatelessWidget {
  const PerfilSeccaoWidget(
      {super.key, required this.filhos, required this.titulo});

  final List<Widget> filhos;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(color: Tema.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Tema.superficie,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Tema.borda),
          ),
          child: Column(children: filhos),
        ),
      ],
    );
  }
}
