import 'package:flutter/material.dart';
import '../widgets/register_widget.dart';
void main() {
  runApp(const MyApp());
}

// 1) Só a configuração da app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const RegisterSpotted(),
    );
  }
}