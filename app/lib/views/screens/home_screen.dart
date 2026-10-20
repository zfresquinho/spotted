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
    Center(child: Text("Perfil"))
  ];

  @override
  Widget build(BuildContext context ){
    return Scaffold(
      backgroundColor: Tema.fundo,
      body: paginas[indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceAtual,
        onTap: (novoindice){
          setState (() => indiceAtual = novoindice);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), 
        label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.settings),
        label: "Settings")
      ],
      ),
    );
  }
}
