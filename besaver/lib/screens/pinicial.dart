import 'package:besaver/screens/Login.dart';
import 'package:besaver/screens/Registo.dart';
import 'package:besaver/screens/login_register_page.dart';
import 'package:flutter/material.dart';

class Pinicial extends StatelessWidget {
  const Pinicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAFAFA),
            Color(0xFFFAFAFA),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/Logos.png",
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 107, 174, 110),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 87, 124, 89),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                child: const Center(
                  child: Text(
                    "Registo",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          const Text(
            "Queres saber mais sobre a nossa app? Visita o website!",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 125, 125, 125),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
