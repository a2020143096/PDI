import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { despesas, ganhos }

enum ItemCategoryType { fashion, grocery, payments }

class UserInfo {
  final String name;
  final String totalBalance;
  final String ganhos;
  final String despesas;
  final List<Transaction> transactions;

  const UserInfo(
      {required this.name,
      required this.totalBalance,
      required this.ganhos,
      required this.despesas,
      required this.transactions});
}

class Transaction {
  final ItemCategoryType categoryType;
  final TransactionType transactionType;
  final String itemCategoryName;
  final String itemName;
  final String amount;
  final String date;

  const Transaction(this.categoryType, this.transactionType,
      this.itemCategoryName, this.itemName, this.amount, this.date);
}

const List<Transaction> transactions1 = [
  Transaction(ItemCategoryType.fashion, TransactionType.despesas, "Calçado",
      "Air Force 1", "\€130.00", "Out, 23"),
  Transaction(ItemCategoryType.fashion, TransactionType.despesas, "Carteira",
      "Gucci Flax", "\€10,500.00", "Set, 13")
];

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
