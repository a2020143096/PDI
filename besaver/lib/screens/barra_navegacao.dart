
import 'package:besaver/screens/adicionar.dart';
import 'package:besaver/screens/carteira.dart';
import 'package:besaver/screens/estatistica.dart';
import 'package:besaver/screens/perfil.dart';
import 'package:besaver/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BarraDeNavegacao extends StatefulWidget {
  const BarraDeNavegacao({Key? key}) : super(key: key);

  @override
  State<BarraDeNavegacao> createState() => BarraDeNavegacaoState();
}

class BarraDeNavegacaoState extends State<BarraDeNavegacao> {
  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return Estatistica();
      case 2:
        return const Adicionar();
      case 3:
        return const Carteira();
      case 4:
        return Perfil();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTabContent(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 87, 124, 89),
        selectedItemColor: const Color.fromARGB(255, 87, 124, 89),
        unselectedItemColor: const Color.fromARGB(255, 87, 124, 89),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/home-1.png",
              color: const Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/chart-vertical.png",
              color: const Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Estatísticas",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/plus2.png",
            ),
            label: "Adicionar",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/wallet.png",
              color: const Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Carteira",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/user-1.png",
              color: const Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
