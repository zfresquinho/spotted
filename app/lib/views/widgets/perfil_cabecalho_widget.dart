import 'package:flutter/material.dart';
import 'package:spotted/utils/tema.dart';

class PerfilCabecalhoWidget extends StatelessWidget {
  const PerfilCabecalhoWidget(
      {super.key,
      required this.email,
      required this.nome,
       this.onEditar});

  final String nome;
  final String email;
  final VoidCallback? onEditar;

  @override
  Widget build(BuildContext context) {
    final partes = nome.trim().split(" ");
    final iniciais = partes.length >= 2
        ? "${partes[0][0]}${partes[1][0]}".toUpperCase()
        : partes[0][0].toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Tema.superficie,
          child: Text(
            iniciais,
            style: const TextStyle(
                color: Tema.rosa, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nome,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(color: Tema.textoSecundario)),
            ],
          ),
        ),
        TextButton(
          onPressed: onEditar,
          child: const Text("Editar",
              style: TextStyle(color: Tema.rosa, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
