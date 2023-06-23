import 'package:besaver/screens/ajuda.dart';
import 'package:besaver/screens/editar_perfil.dart';
import 'package:besaver/screens/meus_dados.dart';
import 'package:besaver/screens/notificacao.dart';
import 'package:besaver/screens/pinicial.dart';
import 'package:besaver/utils/widget/profile_account_info_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProfileTab extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    String? userId = _firebaseAuth.currentUser?.uid;
    if (userId != null) {
      return await _firestore.collection('utilizador').doc(userId).get();
    } else {
      throw Exception('Usuário não autenticado');
    }
  }

  void _handleProfileAccountInfoTileClick(
      BuildContext context, String heading) {
    if (heading == "Meus Dados") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MeusDados()));
    } else if (heading == "Notificações") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Notificacoes()));
    } else if (heading == "Ajuda") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Ajuda()));
    } else if (heading == "Terminar sessão") {
      _firebaseAuth.signOut().then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Pinicial()),
          (Route<dynamic> route) => false,
        );
      }).catchError((error) {
        print("Erro durante a terminar sessão: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Material(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Center(
                    child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Erro ao carregar os dados do usuário');
                        }
                        if (!snapshot.hasData) {
                          return Text('Dados do usuário não encontrados');
                        }

                        var userData = snapshot.data!.data();
                        var nome = userData?['nome'];
                        var email = userData?['email'];
                        var foto = userData?['foto'];

                        return Column(
                          children: [
                            /*ClipRRect(
                              borderRadius: BorderRadius.circular(35.0),
                              child: Image.network(
                                photoUrl,
                                width: 70.0,
                              ),
                            ),*/

                            Text(
                              nome ?? 'Nome não encontrado',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontSize: 27,
                                    color: Colors.black,
                                  ),
                            ),
                            Text(
                              email ?? 'Email não encontrado',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: Colors.grey, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditarPerfil()),
                                );
                              },
                              child: Chip(
                                backgroundColor:
                                    Color.fromARGB(255, 87, 124, 89),
                                label: Text(
                                  "Editar Perfil",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Conta",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 87, 124, 89),
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Meus Dados"),
                        child: ProfileAccountInfoTile(
                          iconUrl: "assets/icons/user.png",
                          heading: "Meus Dados",
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Notificações"),
                        child: ProfileAccountInfoTile(
                          iconUrl: "assets/icons/notification.png",
                          heading: "Notificações",
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Ajuda"),
                        child: ProfileAccountInfoTile(
                          iconUrl: "assets/icons/question.png",
                          heading: "Ajuda",
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Terminar sessão"),
                        child: ProfileAccountInfoTile(
                          iconUrl: "assets/icons/logout.png",
                          heading: "Terminar sessão",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
