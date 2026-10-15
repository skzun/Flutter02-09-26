import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controlaNome = TextEditingController();
  TextEditingController controlaDono = TextEditingController();
  TextEditingController controlaIdade = TextEditingController();

  List<Map<String, dynamic>> caes = [];

  Future<void> carregarPets() async {
    List<Map<String, dynamic>> dados = await DatabaseHelper.listarCaos();
    setState(() {
      caes = dados;
    });
  }

  Future<void> salvarNoBanco() async {
    Map<String, dynamic> novoCao = {
      'nome': controlaNome.text,
      'dono': controlaDono.text,
      'idade': int.tryParse(controlaIdade.text) ?? 0,
    };

    await DatabaseHelper.inserirCao(novoCao);

    print('${controlaNome.text} salvo com sucesso!');

    setState(() {
      controlaNome.text = '';
      controlaDono.text = '';
      controlaIdade.text = '';
    });
    await carregarPets();
  }

  @override
  void initState() {
    super.initState();
    carregarPets();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meus pets'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controlaNome,
                  decoration: InputDecoration(
                    labelText: 'Nome do pet',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controlaDono,
                  decoration: InputDecoration(
                    labelText: 'Nome do dono',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controlaIdade,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Idade do pet',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    salvarNoBanco();
                  },
                  child: Text('Salvar')),
              SizedBox(
                height: 16,
              ),
              const Text('Pets cadastrados:'),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: caes.length,
                  itemBuilder: (context, index) {
                    final cao = caes[index];
                    return ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text('${cao['nome']} - dono: ${cao['dono']}'),
                      subtitle: Text('Idade: ${cao['idade']} anos'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
