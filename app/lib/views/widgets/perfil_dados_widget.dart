import 'package:flutter/material.dart';
import 'package:spotted/utils/tema.dart';

class PerfilDadosWidget extends StatelessWidget {
  const PerfilDadosWidget(
      {super.key,
      required this.dataNascimento,
      this.pesoKg,
      this.sexo,
      this.onAdicionar});

  final DateTime dataNascimento;
  final double? pesoKg;
  final String? sexo;
  final VoidCallback? onAdicionar;

  @override
  Widget build(BuildContext context) {
    final d = dataNascimento;
    final dataFormatada =
        "${d.day.toString().padLeft(2, "0")}/${d.month.toString().padLeft(2, "0")}/${d.year.toString().padLeft(2, "0")}";
    return Container(
        decoration: BoxDecoration(
          color: Tema.superficie,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Tema.borda),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Data Nascimento",
                  style: TextStyle(color: Tema.textoSecundario)),
              Text(dataFormatada),
            ]),
            const SizedBox(height: 22),
             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
               const Text("Peso e Sexo (Opcionais)", style: TextStyle(color: Tema.textoSecundario)),
               if (pesoKg == null || sexo == null)
               TextButton(onPressed: onAdicionar,
                child: const Text("Adicionar", style: TextStyle(color: Tema.rosa)),
                )
                else
                Text("${pesoKg!.toStringAsFixed(0)} kg · $sexo")
            ]),
                const SizedBox(height: 12),
                const Text("Usados apenas para a estimativa de alcoolemia, nunca apresentados no teu perfil público.",
                      style: TextStyle(color: Tema.textoSecundario, fontSize: 13))
          ],
        ));
  }
}
