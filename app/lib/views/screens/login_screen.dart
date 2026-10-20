import 'package:flutter/material.dart';
import '../widgets/entrada_screen.dart';
import '../widgets/register_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


// 1) Só a configuração da app
class _LoginScreenState extends State<LoginScreen>{
  bool modoRegistro = false;

  @override
  Widget build(BuildContext context) {
    return modoRegistro
    ? RegisterSpotted(aoTrocar: () => setState (() => modoRegistro = false))
    : EntrarWidget(aoTrocar: ()=> setState (() => modoRegistro = true));

  }
}