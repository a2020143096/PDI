import 'package:besaver/screens/ajuda.dart';
import 'package:besaver/screens/editar_perfil.dart';
import 'package:besaver/screens/meus_dados.dart';
import 'package:besaver/screens/notificacao.dart';
import 'package:besaver/screens/pinicial.dart';
import 'package:besaver/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/widget/profile_account_info_tile.dart';

class HomeProfileTab extends StatelessWidget {
  const HomeProfileTab({Key? key}) : super(key: key);

  void _handleProfileAccountInfoTileClick(
      BuildContext context, String heading) {
    if (heading == "Meus Dados") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MeusDados()));
    } else if (heading == "Notificações") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Notificacoes()));
    } else if (heading == "Ajuda") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Ajuda()));
    } else if (heading == "Terminar sessão") {
      FirebaseAuth.instance.signOut().then((_) {
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
            padding: const EdgeInsets.all(defaultSpacing),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(defaultRadius)),
                          child: Image.asset(
                            "assets/images/avatarr.jpg",
                            width: 70,
                          ),
                        ),
                        const SizedBox(height: defaultSpacing / 3),
                        Text(
                          "Mariana Simões",
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "marianasimoez@gmail.com",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: defaultSpacing / 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditarPerfil()),
                            );
                          },
                          child: const Chip(
                            backgroundColor: Color.fromARGB(255, 87, 124, 89),
                            label: Text(
                              "Editar Perfil",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultSpacing * 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: defaultSpacing),
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
                        height: defaultSpacing * 2,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Meus Dados"),
                        child: const ProfileAccountInfoTile(
                          iconUrl: "assets/icons/user.png",
                          heading: "Meus Dados",
                        ),
                      ),
                      const SizedBox(
                        height: defaultSpacing * 2,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Notificações"),
                        child: const ProfileAccountInfoTile(
                          iconUrl: "assets/icons/notification.png",
                          heading: "Notificações",
                        ),
                      ),
                      const SizedBox(
                        height: defaultSpacing * 2,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Ajuda"),
                        child: const ProfileAccountInfoTile(
                          iconUrl: "assets/icons/question.png",
                          heading: "Ajuda",
                        ),
                      ),
                      const SizedBox(
                        height: defaultSpacing * 2,
                      ),
                      GestureDetector(
                        onTap: () => _handleProfileAccountInfoTileClick(
                            context, "Terminar sessão"),
                        child: const ProfileAccountInfoTile(
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
