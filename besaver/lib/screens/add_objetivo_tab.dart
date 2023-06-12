import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class AddObjetivoTab extends StatefulWidget {
  AddObjetivoTab({Key? key}) : super(key: key);

  @override
  _AddObjetivoTabState createState() => _AddObjetivoTabState();
}

class _AddObjetivoTabState extends State<AddObjetivoTab> {
  late TextEditingController _nomeController;
  late TextEditingController _valorPouparController;
  DateTime _dataLimite = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _valorPouparController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorPouparController.dispose();
    super.dispose();
  }

  Future<void> _adicionarObjetivo() async {
    String nome = _nomeController.text.trim();
    String valorPoupar = _valorPouparController.text.trim();

    if (nome.isNotEmpty && valorPoupar.isNotEmpty && _isNumeric(valorPoupar)) {
      await _firestore.collection('objetivo').add({
        'nome': nome,
        'dataLimite': _dataLimite,
        'valorPoupar': double.parse(valorPoupar),
      });
      _nomeController.clear();
      _valorPouparController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Objetivo Adicionado'),
            content: const Text('O objetivo foi adicionado com sucesso.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Por favor, insira um valor numérico válido.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool _isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Adicionar Objetivo de Poupança",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 87, 124, 89),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nome:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 87, 124, 89),
                      ),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nome a dar ao objetivo',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Data Limite:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 87, 124, 89),
                      ),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: _dataLimite,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100, 12, 31),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              _dataLimite = selectedDate;
                            });
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(_dataLimite),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Valor que deseja poupar:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 87, 124, 89),
                      ),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    TextFormField(
                      controller: _valorPouparController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Valor a poupar',
                        prefix: Text('€'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um valor.';
                        }
                        if (!_isNumeric(value)) {
                          return 'Por favor, insira um valor numérico válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(
                      height: defaultSpacing * 4,
                    ),
                    ElevatedButton(
                      onPressed: _adicionarObjetivo,
                      child: const Text('Adicionar'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 87, 124, 89),
                        textStyle: const TextStyle(fontSize: 20.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
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

void main() {
  runApp(MaterialApp(
    home: AddObjetivoTab(),
  ));
}
