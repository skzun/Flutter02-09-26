import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Postagem> buscaPostagem(int id) async {
  final resposta = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    headers: {'Accept': 'application/json'},
  );

  if (resposta.statusCode == 200) {
    return Postagem.fromJson(
      jsonDecode(resposta.body) as Map<String, dynamic>,
    );
  } else {
    throw Exception('Falha ao carregar post.');
  }
}

class Postagem {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Postagem({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Postagem.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
        'body': String body
      } =>
        Postagem(
          userId: userId,
          id: id,
          title: title,
          body: body,
        ),
      _ => throw const FormatException('Falha no carregamento...'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Postagem> postFuturo;
  late Future<Postagem> postAnterior;

  int idPostagem = 1;

  @override
  void initState() {
    super.initState();
    postFuturo = buscaPostagem(idPostagem);
    postAnterior = buscaPostagem(idPostagem);
  }

  void anteriorPostagem() {
    setState(() {
      if (idPostagem <= 1)
        return (null);
      else
        idPostagem--;
      postFuturo = buscaPostagem(idPostagem);
    });
  }

  void proximaPostagem() {
    setState(() {
      idPostagem++;
      postFuturo = buscaPostagem(idPostagem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscando dados',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Buscando dados'),
        ),
        body: Center(
          child: FutureBuilder<Postagem>(
            future: postFuturo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final postagem = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Post ${postagem.id}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        postagem.title,
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        postagem.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: proximaPostagem,
                        child: const Text('Próximo post'),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: anteriorPostagem,
                        child: const Text('Post Anterior'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
