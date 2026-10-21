import 'package:flutter/material.dart';
import '../../utils/tema.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  int indiceAtual = 0;

  final paginas = const [
    Center(child: Text("Home")),
    Center(child: Text("Check-In")),
    Center(child: Text("Minha-Noite")),
    Center(child: Text("Perfil"))
  ];

  @override
  Widget build(BuildContext context ){
    return Scaffold(
      backgroundColor: Tema.fundo,
      body: paginas[indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceAtual,
        type: BottomNavigationBarType.fixed,
        onTap: (novoindice){
          setState (() => indiceAtual = novoindice);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), 
        label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner),
        label: "Check-In"),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), 
        label:"Minha Noite"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), 
        label:"Account")
      ],
      ),
    );
  }
}
