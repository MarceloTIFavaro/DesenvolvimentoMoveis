import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// --- MODELOS DE DADOS ---
class CartaMemoria {
  final int id;
  final String imagem;
  bool estaVirada;
  bool foiCombinada;

  CartaMemoria({
    required this.id,
    required this.imagem,
    this.estaVirada = false,
    this.foiCombinada = false,
  });
}

class Tema {
  final String nome;
  final IconData icone;
  final List<String> imagens;

  Tema({required this.nome, required this.icone, required this.imagens});
}

// Classe auxiliar para o efeito de rotação da carta
class RotationYTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> turns;

  const RotationYTransition({
    Key? key,
    required this.turns,
    required this.child,
  }) : super(key: key, listenable: turns);

  @override
  Widget build(BuildContext context) {
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(pi * turns.value);
    return Transform(
      transform: transform,
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Memória',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      // --- ETAPA 1: CONFIGURAR AS ROTAS ---
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaMenu(),
        '/jogo': (context) => const TelaJogo(),
      },
    );
  }
}

// --- TELA DE MENU ---
class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  // Dados dos temas e dificuldades
  final List<Tema> _temas = [
    Tema(
      nome: 'Animais',
      icone: Icons.pets,
      imagens: List.generate(8, (i) => 'assets/images/animais/${i + 1}.jpg'),
    ),
    Tema(
      nome: 'Frutas',
      icone: Icons.apple,
      imagens: List.generate(8, (i) => 'assets/images/frutas/${i + 1}.jpg'),
    ),
  ];
  final Map<String, int> _dificuldades = {
    'Fácil': 8,
    'Médio': 12,
    'Difícil': 16,
  };

  String? _temaSelecionado;
  int? _dificuldadeSelecionada;

  void _iniciarJogo() {
    if (_temaSelecionado != null && _dificuldadeSelecionada != null) {
      // --- ETAPA 2: NAVEGAR PARA O JOGO E PASSAR DADOS ---
      Navigator.pushNamed(
        context,
        '/jogo',
        arguments: {
          'tema': _temas.firstWhere((t) => t.nome == _temaSelecionado),
          'totalCartas': _dificuldadeSelecionada,
        },
      );
    } else {
      // Opcional: Mostrar um aviso se nada for selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um tema e uma dificuldade.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogo da Memória')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '1. Escolha a Dificuldade',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _dificuldades.keys.map((dificuldade) {
                return ChoiceChip(
                  label: Text(dificuldade),
                  selected:
                      _dificuldadeSelecionada == _dificuldades[dificuldade],
                  onSelected: (selected) {
                    setState(() {
                      _dificuldadeSelecionada = _dificuldades[dificuldade];
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              '2. Escolha o Tema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // --- ETAPA 3: CONSTRUIR A GRADE DE TEMAS ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: _temas.map((tema) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _temaSelecionado = tema.nome;
                      });
                    },
                    child: Card(
                      color: _temaSelecionado == tema.nome
                          ? Colors.purple.shade100
                          : Colors.white,
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(tema.icone, size: 40, color: Colors.purple),
                          const SizedBox(height: 10),
                          Text(tema.nome, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _iniciarJogo,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('INICIAR JOGO', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- TELA DO JOGO ---
class TelaJogo extends StatefulWidget {
  const TelaJogo({super.key});

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  List<CartaMemoria> _cartas = [];
  List<int> _indicesVirados = [];
  bool _travado = false;
  bool _jogoConcluido = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _iniciarJogo();
  }

  void _iniciarJogo() {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Tema tema = args['tema'];
    final int totalCartas = args['totalCartas'];

    List<CartaMemoria> pares = [];
    for (int i = 0; i < totalCartas / 2; i++) {
      pares.add(CartaMemoria(id: i, imagem: tema.imagens[i]));
      pares.add(CartaMemoria(id: i, imagem: tema.imagens[i]));
    }
    pares.shuffle();
    setState(() {
      _cartas = pares;
      _jogoConcluido = false;
    });
  }

  void _virarCarta(int index) {
    if (_travado || _cartas[index].foiCombinada || _cartas[index].estaVirada)
      return;

    setState(() {
      _cartas[index].estaVirada = true;
      _indicesVirados.add(index);
    });

    if (_indicesVirados.length == 2) {
      setState(() {
        _travado = true;
      });
      final int index1 = _indicesVirados[0];
      final int index2 = _indicesVirados[1];

      Timer(const Duration(seconds: 1), () {
        setState(() {
          if (_cartas[index1].id == _cartas[index2].id) {
            _cartas[index1].foiCombinada = true;
            _cartas[index2].foiCombinada = true;
          } else {
            _cartas[index1].estaVirada = false;
            _cartas[index2].estaVirada = false;
          }

          _indicesVirados = [];
          _travado = false;

          // Verifica se o jogo acabou
          if (_cartas.every((carta) => carta.foiCombinada)) {
            _jogoConcluido = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Encontre os Pares')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // --- ETAPA 4: CONSTRUIR O TABULEIRO DO JOGO ---
            GridView.builder(
              itemCount: _cartas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final carta = _cartas[index];
                return GestureDetector(
                  onTap: () {
                    _virarCarta(index);
                  },
                  child: Card(
                    elevation: 4,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return RotationYTransition(
                              turns: animation,
                              child: child,
                            );
                          },
                      child: (carta.estaVirada || carta.foiCombinada)
                          ? Image.asset(
                              carta.imagem,
                              key: ValueKey('frente$index'),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              key: ValueKey('verso$index'),
                              color: Colors.purple,
                              child: const Icon(
                                Icons.question_mark,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            // Overlay de Fim de Jogo
            if (_jogoConcluido)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Parabéns!',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Você encontrou todos os pares!',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Jogar Novamente'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}