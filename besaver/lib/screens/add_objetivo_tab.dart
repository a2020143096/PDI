import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';

class AdicionarObjetivos extends StatefulWidget {
  AdicionarObjetivos({Key? key}) : super(key: key);

  @override
  _AdicionarObjetivosState createState() => _AdicionarObjetivosState();
}

class _AdicionarObjetivosState extends State<AdicionarObjetivos> {
  late TextEditingController _nomeController;
  late TextEditingController _valorMaximoController;
  DateTime _dataLimite = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _categorias = [];
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _valorMaximoController = TextEditingController();
    _carregarCategorias();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorMaximoController.dispose();
    super.dispose();
  }

  Future<void> _adicionarObjetivo() async {
    String nome = _nomeController.text.trim();
    String valorMaximo = _valorMaximoController.text.trim();

    if (nome.isNotEmpty && valorMaximo.isNotEmpty && _isNumeric(valorMaximo)) {
      User? user = _auth.currentUser;
      String? uid = user?.uid;

      if (uid != null) {
        await _firestore.collection('objetivo').add({
          'nome': nome,
          //'dataLimite': _dataLimite,
          'valorMaximo': double.parse(valorMaximo),
          'categoria': _categoriaSelecionada,
          'userId': uid,
        });

        _nomeController.clear();
        _valorMaximoController.clear();

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
      }
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

  Future<void> _carregarCategorias() async {
    User? user = _auth.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('categorias')
          .where('userId', isEqualTo: uid)
          .get();

      List<String> categorias =
          snapshot.docs.map((doc) => doc['nome'] as String).toList();

      setState(() {
        _categorias = categorias;
      });
    }
  }

  Widget _buildObjetivosList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('objetivo')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        List<Widget> objetivosWidgets = [];
        final objetivos = snapshot.data!.docs;
        for (var objetivo in objetivos) {
          final objetivoNome = objetivo['nome'] as String;
          final objetivoValorMaximo = objetivo['valorMaximo'] as double;
          final objetivoCategoria =
              objetivo['categoria'] as String? ?? 'Categoria não definida';

          final objetivoWidget = ListTile(
            title: Text(objetivoNome),
            subtitle: Text('Valor Máximo: €$objetivoValorMaximo'),
            trailing: Text('Categoria: $objetivoCategoria'),
          );

          objetivosWidgets.add(objetivoWidget);
        }

        return Column(
          children: objetivosWidgets,
        );
      },
    );
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
          "Adicionar Máximo de despesa",
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
                    /*const Text(
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
                    ),*/
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Valor máximo de despesa:',
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
                      controller: _valorMaximoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Valor máximo de despesa',
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
                    const Text(
                      'Categoria:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 87, 124, 89),
                      ),
                    ),
                    const SizedBox(height: defaultSpacing / 2),
                    DropdownButtonFormField<String>(
                      value: _categoriaSelecionada,
                      items: _categorias.map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                      onChanged: (categoria) {
                        setState(() {
                          _categoriaSelecionada = categoria;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecione a categoria',
                      ),
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
                    const SizedBox(height: 20.0),
                    const Text(
                      'Objetivos Registados:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 87, 124, 89),
                      ),
                    ),
                    _buildObjetivosList(),
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
    home: AdicionarObjetivos(),
  ));
}
