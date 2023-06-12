import 'package:besaver/utils/constants.dart';
import 'package:flutter/material.dart';

class Notificacoes extends StatefulWidget {
  const Notificacoes({Key, key}) : super(key: key);

  @override
  _NotificacoesState createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: defaultSpacing * 4,
              ),
              ListTile(
                title: const Text(
                  "Notificações",
                  style: TextStyle(fontSize: fontSizeHeading * 2),
                ),
                trailing: SizedBox(
                  child: Image.asset(
                    "assets/icons/notificacao2.png",
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 50),
              const Text(
                "Ativa e define as tuas notificações! Recebe alertas quando atinges os teus limites!",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(201, 56, 53, 53),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Container(
                color: Colors.black.withOpacity(0.1),
                height: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ativa as notificações",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(500, 0, 0, 0),
                    ),
                  ),
                  Switch(
                    value: isNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        isNotificationEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (isNotificationEnabled)
                Container(
                  width: 500,
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Quando pretendes receber notificação?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 189, 220, 154),
                      textStyle: const TextStyle(fontSize: 20.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
