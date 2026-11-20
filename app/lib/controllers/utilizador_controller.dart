import 'package:flutter/foundation.dart';
import 'package:spotted/services/api_service.dart';
import '../models/utilizador.dart';

class UtilizadorController extends ChangeNotifier {
  final ApiService _api;
  UtilizadorController({ApiService? api}) : _api = api ?? ApiService();

  Utilizador? utilizador;
  bool aCarregar = false;
  String? erro;

  Future<void> carregar() async {
    aCarregar = true;
    erro = null;
    notifyListeners();
    try {
      utilizador = await _api.obterPerfil();
    } catch (e) {
      erro = "Não foi possivel carregar o perfil";
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future<String?> guardarDados(double peso, String sexo) async {
    try {
      await _api.atualizarPeso(peso);
      await _api.atualizarsexo(sexo);
      await carregar();

      return null;
    } catch (e) {
      return "Não foi possível guardar os dados";
    }
  }
}
