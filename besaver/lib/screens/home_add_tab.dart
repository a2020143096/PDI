import 'package:flutter/material.dart';
import 'add_categorias_tab.dart';
import 'add_despesa_tab.dart';
import 'add_objetivo_tab.dart';

class HomeAddTab extends StatelessWidget {
  const HomeAddTab({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddDespesaTab()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 87, 124, 89),
                padding: const EdgeInsets.symmetric(vertical: 24.0),
              ),
              child: const Text(
                "Despesa/Rendimento",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCategoriasTab()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 87, 124, 89),
                padding: const EdgeInsets.symmetric(vertical: 24.0),
              ),
              child: const Text(
                "Categorias",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddObjetivoTab()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 87, 124, 89),
                padding: const EdgeInsets.symmetric(vertical: 24.0),
              ),
              child: const Text(
                "Objetivo Poupança",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
