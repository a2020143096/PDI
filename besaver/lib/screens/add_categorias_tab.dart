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
  bool hasLimit = false;
  int valorLimite = 0;

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
                          String valor = categoria.containsKey('valor')
                              ? categoria['valor'].toString() + '€'
                              : '';

                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(defaultSpacing / 2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(defaultRadius / 2),
                                ),
                              ),
                              child: const Icon(Icons.house),
                            ),
                            title: Text(
                              categoria['nome'] as String,
                              style: const TextStyle(
                                color: fontHeading,
                                fontSize: fontSizeTitle,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(valor),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: hasLimit,
                      onChanged: (value) {
                        setState(() {
                          hasLimit = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Limite',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 67, 66, 66),
                      ),
                    ),
                    if (hasLimit) ...[
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () {
                          showPicker();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            valorLimite.toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
                    onPressed: registrarCategoria,
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

  void showPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textController =
            TextEditingController(text: valorLimite.toString());
        return AlertDialog(
          title: const Text('Escolha o Valor Limite'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor Limite',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  valorLimite = int.tryParse(textController.text) ?? 0;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void registrarCategoria() async {
    String nomeCategoria = nomeCategoriaController.text.trim();
    double? valor;

    if (nomeCategoria.isNotEmpty) {
      try {
        if (hasLimit) {
          valor = valorLimite.toDouble();
        }

        await FirebaseFirestore.instance.collection('categorias').add({
          'nome': nomeCategoria,
          'valor': valor,
          'hasLimit': hasLimit,
        });

        nomeCategoriaController.clear();
        setState(() {
          hasLimit = false;
          valorLimite = 0;
        });
      } catch (error) {
        print('Erro ao adicionar categoria: $error');
      }
    }
  }
}
