import 'package:besaver/screens/main_screen_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registo extends StatefulWidget {
  const Registo({Key? key}) : super(key: key);

  @override
  State<Registo> createState() => RegistoState();
}

class RegistoState extends State<Registo> {
  String? errorMessage = '';
  bool isLogin = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      String userId = userCredential.user!.uid;

      // Associar o usuário ao documento na Firestore usando o ID do usuário
      await FirebaseFirestore.instance
          .collection('utilizador')
          .doc(userId)
          .set({
        'nome': _controllerName.text,
        'email': _controllerEmail.text,
        'password': _controllerPassword.text, // Salva a senha no Firestore
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreenHost()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        createUserWithEmailAndPassword();
      },
      child: const Text('Registar'),
    );
  }

  Widget _RegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: const Text('Fazer registo'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0.5),
            Container(
              color: const Color.fromARGB(255, 244, 244, 244),
              padding: const EdgeInsets.all(20),
              child: const Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/Logos.png'),
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Bem-vindo!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Cria uma conta',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Nome Completo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 236, 236),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _controllerName,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nome',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 236, 236),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _controllerEmail,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escreve o teu email',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 236, 236),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _controllerPassword,
                      obscureText: true, // Torna a senha oculta
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Confirmar Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 236, 236),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _controllerConfirmPassword,
                      obscureText: true, // Torna a senha oculta
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirmar Password',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _submitButton(),
                  const SizedBox(height: 10),
                  const Text(
                    'Já tens conta? Faz Login!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
