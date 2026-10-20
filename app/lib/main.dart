import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotted/controllers/auth_controller.dart';
import 'package:spotted/views/screens/home_screen.dart';

import 'controllers/spot_controller.dart';
import 'utils/tema.dart';
import 'views/screens/spots_screen.dart';
import 'package:spotted/views/screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpotController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        // TODO: AuthController, NoiteController, ChatController…
        
      ],
      child: const SpottedApp(),
      
    ),
  );
}

class SpottedApp extends StatelessWidget {
  const SpottedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotted',
      debugShowCheckedModeBanner: false,
      theme: Tema.escuro, // modo escuro por omissão (uso noturno)
      home: Consumer<AuthController>(
      builder: (_, auth, __) =>  auth.estaLigado? HomeScreen() : const LoginScreen(),

      ),
    );
  }
}
