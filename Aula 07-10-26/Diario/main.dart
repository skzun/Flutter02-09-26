import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Organiza(),
  ));
}

class Organiza extends StatefulWidget {
  const Organiza({super.key});

  @override
  State<Organiza> createState() => _OrganizaState();
}

class _OrganizaState extends State<Organiza> {
  final texto = TextEditingController();

  Future<File> arquivo() async {
    final pasta = Directory('documento');

    if (!await pasta.exists()) {
      await pasta.create();
    }

    return File('${pasta.path}/organiza.md');
  }

  void salvar() async {
    final file = await arquivo();

    await file.writeAsString(texto.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Salvo!'),
      ),
    );
  }

  void carregar() async {
    final file = await arquivo();

    if (await file.exists()) {
      texto.text = await file.readAsString();
    }
  }

  void apagar() async {
    final file = await arquivo();

    if (await file.exists()) {
      await file.delete();
    }

    texto.clear();
  }

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('organiza.md'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: texto,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite o texto',
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: salvar,
                    child: const Text('Salvar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: apagar,
                    child: const Text('Apagar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
