import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 'initialRoute' define qual rota será carregada primeiro.
      // A convenção é usar '/' para a tela inicial.
      initialRoute: '/',
      // 'routes' é o nosso mapa de rotas nomeadas.
      // Ele associa um nome de rota (String) a uma função que constrói a tela.
      routes: {
        '/': (context) => const TelaInicial(),
        '/perfil': (context) => const TelaPerfil(),
        '/config': (context) => const TelaConfiguracoes(),
      },
    );
  }
}

// ----- TELA INICIAL (A) -----
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navegar para a rota '/perfil'
                Navigator.pushNamed(context, '/perfil');
              },
              child: const Text('Ir para Perfil'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a rota '/config'
                Navigator.pushNamed(context, '/config');
              },
              child: const Text('Ir para Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}

// ----- TELA DE PERFIL (B) -----
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Voltar para a tela anterior
            Navigator.pop(context);
          },
          child: const Text('Voltar'),
        ),
      ),
    );
  }
}

// ----- TELA DE CONFIGURAÇÕES (C) -----
class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Voltar para a tela anterior
            Navigator.pop(context);
          },
          child: const Text('Voltar'),
        ),
      ),
    );
  }
}
