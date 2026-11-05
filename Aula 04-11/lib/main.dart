import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const String urlBase = "http://10.106.76.12:8080";

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula 13',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aula 13 - Textos')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Enviar um texto'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaSalvar()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Ver textos salvos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaTextos()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Tirar foto e enviar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaFoto()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.collections),
              label: const Text('Ver fotos do site'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaFotos()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TelaSalvar extends StatefulWidget {
  const TelaSalvar({super.key});

  @override
  State<TelaSalvar> createState() => _TelaSalvarState();
}

class _TelaSalvarState extends State<TelaSalvar> {
  final TextEditingController _texto = TextEditingController();
  bool _enviando = false;

  Future<void> _salvar() async {
    if (_texto.text.trim().isEmpty) {
      _mostrar('Digite um texto antes de salvar.');
      return;
    }

    setState(() => _enviando = true);

    try {
      final resposta = await http.post(
        Uri.parse('$urlBase/salvar.php'),
        body: {'texto': _texto.text},
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;
      _mostrar(resposta.body);
      _texto.clear();
    } catch (e) {
      if (!mounted) return;
      _mostrar('Erro de conexão: $e');
    }

    if (mounted) setState(() => _enviando = false);
  }

  void _mostrar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar texto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _texto,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Texto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enviando ? null : _salvar,
              child: Text(_enviando ? 'Enviando...' : 'Salvar no banco'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaFoto extends StatefulWidget {
  const TelaFoto({super.key});

  @override
  State<TelaFoto> createState() => _TelaFotoState();
}

class _TelaFotoState extends State<TelaFoto> {
  final ImagePicker _seleciona = ImagePicker();
  XFile? _foto;
  bool _enviando = false;

  Future<void> _tirar() async {
    try {
      final XFile? foto = await _seleciona.pickImage(source: ImageSource.camera);
      if (foto != null) {
        setState(() => _foto = foto);
      }
    } catch (e) {
      _mostrar('Erro na câmera: $e');
    }
  }

  Future<void> _daGaleria() async {
    try {
      final XFile? foto = await _seleciona.pickImage(source: ImageSource.gallery);
      if (foto != null) {
        setState(() => _foto = foto);
      }
    } catch (e) {
      _mostrar('Erro na galeria: $e');
    }
  }

  Future<void> _enviar() async {
    if (_foto == null) {
      _mostrar('Tire uma foto primeiro.');
      return;
    }

    setState(() => _enviando = true);

    try {
      final pedido = http.MultipartRequest('POST', Uri.parse('$urlBase/salvafoto.php'));
      pedido.files.add(await http.MultipartFile.fromPath('foto', _foto!.path));

      final resposta = await http.Response.fromStream(
        await pedido.send().timeout(const Duration(seconds: 60)),
      );

      if (!mounted) return;
      _mostrar(resposta.body);
      setState(() => _foto = null);
    } catch (e) {
      if (!mounted) return;
      _mostrar('Erro de conexão: $e');
    }

    if (mounted) setState(() => _enviando = false);
  }

  void _mostrar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _foto == null
                    ? const Text('Nenhuma foto.')
                    : Image.file(File(_foto!.path)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Tirar foto'),
                  onPressed: _enviando ? null : _tirar,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Da galeria'),
                  onPressed: _enviando ? null : _daGaleria,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: Text(_enviando ? 'Enviando...' : 'Enviar foto ao site'),
              onPressed: _enviando ? null : _enviar,
            ),
          ],
        ),
      ),
    );
  }
}

class TelaFotos extends StatefulWidget {
  const TelaFotos({super.key});

  @override
  State<TelaFotos> createState() => _TelaFotosState();
}

class _TelaFotosState extends State<TelaFotos> {
  List _fotos = [];
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);

    try {
      final resposta = await http
          .get(Uri.parse('$urlBase/fotos.php'))
          .timeout(const Duration(seconds: 30));

      if (!mounted) return;
      setState(() => _fotos = jsonDecode(resposta.body));
    } catch (e) {
      if (!mounted) return;
      setState(() => _fotos = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    }

    if (mounted) setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fotos salvas no site')),
      floatingActionButton: FloatingActionButton(
        onPressed: _carregando ? null : _carregar,
        child: const Icon(Icons.refresh),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (_fotos.isEmpty)
                  const Text('Nenhuma foto salva no site.'),
                for (final foto in _fotos)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.memory(
                          base64Decode(foto['dados']),
                          errorBuilder: (context, erro, detalhe) =>
                              Text('Erro ao mostrar: $erro'),
                        ),
                        Text(
                          foto['nome'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class TelaTextos extends StatefulWidget {
  const TelaTextos({super.key});

  @override
  State<TelaTextos> createState() => _TelaTextosState();
}

class _TelaTextosState extends State<TelaTextos> {
  int _id = 0;
  String _texto = '';
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregar(0);
  }

  Future<void> _carregar(int id) async {
    setState(() => _carregando = true);

    try {
      final resposta = await http
          .get(Uri.parse('$urlBase/texto.php?id=$id'))
          .timeout(const Duration(seconds: 15));
      final dados = jsonDecode(resposta.body);

      setState(() {
        _id = dados['id'];
        _texto = dados['texto'];
      });
    } catch (e) {
      setState(() {
        _id = 0;
        _texto = 'Erro de conexão: $e';
      });
    }

    if (mounted) setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texto salvo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: _carregando
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'id: $_id',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _texto,
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Próximo texto'),
                      onPressed: _id == 0 ? null : () => _carregar(_id),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
