import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final ApiService _api;
  AuthController({ApiService? api}) : _api = api ?? ApiService();

  int? utilizadorId;
  bool aCarregar = false;
  bool aVerificarSessao = true;
  String? erro;

  bool get estaLigado => utilizadorId != null;

  Future<void> carregarsessao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      utilizadorId = prefs.getInt("utilizadorId");
    } catch (e) {
      utilizadorId = null;
    } finally {
      aVerificarSessao = false;
      notifyListeners();
    }
  }

  Future<void> entrar(String email, String password) async {
    aCarregar = true;
    erro = null;
    notifyListeners();
    try {
      utilizadorId = await _api.login(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("utilizadorId", utilizadorId!);
    } catch (e) {
      erro = e.toString().replaceFirst("Exception: ", "");
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future<void> sair() async {
    utilizadorId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("utilizadorId");
    notifyListeners();
  }
}
