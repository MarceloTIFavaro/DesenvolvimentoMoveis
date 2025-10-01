// Importando os pacotes necessários do Flutter e do Dart.
import 'package:flutter/material.dart';
import 'dart:math';

// A função main() é o ponto de entrada de toda aplicação Flutter.
void main() {
  runApp(const MyApp());
}

// MyApp é o widget raiz da aplicação.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define a tela inicial da aplicação.
      home: const AdivinheNumero(),
      // Remove o banner de "Debug" no canto da tela.
      debugShowCheckedModeBanner: false,
    );
  }
}

// AdivinheNumero é um StatefulWidget, pois seu estado (os dados do jogo) muda.
class AdivinheNumero extends StatefulWidget {
  const AdivinheNumero({super.key});

  @override
  State<AdivinheNumero> createState() => _AdivinheNumeroState();
}

// _AdivinheNumeroState é a classe que guarda o estado e a lógica do nosso jogo.
class _AdivinheNumeroState extends State<AdivinheNumero> {
  // --- INÍCIO DA LÓGICA PRINCIPAL (Fornecida no exercício) ---

  // Controlador para o campo de texto, para ler o que o usuário digita.
  final _controller = TextEditingController();
  // Variáveis de Estado
  int _numeroSecreto = 0;
  String _mensagemFeedback = 'Eu pensei em um número entre 1 e 100. Tente adivinhar!';
  bool _jogoFinalizado = false;

  // O método initState() é chamado uma única vez quando o widget é criado.
  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  // Reseta o jogo para seu estado inicial e gera um novo número secreto.
  void _iniciarJogo() {
    // setState() notifica o Flutter que o estado mudou, para que a tela seja redesenhada.
    setState(() {
      _numeroSecreto = Random().nextInt(100) + 1; // Gera um número de 1 a 100
      _mensagemFeedback = 'Eu pensei em um número entre 1 e 100. Tente adivinhar!';
      _jogoFinalizado = false;
      _controller.clear(); // Limpa o campo de texto.
    });
  }

  // Esta é a função de callback principal, chamada pelo botão "Verificar".
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
        _mensagemFeedback = 'Muito alto! Tente um número menor.';
      } else if (palpite < _numeroSecreto) {
        _mensagemFeedback = 'Muito baixo! Tente um número maior.';
      } else {
        _mensagemFeedback = 'Parabéns! Você acertou o número $_numeroSecreto!';
        _jogoFinalizado = true;
      }
      _controller.clear();
    });
  }

  // É uma boa prática limpar o controller quando o widget é descartado.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // --- FIM DA LÓGICA PRINCIPAL ---

  // O método build() é responsável por construir a interface visual do widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Adivinhe o Número'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      // Usamos SingleChildScrollView para evitar que o teclado quebre o layout.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Alinha os widgets no centro do eixo vertical e horizontal.
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              // Exibe a mensagem de feedback para o usuário.
              Text(
                _mensagemFeedback,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 30),
              // Campo de texto para o usuário inserir o palpite.
              TextField(
                controller: _controller,
                // Define o teclado para aceitar apenas números.
                keyboardType: TextInputType.number,
                // Habilita ou desabilita o campo com base no estado do jogo.
                enabled: !_jogoFinalizado,
                decoration: InputDecoration(
                  labelText: 'Seu palpite',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Condicional: mostra um botão diferente se o jogo acabou ou não.
              if (!_jogoFinalizado)
                // Botão para verificar o palpite.
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _verificarPalpite,
                  child: const Text('VERIFICAR'),
                )
              else
                // Botão para jogar novamente.
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _iniciarJogo,
                  child: const Text('JOGAR NOVAMENTE'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}