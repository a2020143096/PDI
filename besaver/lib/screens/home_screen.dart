import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import '../utils/widget/income_expense_card.dart';

class Userdata {
  String nome;
  double saldo;
  double ganhos;
  double despesas;

  Userdata({
    required this.nome,
    required this.saldo,
    required this.ganhos,
    required this.despesas,
  });

  factory Userdata.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    double saldo = 0.0;
    final saldoValue = data['saldo'];
    if (saldoValue is int) {
      saldo = saldoValue.toDouble();
    } else if (saldoValue is double) {
      saldo = saldoValue;
    }
    return Userdata(
      nome: data['nome'] ?? '',
      saldo: saldo,
      ganhos: data['ganhos'] ?? 0.0,
      despesas: data['despesas'] ?? 0.0,
    );
  }
}

class Movimentos extends StatelessWidget {
  final QueryDocumentSnapshot transaction;

  const Movimentos({Key? key, required this.transaction}) : super(key: key);

  Color getRandomBgColor() {
    return Color(Random().nextInt(0XFF000000));
  }

  @override
  Widget build(BuildContext context) {
    final data = transaction.data() as Map<String, dynamic>;
    final categoria = data['categoria'];
    final valor = data['valor'];
    final descricao = data['descricao'];

    final double numericValue = double.tryParse(valor.toString()) ?? 0.0;

    String valuePrefix;
    Color textColor;
    if (transaction.reference.parent.id == 'despesas') {
      valuePrefix = "-€ ";
      textColor = Colors.red;
    } else if (transaction.reference.parent.id == 'rendimentos') {
      valuePrefix = "+€ ";
      textColor = Colors.green;
    } else {
      valuePrefix = "€ ";
      textColor = Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: defaultSpacing / 2),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset.zero,
            blurRadius: 10,
            spreadRadius: 4,
          ),
        ],
        color: background,
        borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
      ),
      child: ListTile(
        title: Text(
          categoria ?? '',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: fontHeading,
                fontSize: fontSizeTitle,
                fontWeight: FontWeight.w700,
              ),
        ),
        subtitle: Text(
          descricao ?? '',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: fontSubHeading,
                fontSize: fontSizeBody,
              ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$valuePrefix${numericValue.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: textColor,
                    fontSize: fontSizeBody,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Userdata? userData;
  double totalGanhos = 0.0;
  double totalDespesas = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserDataFromFirestore();
    fetchTotalGanhos();
    fetchTotalDespesas();
  }

  Future<void> fetchUserDataFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('utilizador')
          .doc(userId)
          .get();
      final userData = Userdata.fromFirestore(snapshot);
      setState(() {
        this.userData = userData;
      });
    } else {
      throw Exception('Utilizador não autenticado');
    }
  }

  Future<void> fetchTotalGanhos() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('rendimentos')
          .where('userId', isEqualTo: userId)
          .get();
      double totalGanhos = 0;
      snapshot.docs.forEach((doc) {
        final valor = doc.data()['valor'];
        if (valor is int) {
          totalGanhos += valor.toDouble();
        } else if (valor is double) {
          totalGanhos += valor;
        }
      });

      setState(() {
        this.totalGanhos = totalGanhos;
      });
    } else {
      throw Exception('Utilizador não autenticado');
    }
  }

  Future<void> fetchTotalDespesas() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('despesas')
          .where('userId', isEqualTo: userId)
          .get();
      double totalDespesas = 0;
      snapshot.docs.forEach((doc) {
        final valor = doc.data()['valor'];
        if (valor is int) {
          totalDespesas += valor.toDouble();
        } else if (valor is double) {
          totalDespesas += valor;
        }
      });

      setState(() {
        this.totalDespesas = totalDespesas;
      });
    } else {
      throw Exception('Utilizador não autenticado');
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchTransactionsFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final QuerySnapshot<Map<String, dynamic>> ganhosSnapshot =
          await FirebaseFirestore.instance
              .collection('rendimentos')
              .where('userId', isEqualTo: userId)
              .get();

      final QuerySnapshot<Map<String, dynamic>> despesasSnapshot =
          await FirebaseFirestore.instance
              .collection('despesas')
              .where('userId', isEqualTo: userId)
              .get();

      final List<QueryDocumentSnapshot> transactions = [
        ...ganhosSnapshot.docs.map((doc) => doc..data()['type'] = 'ganhos'),
        ...despesasSnapshot.docs.map((doc) => doc..data()['type'] = 'despesas'),
      ];

      return transactions;
    } else {
      throw Exception('Utilizador não autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: defaultSpacing * 4),
            if (userData != null)
              Text("Olá, ${userData!.nome}!",
                  style: const TextStyle(fontSize: 25)),
            const SizedBox(height: defaultSpacing),
            Center(
              child: Column(
                children: [
                  if (userData != null)
                    Text(
                      "€ ${userData?.saldo.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontSize: fontSizeHeading,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  const SizedBox(height: defaultSpacing / 2),
                  Text(
                    "Total",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: fontSubHeading),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultSpacing * 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: IncomeExpenseCard(
                    expenseData: ExpenseData(
                      "Rendimentos",
                      totalGanhos.toStringAsFixed(2),
                      Icons.arrow_upward_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: defaultSpacing),
                Expanded(
                  child: IncomeExpenseCard(
                    expenseData: ExpenseData(
                      "Despesas",
                      totalDespesas.toStringAsFixed(2),
                      Icons.arrow_downward_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultSpacing * 2),
            Text(
              "Últimas transações",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: fontSizeHeading),
            ),
            const SizedBox(height: defaultSpacing),
            FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchTransactionsFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final transactions = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return Movimentos(
                        transaction: transactions[index],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar as transações: ${snapshot.error}');
                } else {
                  return Text('Nenhuma transação encontrada');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
