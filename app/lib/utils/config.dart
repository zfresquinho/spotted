import 'package:flutter/foundation.dart';

/// Endereço da API.
/// - Web / iOS / macOS: localhost
/// - Emulador Android: 10.0.2.2 aponta para o localhost do computador.
/// - Telemóvel físico: usar o IP do computador na rede (ex.: 192.168.1.20).
class Config {
  static String get apiBaseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }
}
