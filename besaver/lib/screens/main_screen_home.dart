import 'package:besaver/screens/carteira.dart';
import 'package:besaver/screens/home_add_tab.dart';
import 'package:besaver/screens/home_profile_tab.dart';
import 'package:besaver/screens/home_screen_tab.dart';
import 'package:flutter/material.dart';
import 'package:besaver/utils/constants.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({Key? key}) : super(key: key);

  @override
  State<MainScreenHost> createState() => MainScreenHostState();
}

class MainScreenHostState extends State<MainScreenHost> {
  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const HomeScreenTab();
      case 1:
        return Container();
      case 2:
        return const HomeAddTab();
      case 3:
        return const Carteira();
      case 4:
        return const HomeProfileTab();
      default:
        return const HomeScreenTab();
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
        backgroundColor: Color.fromARGB(255, 87, 124,
            89), // Definindo a cor de fundo do BottomNavigationBar como verde
        selectedItemColor: Color.fromARGB(255, 87, 124,
            89), // Definindo a cor do ícone selecionado como preto
        unselectedItemColor: Color.fromARGB(255, 87, 124,
            89), // Definindo a cor do ícone não selecionado como preto
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/home-1.png",
              color: Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/chart-vertical.png",
              color: Color.fromARGB(255, 87, 124, 89),
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
              color: Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Carteira",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/user-1.png",
              color: Color.fromARGB(255, 87, 124, 89),
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
