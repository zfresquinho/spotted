import 'package:flutter/foundation.dart';

import '../models/spot.dart';
import '../services/api_service.dart';

/// Controller: guarda o estado dos spots e avisa as views quando muda.
class SpotController extends ChangeNotifier {
  final ApiService _api;
  SpotController({ApiService? api}) : _api = api ?? ApiService();

  List<Spot> spots = [];
  bool aCarregar = false;
  String? erro;
  String? filtroTipo;
  int? filtroPreco;

  String filtroPesquisa = "";

  List<String> get tipo => spots.map((s) => s.tipo).toSet().toList();

  void definirPesquisa(String texto) {
    filtroPesquisa = texto.trim().toLowerCase();
    notifyListeners();
  }

  void definirTipo(String? tipo) {
    filtroTipo = tipo;
    notifyListeners();
  }

  void definirPreco(int? preco) {
    filtroPreco = preco;
    notifyListeners();
  }

  List<Spot> get spotsFiltrados => spots
      .where((s) =>
          (filtroTipo == null || s.tipo == filtroTipo) &&
          (filtroPreco == null || s.nivelPreco == filtroPreco) &&
          (filtroPesquisa.isEmpty || s.nome.toLowerCase().contains(filtroPesquisa) ||
           s.zona.toLowerCase().contains(filtroPesquisa)))
      .toList();

  Future<void> carregar({int? zona}) async {
    aCarregar = true;
    erro = null;
    notifyListeners();
    try {
      spots = await _api.listarSpots(zona: zona);
    } catch (e) {
      erro = 'Não foi possível carregar os spots. Verifica a ligação.';
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }
}
