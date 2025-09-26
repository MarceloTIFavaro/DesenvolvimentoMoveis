import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adivinhe o Número',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JogoAdivinha(),
    );
  }
}

class JogoAdivinha extends StatefulWidget {
  const JogoAdivinha({super.key});

  @override
  _JogoAdivinhaState createState() => _JogoAdivinhaState();
}

class _JogoAdivinhaState extends State<JogoAdivinha> {
  final TextEditingController _controller = TextEditingController();
  int _numeroSecreto = 0;
  String _mensagemFeedback =
      'Eu pensei em um número entre 1 e 100. Tente adivinhar!';
  bool _jogoFinalizado = false;

  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  void _iniciarJogo() {
    setState(() {
      _numeroSecreto = Random().nextInt(100) + 1;
      _mensagemFeedback =
          'Eu pensei em um número entre 1 e 100. Tente adivinhar!';
      _jogoFinalizado = false;
      _controller.clear();
    });
  }

  void _verificarPalpite() {
    final int? palpite = int.tryParse(_controller.text);
    if (palpite == null) {
      setState(() {
        _mensagemFeedback = 'Por favor, insira um número válido.';
      });
      return;
    }

    setState(() {
      if (palpite > _numeroSecreto) {
        _mensagemFeedback = '📈 Muito alto! Tente um número menor.';
      } else if (palpite < _numeroSecreto) {
        _mensagemFeedback = '📉 Muito baixo! Tente um número maior.';
      } else {
        _mensagemFeedback =
            '🎉 Parabéns! Você acertou o número $_numeroSecreto!';
        _jogoFinalizado = true;
      }
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Adivinhe o Número'),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _mensagemFeedback,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                if (!_jogoFinalizado) ...[
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Digite um número',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Verificar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _verificarPalpite,
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.replay),
                      label: const Text('Jogar Novamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _iniciarJogo,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
