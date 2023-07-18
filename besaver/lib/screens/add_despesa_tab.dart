import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdicionarDespesas extends StatefulWidget {
  const AdicionarDespesas({Key? key}) : super(key: key);

  @override
  _AdicionarDespesasState createState() => _AdicionarDespesasState();
}

class _AdicionarDespesasState extends State<AdicionarDespesas> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<String> categorias;
  String? selectedCategoria;
  String? selectedTipo;
  bool isFixa = false;
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categorias = [];
    selectedCategoria = null;
    selectedTipo = 'Rendimento';
    fetchCategorias();
  }

  Future<void> fetchCategorias() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      final snapshot = await _firestore
          .collection('categorias')
          .where('userId', isEqualTo: uid)
          .get();
      final List<String> fetchedCategorias =
          snapshot.docs.map((doc) => doc.get('nome') as String).toList();
      setState(() {
        categorias = fetchedCategorias.toSet().toList();
        selectedCategoria =
            fetchedCategorias.isNotEmpty ? fetchedCategorias[0] : null;
      });
    }
  }

  Future<void> adicionarDespesa() async {
    final String? valorString = _valorController.text;
    final String? descricao = _descricaoController.text;
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (selectedCategoria != null &&
        valorString != null &&
        descricao != null &&
        uid != null) {
      final double valor = double.parse(valorString);
      final String collectionName =
          selectedTipo == 'Rendimento' ? 'rendimentos' : 'despesas';

      // Se for uma despesa, consultar o limite de gastos da categoria selecionada
      if (selectedTipo == 'Despesa') {
        final limiteSnapshot = await _firestore
            .collection('objetivo')
            .where('categoria', isEqualTo: selectedCategoria)
            .where('userId', isEqualTo: uid)
            .limit(1)
            .get();

        if (limiteSnapshot.docs.isNotEmpty) {
          final limiteData = limiteSnapshot.docs.first.data();
          final double limiteGastos = limiteData['valorMaximo'] as double;

          // Consultar o valor total gasto na categoria até o momento
          final despesasSnapshot = await _firestore
              .collection('despesas')
              .where('categoria', isEqualTo: selectedCategoria)
              .where('userId', isEqualTo: uid)
              .get();

          double totalGasto = 0;
          for (final doc in despesasSnapshot.docs) {
            totalGasto += doc.get('valor') as double;
          }

          // Verificar se o valor total gasto excede o limite
          if (totalGasto + valor > limiteGastos) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Limite de gastos excedido'),
                  content: const Text(
                      'O valor da despesa excede o limite de gastos da categoria selecionada.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            return; // Não prosseguir com a adição da despesa
          }
        }
      }

      await _firestore.collection(collectionName).add({
        'categoria': selectedCategoria,
        'valor': valor,
        'descricao': descricao,
        'fixa': isFixa,
        'userId': uid,
      });
      _valorController.clear();
      _descricaoController.clear();
      setState(() {
        isFixa = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar Despesa/Rendimento'),
          backgroundColor: const Color.fromARGB(255, 87, 124, 89),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categoria:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: DropdownButton<String>(
                          value: selectedCategoria,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategoria = newValue;
                            });
                          },
                          items: categorias
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Valor:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _valorController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um valor válido';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Insira o valor',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Descrição:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _descricaoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma descrição válida';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Insira uma descrição',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Tipo:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    RadioListTile<String>(
                      title: const Text('Rendimento'),
                      value: 'Rendimento',
                      groupValue: selectedTipo,
                      onChanged: (value) {
                        setState(() {
                          selectedTipo = value;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 87, 124, 89),
                    ),
                    RadioListTile<String>(
                      title: const Text('Despesa'),
                      value: 'Despesa',
                      groupValue: selectedTipo,
                      onChanged: (value) {
                        setState(() {
                          selectedTipo = value;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 87, 124, 89),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Despesa/Rendimento Fixo:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    CheckboxListTile(
                      title: const Text('Sim'),
                      value: isFixa,
                      onChanged: (value) {
                        setState(() {
                          isFixa = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: const Color.fromARGB(255, 87, 124, 89),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            adicionarDespesa();
                          }
                        },
                        child: const Text('Adicionar'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 87, 124, 89),
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 15.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
