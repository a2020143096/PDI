import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeusDados extends StatefulWidget {
  @override
  _MeusDadosState createState() => _MeusDadosState();
}

class _MeusDadosState extends State<MeusDados> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isNameChanged = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await _firestore.collection('utilizador').doc(userId).get();
        setState(() {
          _nomeController.text = userData.data()?['nome'] ?? '';
          _emailController.text = userData.data()?['email'] ?? '';
        });
      } else {
        throw Exception('Usuário não autenticado');
      }
    } catch (e) {
      // Tratar o erro adequadamente
      print('Erro ao carregar os dados do usuário: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      if (userId != null && _isNameChanged) {
        await _firestore.collection('utilizador').doc(userId).update({
          'nome': _nomeController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso.')),
        );
        setState(() {
          _isNameChanged = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum dado alterado.')),
        );
      }
    } catch (e) {
      // Tratar o erro adequadamente
      print('Erro ao salvar os dados do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Meus Dados',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 69, 67, 67),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(height: 30),
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
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nome',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isNameChanged = true;
                          });
                        },
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
                        controller: _emailController,
                        enabled: false, // Desabilita a edição do campo de texto
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'email',
                        ),
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
                            'Saldo',
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
                              //controller: _emailController,
                              enabled:
                                  false, // Desabilita a edição do campo de texto
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'saldo',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isNameChanged) // Exibe o botão "Salvar" somente se o nome foi alterado
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: _saveUserData,
                          child: const Text('Salvar'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
