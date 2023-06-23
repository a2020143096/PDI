import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega os dados do Firestore ao iniciar a página
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('utilizador')
          .doc(userId)
          .get();
      final userData =
          userDoc.data() as Map<String, dynamic>; // Conversão explícita
      setState(() {
        _nomeController.text = userData['nome'];
        _emailController.text = userData['email'];
      });
    } catch (error) {
      print('Erro ao carregar dados do usuário: $error');
    }
  }

  Future<void> _saveUserData() async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      final newData = {
        'nome': _nomeController.text,
      };

      await FirebaseFirestore.instance
          .collection('utilizador')
          .doc(userId)
          .update(newData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar dados')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Editar Perfil',
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
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/avatarr.jpg'),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                          color: const Color.fromARGB(255, 87, 124, 89),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Alterar Nome Completo',
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
                      'Alterar Email',
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
                        enabled: false, // Impede a edição do campo de e-mail
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: _emailController.text,
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
                      'Alterar Password',
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 87, 124, 89),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                        'Guardar Alterações',
                        style: TextStyle(
                          fontSize: 20,
                        ),
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
