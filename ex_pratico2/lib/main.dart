import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaPerfil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Widget principal
class TelaPerfil extends StatefulWidget {
  const TelaPerfil({Key? key}) : super(key: key);

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  bool seguindo = false; // controla se está seguindo ou não
  int seguidores = 85;

  void toggleSeguir() {
    setState(() {
      seguindo = !seguindo;
      seguidores = seguindo ? 86 : 85;
    });
    print(seguindo ? 'Você seguiu esse usuário!!' : 'Você deixou de seguir esse usuário!!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Banner com imagem
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 240,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/800/400'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Avatar redondo
              Positioned(
                top: 170,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(
                      'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png',
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 80),

          // Nome e localização
          Text(
            'Marcelo Henrique Favaro',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'São Paulo, Brasil',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 24),

          // Row de estatísticas usando o widget componentizado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EstatisticaItem(numero: '0', rotulo: 'Fotos'),
              EstatisticaItem(numero: '$seguidores', rotulo: 'Seguidores'),
              EstatisticaItem(numero: '144', rotulo: 'Seguindo'),
            ],
          ),

          SizedBox(height: 24),

          // Botão SEGUIR interativo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: toggleSeguir,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: seguindo ? Colors.grey : Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    seguindo ? 'SEGUINDO' : 'SEGUIR',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24),

          // Galeria de fotos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://picsum.photos/200/200?random=1'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://picsum.photos/200/200?random=2'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://picsum.photos/200/200?random=3'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Widget componentizado para estatística
class EstatisticaItem extends StatelessWidget {
  final String numero;
  final String rotulo;

  const EstatisticaItem({Key? key, required this.numero, required this.rotulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(numero, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(rotulo, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
