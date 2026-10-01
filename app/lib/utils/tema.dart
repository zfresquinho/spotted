import 'package:flutter/material.dart';

/// Cores e tema da app. Ajustar aos valores finais do guia de estilo (Figma).
class Tema {
  static const Color fundo = Color(0xFF0E0B1A);
  static const Color superficie = Color(0xFF1B1630);
  static const Color destaque = Color(0xFFB57BFF); // cor da marca
  static const Color seguranca = Color(0xFFFF9F43); // avisos de consumo

  static ThemeData get escuro => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: destaque,
          brightness: Brightness.dark,
          surface: superficie,
        ),
      );
}
