
import 'package:flutter/foundation.dart';
import 'package:spotted/utils/bac_calculador.dart';
import '../models/bebida.dart'; // novo
import '../services/api_service.dart';
import '../models/consumo.dart';

class NoiteController extends ChangeNotifier {
  final ApiService _api;
  NoiteController({ApiService? api}) : _api = api ?? ApiService();

  List<Bebida> bebidas = [];
  List<Consumo> consumos = [];
  DateTime? iniciadaEm;
  bool aCarregar = false;
  String? erro;
  double? pesoKg;
  String? sexo;

  Future<void> carregar() async {
    aCarregar = true;
    erro = null;
    notifyListeners();
    try {
      bebidas = await _api.listarBebidas();
      final (lista, peso, s) = await _api.obterNoiteAtual();
      consumos = lista;
      pesoKg = peso;
      sexo = s;
    } catch (e) {
      erro = 'Não foi possível carregar a noite. Verifica a ligação.';
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future<void> adicionarBebida(int idBebida) async {
    try {
      final novo = await _api.registarConsumo(idBebida);
      consumos.add(novo);
    } catch (e) {
      erro = "Não foi possivel registar a bebida";
    } finally {
      notifyListeners();
    }
  }
    BACCalculador? get calculador {
      if (pesoKg == null || sexo == null) {
        return null;
      }
      return BACCalculador(
        pesoKg: pesoKg!,
        sexo: sexo!,
        consumos: consumos,
      );
  }
}
