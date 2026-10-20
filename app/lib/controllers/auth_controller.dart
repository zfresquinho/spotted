import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AuthController extends ChangeNotifier {
  final ApiService _api;
  AuthController({ApiService? api}) : _api = api ?? ApiService();

  int? utilizadorId;
  bool aCarregar = false;
  String? erro;

  bool get estaLigado => utilizadorId != null;

  Future<void> entrar(String email, String password) async {
    aCarregar = true;
    erro = null;
    notifyListeners();
    try {
      utilizadorId = await _api.login(email: email, password: password);
    } catch (e) {
      erro = e.toString().replaceFirst("Exception: ", "");
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  void sair() {
    utilizadorId = null;
    notifyListeners();
  }
}
