import 'package:flutter/material.dart';

/// Cores e tema da app. Ajustar aos valores finais do guia de estilo (Figma).
class Tema {
  static const Color fundo = Color(0xFF0E0B1A);
  static const Color superficie = Color(0xFF1B1630);
  static const Color destaque = Color(0xFFB57BFF); // cor da marca
  static const Color seguranca = Color(0xFFFF9F43); // avisos de consumo
  static const Color rosa = Color(0xFFFF3392);
  static const Color campo = Color(0xFF1A1727); // fundo dos inputs
  static const Color borda = Color(0xFF2C2840); // contorno dos inputs
  static const Color textoSecundario = Color(0xFFA7A2B8);

  static ThemeData get escuro => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: destaque,
          brightness: Brightness.dark,
          surface: superficie,
        ),
        // Campos de texto: fundo escuro, cantos redondos, borda subtil
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: campo,
          hintStyle: const TextStyle(color: textoSecundario, fontSize: 16),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: borda),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: rosa, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),

// Checkbox: rosa quando marcada, só contorno quando não
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: const BorderSide(color: borda, width: 1.5),
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? rosa
                : Colors.transparent,
          ),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),

// Botão principal: rosa, largura total, cantos redondos
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: rosa,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
