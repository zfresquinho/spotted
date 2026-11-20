import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spotted/controllers/utilizador_controller.dart';
import 'package:provider/provider.dart';

class PerfilEditarDialog extends StatefulWidget {
  final double? pesoInicial;
  final String? sexoInicial;
  const PerfilEditarDialog({super.key, this.pesoInicial, this.sexoInicial});

  @override
  State<PerfilEditarDialog> createState() => _PerfilEditarDialogState();
}

class _PerfilEditarDialogState extends State<PerfilEditarDialog> {
  final _pesoController = TextEditingController();
  String? _sexo;

  @override
  void initState() {
    super.initState();
    if (widget.pesoInicial != null) {
      _pesoController.text = widget.pesoInicial!.toStringAsFixed(0);
    }
    _sexo = widget.sexoInicial;
  }

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final peso = double.tryParse(_pesoController.text.replaceAll(",", "."));
    if (peso == null || peso <= 30 || _sexo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Indica um peso válido e o sexo")));
      return;
    }
    final erro =
        await context.read<UtilizadorController>().guardarDados(peso, _sexo!);
    if (!mounted) return;
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("SEXO E PESO"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pesoController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: "Peso", suffixText: "Kg"),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: "M", label: Text("Masculino")),
              ButtonSegment(value: "F", label: Text("Feminino")),
            ],
            selected: _sexo == null ? {} : {_sexo!},
            emptySelectionAllowed: true,
            onSelectionChanged: (escolha) =>
                setState(() => _sexo = escolha.first),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        TextButton(onPressed: _guardar, child: const Text("Guardar"))
      ],
    );
  }
}
