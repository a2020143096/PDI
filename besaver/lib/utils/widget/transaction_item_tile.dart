import 'dart:math';
import 'package:besaver/data/userInfo.dart';
import 'package:besaver/utils/constants.dart';
import 'package:flutter/material.dart';

class TransactionItemTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemTile({key, required this.transaction}) : super(key: key);

  String getSign(TransactionType type) {
    switch (type) {
      case TransactionType.ganhos:
        return "+";
      case TransactionType.despesas:
        return "-";
    }
  }

  Color getRandomBgColor() {
    return Color(Random().nextInt(0XFF000000));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: defaultSpacing / 2),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset.zero,
                  blurRadius: 10,
                  spreadRadius: 4)
            ],
            color: background,
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
        child: ListTile(
          leading: Container(
              padding: const EdgeInsets.all(defaultSpacing / 2),
              decoration: BoxDecoration(
                  color: getRandomBgColor(),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultRadius / 2))),
              child: transaction.categoryType == ItemCategoryType.fashion
                  ? const Icon(Icons.supervised_user_circle_sharp)
                  : const Icon(Icons.house)),
          title: Text(transaction.itemCategoryName,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: fontHeading,
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w700)),
          subtitle: Text(
            transaction.itemName,
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
                "${getSign(transaction.transactionType)} ${transaction.amount}",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color:
                        transaction.transactionType == TransactionType.despesas
                            ? Colors.red
                            : fontHeading,
                    fontSize: fontSizeBody),
              ),
              Text(
                transaction.date,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: fontSubHeading,
                      fontSize: fontSizeBody,
                    ),
              )
            ],
          ),
        ));
  }
}
