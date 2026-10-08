import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Diário',
      home: const PaginaDiario(),
    );
  }
}

class PaginaDiario extends StatefulWidget {
  const PaginaDiario({super.key});

  @override
  State<PaginaDiario> createState() => _PaginaDiarioState();
}

class _PaginaDiarioState extends State<PaginaDiario> {
  TextEditingController textoController = TextEditingController();

  Future<String> pegarCaminhoArquivo() async {
    Directory pasta = await getApplicationDocumentsDirectory();
    return '${pasta.path}/diário.txt';
  }

  Future<void> salvarTexto() async {
    String texto = textoController.text;

    if (texto.isEmpty) {
      return;
    }

    String caminho = await pegarCaminhoArquivo();

    File arquivo = File(caminho);

    DateTime agora = DateTime.now();

    String data =
        '${agora.day.toString().padLeft(2, '0')}/'
        '${agora.month.toString().padLeft(2, '0')}/'
        '${agora.year}';

    String linha = '$data - $texto\n';

    await arquivo.writeAsString(
      linha,
      mode: FileMode.append,
    );

    textoController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Texto salvo no diário!'),
      ),
    );
  }

  Future<void> visualizarDiario() async {
    String caminho = await pegarCaminhoArquivo();

    File arquivo = File(caminho);

    String conteudo = '';

    if (await arquivo.exists()) {
      conteudo = await arquivo.readAsString();
    } else {
      conteudo = 'O diário ainda está vazio.';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Meu Diário'),
          content: SingleChildScrollView(
            child: Text(conteudo),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: textoController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite o que aconteceu hoje...',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: salvarTexto,
              child: const Text('Salvar'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: visualizarDiario,
              child: const Text('Visualizar Diário'),
            ),
          ],
        ),
      ),
    );
  }
}
```