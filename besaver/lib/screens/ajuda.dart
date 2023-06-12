import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Ajuda extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32.0),
              ListTile(
                title: const Text(
                  "Ajuda",
                  style: TextStyle(fontSize: 32.0),
                ),
                trailing: SizedBox(
                  child: Image.asset("assets/icons/ajuda2.png"),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 10),
              const Text(
                "A BeSaver foi criada com o objetivo de te ajudar a gerir as tuas despesas e a poupar dinheiro. Aqui podes questionar todas as tuas dúvidas, nós tentamos responder o mais rápido possível.",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(201, 56, 53, 53),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 30),
              const Text(
                "Envia as tuas questões!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(500, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 237, 236, 236),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Insere o teu email',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 237, 236, 236),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 385,
                child: TextFormField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Coloca aqui a tua questão',
                  ),
                  maxLines: 8,
                  maxLength: 400,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final String email = emailController.text;
                      final String question = questionController.text;

                      FirebaseFirestore.instance.collection('questoes').add({
                        'email': email,
                        'question': question,
                      }).then((_) {
                        emailController.clear();
                        questionController.clear();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sucesso'),
                              content:
                                  const Text('Questão enviada com sucesso!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }).catchError((error) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Erro'),
                              content: Text(
                                  'Ocorreu um erro ao enviar a questão: $error'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 189, 220, 154),
                      textStyle: const TextStyle(fontSize: 20.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                    ),
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
