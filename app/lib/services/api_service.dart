import 'dart:convert';

import 'package:http/http.dart' as http;

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
}
