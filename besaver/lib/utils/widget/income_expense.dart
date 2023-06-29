import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:besaver/utils/constants.dart';

class ExpenseData {
  final String label;
  final String amount;
  final IconData icon;

  const ExpenseData(this.label, this.amount, this.icon);
}

class IncomeExpenseCard extends StatefulWidget {
  final ExpenseData expenseData;

  const IncomeExpenseCard({Key? key, required this.expenseData})
      : super(key: key);

  @override
  _IncomeExpenseCardState createState() => _IncomeExpenseCardState();
}

class _IncomeExpenseCardState extends State<IncomeExpenseCard> {
  double totalIncome = 0;
  double totalExpense = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalIncome();
    fetchTotalExpense();
  }

  Future<void> fetchTotalIncome() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('rendimentos')
          .where('userId', isEqualTo: userId)
          .get();
      double income = 0;
      snapshot.docs.forEach((doc) {
        final valor = doc.data()['valor'];
        if (valor is int) {
          income += valor.toDouble();
        } else if (valor is double) {
          income += valor;
        }
      });
      setState(() {
        totalIncome = income;
        updateTotal();
      });
    }
  }

  Future<void> fetchTotalExpense() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('despesas')
          .where('userId', isEqualTo: userId)
          .get();
      double expense = 0;
      snapshot.docs.forEach((doc) {
        final valor = doc.data()['valor'];
        if (valor is int) {
          expense += valor.toDouble();
        } else if (valor is double) {
          expense += valor;
        }
      });
      setState(() {
        totalExpense = expense;
        updateTotal();
      });
    }
  }

  void updateTotal() {
    setState(() {
      total = totalIncome - totalExpense;
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      FirebaseFirestore.instance
          .collection('utilizador')
          .doc(userId)
          .update({'saldo': total});
    }
  }

  @override
  Widget build(BuildContext context) {
    final String valuePrefix =
        widget.expenseData.label == "Rendimentos" ? "+€ " : "-€ ";

    String formattedAmount;
    final amount = double.tryParse(widget.expenseData.amount);
    if (amount != null) {
      formattedAmount = amount.toStringAsFixed(2);
    } else {
      formattedAmount = '';
    }

    return Container(
      height: 80,
      padding: const EdgeInsets.all(defaultSpacing),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset.zero,
            spreadRadius: 3,
            blurRadius: 12,
          )
        ],
        color: widget.expenseData.label == "Rendimentos"
            ? Color.fromARGB(255, 87, 124, 89)
            : accent,
        borderRadius: const BorderRadius.all(Radius.circular(defaultRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expenseData.label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: defaultSpacing / 3),
                  child: Text(
                    '$valuePrefix$formattedAmount',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            widget.expenseData.icon,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
