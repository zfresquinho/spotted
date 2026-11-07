import 'package:flutter/foundation.dart';
import 'package:spotted/models/checkin.dart';
import '../services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class CheckinController extends ChangeNotifier {
  final ApiService _api;
  CheckinController({ApiService? api}) : _api = api ?? ApiService();

  List<Checkin> checkins = [];
  bool aCarregar = false;
  String? erro;
  String? mensagem;


  Future<void> carregar() async {
    aCarregar = true;
    erro = null;
    notifyListeners();
    try {
      checkins = await _api.listarCheckinAtivos();
    } catch (e) {
      erro = 'Não foi possível carregar os checkins. Verifica a ligação.';
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future<void> iniciarCheckin(int idSpot) async {

    if (aCarregar) return;
    LocationPermission permission;
    final bool localizacaoativa;
    aCarregar = true;
    erro = null;
    mensagem = null;
    notifyListeners();

    try {
      localizacaoativa = await Geolocator.isLocationServiceEnabled();
      if (!localizacaoativa) { 
        erro = "Serviço de localização desativado";
        return;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          erro = "Permissão de localização negada, nao podemos fazer o check in";
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        erro = "Permissão de localização negada permanentemente, nao podemos fazer o check in";
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      mensagem = await _api.checkinGps(
        idSpot: idSpot,
        latitude: pos.latitude,
        longitude: pos.longitude,
        accuracy: pos.accuracy,
      );
      await carregar();
    }catch (e) {
       erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future <void> iniciarCheckinQr(String qr) async {
    if (aCarregar) return;
    aCarregar = true;
    erro = null;
    mensagem = null;
    notifyListeners();
    try {
      mensagem = await _api.checkinQr(qr);
      await carregar();
    } catch (e) {
      erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }

  Future<void> terminarCheckin(int idCheckin) async {
    if (aCarregar) return;
    aCarregar = true;
    erro = null;
    mensagem = null;
    notifyListeners();
    try {
      await _api.terminarCheckin(idCheckin);
      await carregar();
    } catch (e) {
      erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      aCarregar = false;
      notifyListeners();
    }
  }
}

