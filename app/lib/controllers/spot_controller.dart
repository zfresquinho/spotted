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
