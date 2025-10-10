import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//--- MODELO DE DADOS ---
class EntradaDiario {
  final String titulo;
  final String descricao;
  final DateTime data;

  EntradaDiario({
    required this.titulo,
    required this.descricao,
    required this.data,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário de Viagens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const TelaDiario(),
    );
  }
}

//--- TELA PRINCIPAL (DIÁRIO) ---
class TelaDiario extends StatefulWidget {
  const TelaDiario({super.key});

  @override
  State<TelaDiario> createState() => _TelaDiarioState();
}

class _TelaDiarioState extends State<TelaDiario> {
  final List<EntradaDiario> _entradas = [];

  void _navegarParaNovaEntrada() async {
    final novaEntrada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaNovaEntrada()),
    );

    if (novaEntrada != null) {
      setState(() {
        _entradas.add(novaEntrada as EntradaDiario);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Diário de Viagens')),
      body: ListView.builder(
        itemCount: _entradas.length,
        itemBuilder: (context, index) {
          final entrada = _entradas[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entrada.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd/MM/yyyy').format(entrada.data),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Divider(height: 20),
                  Text(entrada.descricao, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaNovaEntrada,
        child: const Icon(Icons.add),
      ),
    );
  }
}

//--- TELA DE NOVA ENTRADA (FORMULÁRIO) ---
class TelaNovaEntrada extends StatefulWidget {
  const TelaNovaEntrada({super.key});

  @override
  State<TelaNovaEntrada> createState() => _TelaNovaEntradaState();
}

class _TelaNovaEntradaState extends State<TelaNovaEntrada> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  void _salvarEntrada() {
    if (_tituloController.text.isNotEmpty &&
        _descricaoController.text.isNotEmpty) {
      final novaEntrada = EntradaDiario(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        data: DateTime.now(),
      );
      Navigator.pop(context, novaEntrada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Entrada no Diário')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarEntrada,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}