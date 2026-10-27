import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/spot.dart';
import '../utils/config.dart';

/// Service: única camada que fala com a API REST.
class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Spot>> listarSpots({int? zona}) async {
    final uri = Uri.parse('${Config.apiBaseUrl}/spots')
        .replace(queryParameters: zona == null ? null : {'zona': '$zona'});
    final resposta = await _client.get(uri);
    if (resposta.statusCode != 200) {
      throw Exception('Erro ${resposta.statusCode} ao obter spots');
    }
    final lista = jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;
    return lista.map((e) => Spot.fromJson(e as Map<String, dynamic>)).toList();
  }

  //post /api/auth/register

  Future<String?> registar({
    required String nome,
    required String email,
    required String password,
    required DateTime datenacimento,
  }) async {
    final resposta = await _client.post(
      Uri.parse('${Config.apiBaseUrl}/auth/registar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'password': password,
        'data_nascimento': datenacimento.toIso8601String().substring(0, 10),
        'aceitou_rgpd': true,
      }),
    );
    if (resposta.statusCode == 201) return null;
    final corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
    return corpo['message'] ??
        'Erro ${resposta.statusCode} ao registar utilizador';
  }

  Future<String> login(
      {required String email, required String password}) async {
    final resposta = await _client.post(
      Uri.parse("${Config.apiBaseUrl}/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    final corpo = jsonDecode(utf8.decode(resposta.bodyBytes));
    if (resposta.statusCode != 200) {
      throw Exception(corpo["message"] ?? "Erro${resposta.statusCode}");
    }
    return corpo["token"] as String;
  }

  Future<Map<String, String>> _cabecalhos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
