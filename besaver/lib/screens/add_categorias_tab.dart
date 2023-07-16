import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class AddCategoriasTab extends StatefulWidget {
  const AddCategoriasTab({Key? key}) : super(key: key);

  @override
  _AddCategoriasTabState createState() => _AddCategoriasTabState();
}

class _AddCategoriasTabState extends State<AddCategoriasTab> {
  TextEditingController nomeCategoriaController = TextEditingController();

  void eliminarMovimentos(String categoriaId) async {
    try {
      final QuerySnapshot movimentosSnapshot = await FirebaseFirestore.instance
          .collection('movimentos')
          .where('categoriaId', isEqualTo: categoriaId)
          .get();

      for (final DocumentSnapshot doc in movimentosSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      print('Erro ao eliminar movimento: $error');
    }
  }

  void eliminarCategoria(String categoriaId) async {
    try {
      eliminarMovimentos(categoriaId);

      await FirebaseFirestore.instance
          .collection('categorias')
          .doc(categoriaId)
          .delete();
    } catch (error) {
      print('Erro ao eliminar categoria: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 124, 89),
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Categorias',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categorias')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var categoria = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>?;
                        if (categoria != null &&
                            categoria.containsKey('nome')) {
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(defaultSpacing / 2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(defaultRadius / 2),
                                ),
                              ),
                              child: const Icon(Icons.done_outline_rounded),
                            ),
                            title: Text(
                              categoria['nome'] as String,
                              style: const TextStyle(
                                color: fontHeading,
                                fontSize: fontSizeTitle,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmar eliminação'),
                                      content: const Text(
                                          'Deseja mesmo eliminar esta categoria?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Eliminar'),
                                          onPressed: () {
                                            eliminarCategoria(
                                                snapshot.data!.docs[index].id);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 17.0),
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Adicionar nova categoria',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 236, 236),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: nomeCategoriaController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      hintText: 'Nome',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 17.0),
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: registarCategoria,
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 87, 124, 89),
                      textStyle: const TextStyle(fontSize: 20.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                    ),
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registarCategoria() async {
    String nomeCategoria = nomeCategoriaController.text.trim();

    if (nomeCategoria.isNotEmpty) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final String? uid = user?.uid;

        if (uid != null) {
          await FirebaseFirestore.instance.collection('categorias').add({
            'nome': nomeCategoria,
            'userId': uid,
          });

          nomeCategoriaController.clear();
        }
      } catch (error) {
        print('Erro ao adicionar categoria: $error');
      }
    }
  }
}
