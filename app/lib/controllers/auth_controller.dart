import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final ApiService _api;
  AuthController({ApiService? api}) : _api = api ?? ApiService();

  String? token;
  bool aCarregar = false;
  bool aVerificarSessao = true;
  String? erro;

  bool get estaLigado => token != null;

  Future<void> carregarsessao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
    } catch (e) {
      token = null;
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
      token = await _api.login(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token!);
    } catch (e) {
      erro = e.toString().replaceFirst("Exception: ", "");
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future<void> sair() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    notifyListeners();
  }
}
