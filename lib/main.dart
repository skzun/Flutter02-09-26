import 'package:flutter/material.dart';
import 'package:flutter_application_2/janela1.dart';
import 'package:flutter_application_2/janela2.dart';
import 'package:flutter_application_2/janela3.dart';
import 'package:flutter_application_2/janela4.dart';

void main() {
  runApp(
    Controle(),
  );
}

class Controle extends StatefulWidget {
  const Controle({super.key});

  @override
  State<Controle> createState() => _ControleState();
}

class _ControleState extends State<Controle> {
  // Widget? atual;
  int atual = 0;

  // criação de muda
  void muda() {
    setState(() {
      atual = (atual + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? usar;

    if (atual == 0) {
      usar = Janela1(muda);
    } else if (atual == 1) {
      usar = Janela2(muda);
    } else if (atual == 2) {
      usar = Janela3(muda);
    } else {
      usar = Janela4(muda);
    }

    return MaterialApp(
      home: usar,
    );
  }
}
