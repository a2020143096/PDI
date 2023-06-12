enum TransactionType { outflow, inflow }

enum ItemCategoryType { fashion, grocery, payments }

class UserInfo {
  final String name;
  final String totalBalance;
  final String inflow;
  final String outflow;
  final List<Transaction> transactions;

  const UserInfo(
      {required this.name,
      required this.totalBalance,
      required this.inflow,
      required this.outflow,
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
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Calçado",
      "Air Force 1", "\€130.00", "Out, 23"),
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Carteira",
      "Gucci Flax", "\€10,500.00", "Set, 13")
];

const List<Transaction> transactions2 = [
  Transaction(ItemCategoryType.payments, TransactionType.inflow, "Pagamento",
      "Tranferência de Bruno", "\€13,000.00", "Out, 2"),
  Transaction(ItemCategoryType.payments, TransactionType.inflow, "Pagamento",
      "Transferência para Leonor", "\€15.00", "Out, 10"),
  Transaction(ItemCategoryType.payments, TransactionType.outflow, "Renda",
      "Tranferência para Agostinho", "\€210.00", "Out, 12"),
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Casaco",
      "The North Face", "\€230.00", "Out, 9")
];

const userdata = UserInfo(
    name: "Mariana",
    totalBalance: "4,586.00",
    inflow: "4,000.00",
    outflow: "2,000.00",
    transactions: transactions1);
