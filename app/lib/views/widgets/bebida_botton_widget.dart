import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/bebida_controller.dart';
import '../../models/bebida.dart';
import '../../utils/tema.dart';


class BotoesBebida extends StatelessWidget {
  const BotoesBebida({super.key});

  static const _opcoes = [
    ('🍺', 'Cerveja', 'Cerveja'),
    ('🍷', 'Vinho', 'Vinho'),
    ('🍹', 'Cocktail', 'Cocktail'),
    ('💧', 'Água', 'Sem alcool'),
  ];

  @override
    Widget build(BuildContext context) {
      final bebidas = context.watch<NoiteController>().bebidas;

      return Row(
        children: [
          for (final (emoji, rotulo, categoria) in _opcoes)
            Expanded(
              child: _Botao(
                emoji: emoji,
                rotulo: rotulo,
                bebida:
                    bebidas.where((b) => b.categoria == categoria).firstOrNull,
              ),
            ),
        ],
      );
    }
  }
  class _Botao extends StatelessWidget{
   final String emoji; 
   final String rotulo;
   final Bebida? bebida;

   const _Botao ({required this.emoji, required this.rotulo, this.bebida});
   @override

   Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsetsGeometry.symmetric(horizontal: 4),
      child:Material(
        color:Tema.superficie,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: bebida == null ? null : () => context.read<NoiteController>().adicionarBebida(bebida!.id),
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(vertical: 18),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(rotulo, style: const TextStyle(color: Tema.textoSecundario)),
              ],
            ),)

        ),),
    );
   } 
  }



