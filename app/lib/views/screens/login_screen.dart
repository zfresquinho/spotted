import 'package:flutter/material.dart';
import 'package:spotted/views/screens/home_screen.dart';
import '../widgets/register_widget.dart';
import '../../utils/tema.dart';
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
      theme: Tema.escuro,
      home: const HomeScreen(),
    );
  }
}