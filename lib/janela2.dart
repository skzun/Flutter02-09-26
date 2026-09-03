import 'package:flutter/material.dart';
import 'package:flutter_application_2/pergunta.dart';
import 'package:flutter_application_2/questoes.dart';

class Janela2 extends StatelessWidget {
  const Janela2(
    this.muda, {
    super.key,
  });

  final Function() muda;

  @override
  Widget build(BuildContext context) {
    Pergunta teste1 = questoes[0];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/imagens/palhaco_ouve.png',
                //color: const Color.fromARGB(40, 244, 67, 54),
              ),
            ),
          ),
          Text(teste1.texto),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: muda,
            child: Text(teste1.respostas[0]),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(teste1.respostas[1]),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(teste1.respostas[2]),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(teste1.respostas[3]),
          ),
        ],
      ),
    );
  }
}
