import 'dart:math';
import 'package:besaver/data/userInfo.dart';
import 'package:besaver/utils/constants.dart';
import 'package:besaver/utils/widget/income_expense_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<List<QueryDocumentSnapshot>> fetchTransactionsFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> inflowSnapshot =
        await FirebaseFirestore.instance.collection('rendimentos').get();

    final QuerySnapshot<Map<String, dynamic>> outflowSnapshot =
        await FirebaseFirestore.instance.collection('despesas').get();

    final List<QueryDocumentSnapshot> transactions = [
      ...inflowSnapshot.docs.map((doc) => doc..data()['type'] = 'inflow'),
      ...outflowSnapshot.docs.map((doc) => doc..data()['type'] = 'outflow'),
    ];

    return transactions;
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
            ListTile(
              title: Text("Olá, ${userdata.name}!"),
              leading: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultRadius),
                ),
                child: Image.asset("assets/images/avatarr.jpg"),
              ),
              trailing: Image.asset("assets/icons/bell.png"),
            ),
            const SizedBox(height: defaultSpacing),
            Center(
              child: Column(
                children: [
                  Text(
                    "\€ ${userdata.totalBalance}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                      "Ganhos",
                      "\€ ${userdata.inflow}",
                      Icons.arrow_upward_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: defaultSpacing),
                Expanded(
                  child: IncomeExpenseCard(
                    expenseData: ExpenseData(
                      "Despesas",
                      "-\€ ${userdata.outflow}",
                      Icons.arrow_downward_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultSpacing * 2),
            Text(
              "Ultimos Movimentos",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: defaultSpacing),
            FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchTransactionsFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final List<QueryDocumentSnapshot> transactions =
                      snapshot.data!;
                  return Column(
                    children: transactions
                        .map(
                          (transaction) => TransactionItemTile(
                            transaction: transaction,
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return const Text('Erro ao carregar os dados');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
