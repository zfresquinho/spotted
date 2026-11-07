import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/views/widgets/bebida_botton_widget.dart';
import 'package:spotted/views/widgets/grafico_noite_widget.dart';

import '../../controllers/bebida_controller.dart';
import '../../utils/tema.dart';

class NoiteScreen extends StatefulWidget {
  const NoiteScreen({super.key});

  @override
  State<NoiteScreen> createState() => _NoiteScreenState();
}

class _NoiteScreenState extends State<NoiteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoiteController>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<NoiteController>();
    final calc = c.calculador;
    final taxa = calc?.taxaEm(DateTime.now()) ?? 0.0;
    final hora = calc?.horaAbaixoDe(0.5);

    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("A minha noite",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

        const SizedBox(height: 24),
        if (c.aCarregar) const Center(child: CircularProgressIndicator()),
        if (c.erro != null)
          Text(c.erro!, style: const TextStyle(color: Tema.seguranca)),
        const Text("ADICIONAR BEBIDA",
            style: TextStyle(color: Tema.textoSecundario, letterSpacing: 1.2)),
        if(calc == null) 
        const Text("Indica o peso e o sexo no perfil para veres a estimativa.")
        else... [
          Text(
            "${taxa.toStringAsFixed(2)} g/L",
              style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
              if (calc.consumos.isNotEmpty)
              GraficoNoiteWidget(pontos: calc.serie(), t0: calc.consumos.first.consumidoEm),
        
        if (hora != null)... [
          const SizedBox(height: 12),
          Text("Hora estimada para ficar abaixo de 0.5: ${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}"),
        ],
        if (taxa >= 0.5) 
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Tema.seguranca,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Atenção! A tua taxa de álcool no sangue está acima do limite legal para conduzir.",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
        const SizedBox(height: 12),
        const BotoesBebida(),

        ]
    ));
  }
}
