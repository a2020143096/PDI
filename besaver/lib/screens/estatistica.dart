import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final String userId;

  Categoria(this.nome, this.userId);
}

class Despesa {
  final Categoria categoria;
  final String descricao;
  final bool fixa;
  final String userId;
  final double valor;

  Despesa(this.categoria, this.descricao, this.fixa, this.userId, this.valor);
}

class Rendimento {
  final Categoria categoria;
  final String descricao;
  final bool fixa;
  final String userId;
  final double valor;

  Rendimento(
      this.categoria, this.descricao, this.fixa, this.userId, this.valor);
}

class Estatistica extends StatefulWidget {
  const Estatistica({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EstatisticaState();
}

class EstatisticaState extends State<Estatistica> {
  int touchedIndex = -1;

  List<Categoria> categorias = [];
  List<Despesa> despesas = [];
  List<Rendimento> rendimentos = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      final categoriasSnapshot = await FirebaseFirestore.instance
          .collection('categorias')
          .where('userId', isEqualTo: userId)
          .get();

      final despesasSnapshot = await FirebaseFirestore.instance
          .collection('despesas')
          .where('userId', isEqualTo: userId)
          .get();

      final rendimentosSnapshot = await FirebaseFirestore.instance
          .collection('rendimentos')
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        categorias = categoriasSnapshot.docs
            .map((doc) => Categoria(doc['nome'], doc['userId']))
            .toList();

        despesas = despesasSnapshot.docs.map((doc) {
          final categoriaId = doc['categoria'];
          final categoria = categorias.firstWhere(
            (cat) => cat.userId == categoriaId,
            orElse: () => Categoria('', ''),
          );

          return Despesa(
            categoria,
            doc['descricao'],
            doc['fixa'],
            doc['userId'],
            doc['valor'],
          );
        }).toList();

        rendimentos = rendimentosSnapshot.docs.map((doc) {
          final categoriaId = doc['categoria'];
          final categoria = categorias.firstWhere(
            (cat) => cat.userId == categoriaId,
            orElse: () => Categoria('', ''),
          );

          return Rendimento(
            categoria,
            doc['descricao'],
            doc['fixa'],
            doc['userId'],
            doc['valor'],
          );
        }).toList();
      });
    }
  }

  Widget GraficoDespesas() {
    List<PieChartSectionData> expenseSections = despesas.map((despesa) {
      final double value = despesa.valor;
      final String title =
          '${despesa.categoria.nome} (${value.toStringAsFixed(2)})';
      final String description = despesa.descricao;

      return PieChartSectionData(
        value: value,
        title: '$title\n$description',
        color: getRandomColor(),
        radius: 100,
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: expenseSections,
                centerSpaceRadius: 0,
                sectionsSpace: 0,
                pieTouchData: PieTouchData(touchCallback:
                    (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                  setState(() {
                    final desiredTouch =
                        event is! PointerExitEvent && event is! PointerUpEvent;
                    if (desiredTouch &&
                        pieTouchResponse != null &&
                        pieTouchResponse.touchedSection != null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    } else {
                      touchedIndex = -1;
                    }
                  });
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget GraficoRendimentos() {
    List<PieChartSectionData> incomeSections = rendimentos.map((rendimento) {
      final double value = rendimento.valor;
      final String title =
          '${rendimento.categoria.nome} (${value.toStringAsFixed(2)})';
      final String description = rendimento.descricao;

      return PieChartSectionData(
        value: value,
        title: '$title\n$description',
        color: getRandomColor(),
        radius: 100,
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: incomeSections,
                centerSpaceRadius: 0,
                sectionsSpace: 0,
                pieTouchData: PieTouchData(touchCallback:
                    (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                  setState(() {
                    final desiredTouch =
                        event is! PointerExitEvent && event is! PointerUpEvent;
                    if (desiredTouch &&
                        pieTouchResponse != null &&
                        pieTouchResponse.touchedSection != null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    } else {
                      touchedIndex = -1;
                    }
                  });
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estatísticas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Despesas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: GraficoDespesas(),
            ),
            SizedBox(height: 16),
            const Text(
              'Rendimentos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: GraficoRendimentos(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
