import 'package:flutter/material.dart';

class Editar extends StatefulWidget {
  const Editar({key}) : super(key: key);

  @override
  State<Editar> createState() => _EditarState();
}

enum Gender { male, female }

Gender? _gender = Gender.male;

class _EditarState extends State<Editar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 130),
                  width: double.maxFinite,
                  height: 230,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 2, 130, 6)),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Editar",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            Positioned(
                left: 15,
                top: 50,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                    )
                  ],
                )),
            Positioned(
                top: 170,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: Column(children: [
                    Row(
                      children: const [
                        Text(
                          'Tipo',
                          style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ]),
                ))
          ],
        ),
      ),
    );
  }
}
