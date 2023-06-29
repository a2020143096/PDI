import 'package:besaver/screens/editar.dart';
import 'package:besaver/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Transaction {
  final String categoria;
  final String descricao;
  final String valor;

  Transaction({
    required this.categoria,
    required this.descricao,
    required this.valor,
  });
}

class Carteira extends StatelessWidget {
  const Carteira({Key? key}) : super(key: key);

  Future<List<QueryDocumentSnapshot>> fetchTransactionsFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final QuerySnapshot<Map<String, dynamic>> variaveisRendimentosSnapshot =
        await FirebaseFirestore.instance
            .collection('rendimentos')
            .where('userId', isEqualTo: userId)
            .where('fixa', isEqualTo: false)
            .get();

    final QuerySnapshot<Map<String, dynamic>> variaveisDespesasSnapshot =
        await FirebaseFirestore.instance
            .collection('despesas')
            .where('userId', isEqualTo: userId)
            .where('fixa', isEqualTo: false)
            .get();

    final QuerySnapshot<Map<String, dynamic>> fixasRendimentosSnapshot =
        await FirebaseFirestore.instance
            .collection('rendimentos')
            .where('userId', isEqualTo: userId)
            .where('fixa', isEqualTo: true)
            .get();

    final QuerySnapshot<Map<String, dynamic>> fixasDespesasSnapshot =
        await FirebaseFirestore.instance
            .collection('despesas')
            .where('userId', isEqualTo: userId)
            .where('fixa', isEqualTo: true)
            .get();

    final List<QueryDocumentSnapshot> transactions = [
      ...variaveisRendimentosSnapshot.docs,
      ...variaveisDespesasSnapshot.docs,
      ...fixasRendimentosSnapshot.docs,
      ...fixasDespesasSnapshot.docs,
    ];

    return transactions;
  }

  void editarMovimento(
      BuildContext context, QueryDocumentSnapshot transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Editar(transaction: transaction)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: defaultSpacing * 4,
              ),
              ListTile(
                title: const Text(
                  "Carteira",
                  style: TextStyle(fontSize: fontSizeHeading * 2),
                ),
                trailing: SizedBox(
                  child: Image.asset(
                    "assets/icons/carteira2.png",
                  ),
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              /*Align(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/avatarr.jpg",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),*/
              const SizedBox(
                height: defaultSpacing,
              ),
              /*Center(
                child: Column(
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: fontSubHeading),
                    ),
                    /*Text(
                     "\€ ${userdata.total}",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontSize: fontSizeHeading,
                            fontWeight: FontWeight.w800,
                          ),
                    ),*/
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                  ],
                ),
              ),*/
              const SizedBox(
                height: defaultSpacing * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rendimentos variáveis",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FutureBuilder<List<QueryDocumentSnapshot>>(
                future: fetchTransactionsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> transactions =
                        snapshot.data!;
                    final List<QueryDocumentSnapshot> rendimentos = transactions
                        .where((transaction) =>
                            transaction['fixa'] == false &&
                            transaction.reference.parent.id == 'rendimentos')
                        .toList();

                    return Container(
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rendimentos.length,
                        itemBuilder: (context, index) {
                          final transaction = rendimentos[index];
                          final categoria = transaction['categoria'];
                          final descricao = transaction['descricao'];
                          final valor = transaction['valor'];

                          return ListTile(
                            onTap: () {
                              editarMovimento(context, transaction);
                            },
                            title: Text(
                              categoria,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              descricao,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "+ ${valor}€",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.green),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: defaultSpacing * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Despesas variáveis",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FutureBuilder<List<QueryDocumentSnapshot>>(
                future: fetchTransactionsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> transactions =
                        snapshot.data!;
                    final List<QueryDocumentSnapshot> despesas = transactions
                        .where((transaction) =>
                            transaction['fixa'] == false &&
                            transaction.reference.parent.id == 'despesas')
                        .toList();

                    return Container(
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: despesas.length,
                        itemBuilder: (context, index) {
                          final transaction = despesas[index];
                          final categoria = transaction['categoria'];
                          final descricao = transaction['descricao'];
                          final valor = transaction['valor'];

                          return ListTile(
                            onTap: () {
                              editarMovimento(context, transaction);
                            },
                            title: Text(
                              categoria,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              descricao,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "- ${valor}€",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: defaultSpacing * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rendimentos Fixos",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FutureBuilder<List<QueryDocumentSnapshot>>(
                future: fetchTransactionsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> transactions =
                        snapshot.data!;
                    final List<QueryDocumentSnapshot> rendimentos = transactions
                        .where((transaction) =>
                            transaction['fixa'] == true &&
                            transaction.reference.parent.id == 'rendimentos')
                        .toList();

                    return Container(
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rendimentos.length,
                        itemBuilder: (context, index) {
                          final transaction = rendimentos[index];
                          final categoria = transaction['categoria'];
                          final descricao = transaction['descricao'];
                          final valor = transaction['valor'];

                          return ListTile(
                            onTap: () {
                              editarMovimento(context, transaction);
                            },
                            title: Text(
                              categoria,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              descricao,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "+ ${valor}€",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.green),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: defaultSpacing * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Despesas Fixas",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FutureBuilder<List<QueryDocumentSnapshot>>(
                future: fetchTransactionsFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> transactions =
                        snapshot.data!;
                    final List<QueryDocumentSnapshot> despesas = transactions
                        .where((transaction) =>
                            transaction['fixa'] == true &&
                            transaction.reference.parent.id == 'despesas')
                        .toList();

                    return Container(
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(defaultRadius)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: despesas.length,
                        itemBuilder: (context, index) {
                          final transaction = despesas[index];
                          final categoria = transaction['categoria'];
                          final descricao = transaction['descricao'];
                          final valor = transaction['valor'];

                          return ListTile(
                            onTap: () {
                              editarMovimento(context, transaction);
                            },
                            title: Text(
                              categoria,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              descricao,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "- ${valor}€",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
