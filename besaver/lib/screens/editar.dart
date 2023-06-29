import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Editar extends StatefulWidget {
  final QueryDocumentSnapshot transaction;

  Editar({required this.transaction});

  @override
  _EditarState createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  TextEditingController categoriaController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoriaController.text = widget.transaction['categoria'];
    descricaoController.text = widget.transaction['descricao'];
    valorController.text = widget.transaction['valor'].toString();
  }

  void eliminarTransacao() {
    widget.transaction.reference.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Movimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoriaController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.transaction.reference.update({
                  'categoria': categoriaController.text,
                  'descricao': descricaoController.text,
                  'valor': valorController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar Alterações'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmação'),
                    content:
                        const Text('Deseja mesmo eliminar este movimento?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          eliminarTransacao();
                          Navigator.pop(context);
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Eliminar'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
