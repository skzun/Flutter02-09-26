import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Tabuada(),
        ),
      ),
    );
  }
}

class Tabuada extends StatefulWidget {
  const Tabuada({super.key});

  @override
  State<Tabuada> createState() => _TabuadaState();
}

class _TabuadaState extends State<Tabuada> {
  final Random sorteio = Random();

  int fator = 2;
  int multiplicador = 1;
  String resposta = '';

  @override
  void initState() {
    super.initState();
    fator = sorteio.nextInt(10) + 1;
    carregar();
  }

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fator = prefs.getInt('fator') ?? fator;
      multiplicador = prefs.getInt('multiplicador') ?? multiplicador;
    });
  }

  Future<void> salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fator', fator);
    await prefs.setInt('multiplicador', multiplicador);
  }

  void mostrar(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void apertar(int digito) {
    setState(() {
      resposta = '$resposta$digito';
    });
  }

  void apagar() {
    setState(() {
      resposta = '';
    });
  }

  void verificar() {
    if (int.tryParse(resposta) == fator * multiplicador) {
      mostrar('Acertou!');
      setState(() {
        if (multiplicador == 10) {
          fator = sorteio.nextInt(10) + 1;
          multiplicador = 1;
        } else {
          multiplicador++;
        }
      });
      salvar();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Errou, clique aqui para continuar.'),
          action: SnackBarAction(label: 'Continuar', onPressed: continuar),
        ),
      );
    }
    setState(() {
      resposta = '';
    });
  }

  void continuar() {
    mostrar('Continuando no fator $fator!');
  }

  void escolherFator(int? novoFator) {
    if (novoFator != null) {
      setState(() {
        fator = novoFator;
        multiplicador = 1;
        resposta = '';
      });
      salvar();
    }
  }

  Widget numero(int digito) {
    return OutlinedButton(
      onPressed: () {
        apertar(digito);
      },
      child: Text('$digito'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Fator: '),
            DropdownButton<int>(
              value: fator,
              items: const [
                DropdownMenuItem(value: 1, child: Text('1')),
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 4, child: Text('4')),
                DropdownMenuItem(value: 5, child: Text('5')),
                DropdownMenuItem(value: 6, child: Text('6')),
                DropdownMenuItem(value: 7, child: Text('7')),
                DropdownMenuItem(value: 8, child: Text('8')),
                DropdownMenuItem(value: 9, child: Text('9')),
                DropdownMenuItem(value: 10, child: Text('10')),
              ],
              onChanged: escolherFator,
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(value: multiplicador / 10),
        const SizedBox(height: 24),
        Text(
          '$fator × $multiplicador = ?',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          resposta.isEmpty ? '—' : resposta,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            numero(1),
            numero(2),
            numero(3),
            numero(4),
            numero(5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            numero(6),
            numero(7),
            numero(8),
            numero(9),
            numero(0),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: apagar,
              child: const Text('Apagar'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: verificar,
              child: const Text('Verificar'),
            ),
          ],
        ),
      ],
    );
  }
}
