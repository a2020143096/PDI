import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/constants.dart';
import '../utils/widget/income_expense_card.dart';

class Userdata {
  String nome;
  double total;
  double ganhos;
  double despesas;

  Userdata({
    required this.nome,
    required this.total,
    required this.ganhos,
    required this.despesas,
  });

  factory Userdata.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Userdata(
      nome: data['nome'] ?? '',
      total: data['total'] ?? 0.0,
      ganhos: data['ganhos'] ?? 0.0,
      despesas: data['despesas'] ?? 0.0,
    );
  }
}

class TransactionItemTile extends StatelessWidget {
  final QueryDocumentSnapshot transaction;

  const TransactionItemTile({Key? key, required this.transaction})
      : super(key: key);

  Color getRandomBgColor() {
    return Color(Random().nextInt(0XFF000000));
  }

  @override
  Widget build(BuildContext context) {
    final data = transaction.data() as Map<String, dynamic>;
    final category = data['categoria'];
    final value = data['valor'];
    final description = data['descricao'];

    final double numericValue = double.tryParse(value.toString()) ?? 0.0;

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
          category ?? '',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: fontHeading,
                fontSize: fontSizeTitle,
                fontWeight: FontWeight.w700,
              ),
        ),
        subtitle: Text(
          description ?? '',
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

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({Key? key}) : super(key: key);

  Future<Userdata> fetchUserDataFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('utilizador')
          .doc(userId)
          .get();
      return Userdata.fromFirestore(snapshot);
    } else {
      throw Exception('Usuário não autenticado');
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
      throw Exception('Usuário não autenticado');
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
            FutureBuilder<Userdata>(
              future: fetchUserDataFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final userdata = snapshot.data!;
                  return Text("Olá, ${userdata.nome}!",
                      style: const TextStyle(fontSize: 25));
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar os dados do usuário: ${snapshot.error}');
                } else {
                  return Text('Dados do usuário não encontrados');
                }
              },
            ),
            const SizedBox(height: defaultSpacing),
            Center(
              child: Column(
                children: [
                  FutureBuilder<Userdata>(
                    future: fetchUserDataFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final userdata = snapshot.data!;
                        return Text(
                          "\€ ${userdata.total}",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: fontSizeHeading,
                                    fontWeight: FontWeight.w800,
                                  ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Erro ao carregar os dados do usuário: ${snapshot.error}');
                      } else {
                        return Text('Dados do usuário não encontrados');
                      }
                    },
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
                  child: FutureBuilder<Userdata>(
                    future: fetchUserDataFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final userdata = snapshot.data!;
                        return IncomeExpenseCard(
                          expenseData: ExpenseData(
                            "Ganhos",
                            userdata.ganhos.toStringAsFixed(2),
                            Icons.arrow_upward_rounded,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Erro ao carregar os dados do usuário: ${snapshot.error}');
                      } else {
                        return Text('Dados do usuário não encontrados');
                      }
                    },
                  ),
                ),
                const SizedBox(width: defaultSpacing),
                Expanded(
                  child: FutureBuilder<Userdata>(
                    future: fetchUserDataFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final userdata = snapshot.data!;
                        return IncomeExpenseCard(
                          expenseData: ExpenseData(
                            "Despesas",
                            userdata.despesas.toStringAsFixed(2),
                            Icons.arrow_downward_rounded,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Erro ao carregar os dados do usuário: ${snapshot.error}');
                      } else {
                        return Text('Dados do usuário não encontrados');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultSpacing * 2),
            Text(
              "Últimas transações",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
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
                      return TransactionItemTile(
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
