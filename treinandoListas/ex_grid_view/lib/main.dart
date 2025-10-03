import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TelaGaleria(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaGaleria extends StatelessWidget {
  const TelaGaleria({super.key});

  // Fonte de dados (IDs de imagens)
  final List<String> _listaDeIds = const [
    '10', '100', '1000', '1002', '1003', '1004', '1005', '1006', '1008',
    '1009', '101', '1010', '1011', '1012', '1013', '1014', '1015', '1016',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de Fotos'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _listaDeIds.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,          // 3 colunas
          crossAxisSpacing: 8.0,      // Espaçamento horizontal
          mainAxisSpacing: 8.0,       // Espaçamento vertical
        ),
        itemBuilder: (context, index) {
          final imageUrl =
              'https://picsum.photos/id/${_listaDeIds[index]}/300/300';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TelaDetalheImagem(urlDaImagem: imageUrl),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class TelaDetalheImagem extends StatelessWidget {
  final String urlDaImagem;

  const TelaDetalheImagem({super.key, required this.urlDaImagem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer( // permite zoom e movimento
          child: Image.network(urlDaImagem),
        ),
      ),
    );
  }
}
