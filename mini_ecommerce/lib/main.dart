import 'package:flutter/material.dart';

class Produto {
  final String nome;
  final String descricao;
  final List<String> caracteristicas;
  final double preco;
  bool isSelecionado;

  Produto({
    required this.nome,
    required this.descricao,
    required this.caracteristicas,
    required this.preco,
    this.isSelecionado = false,
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
      title: 'Tech Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaLogin(),
        '/lista': (context) => const TelaListaProdutos(),
        '/detalhes': (context) => const TelaDetalhesProduto(),
        '/carrinho': (context) => const TelaCarrinho(),
        '/finalizar': (context) => const TelaFinalizarCompra(),
      },
    );
  }
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _loginController = TextEditingController();

  void _fazerLogin() {
    if (_loginController.text.isNotEmpty) {
      Navigator.pushNamed(context, '/lista', arguments: _loginController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bem-vindo à Tech Shop',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _loginController,
                    decoration: const InputDecoration(
                      labelText: 'Digite seu nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fazerLogin,
                    child: const Text('LOGIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TelaListaProdutos extends StatefulWidget {
  const TelaListaProdutos({super.key});

  @override
  State<TelaListaProdutos> createState() => _TelaListaProdutosState();
}

class _TelaListaProdutosState extends State<TelaListaProdutos> {
  final List<Produto> _produtos = [
    Produto(
      nome: 'Notebook Ultra Power',
      descricao: 'Ideal para tarefas pesadas.',
      caracteristicas: ['16GB RAM', 'SSD 512GB', 'Tela 4K'],
      preco: 7500.00,
    ),
    Produto(
      nome: 'Smartphone NextGen',
      descricao: 'Fotografia profissional no seu bolso.',
      caracteristicas: ['Câmera 108MP', 'Tela AMOLED', '5G'],
      preco: 4500.00,
    ),
    Produto(
      nome: 'Fone WaveSound',
      descricao: 'Imersão total com cancelamento de ruído.',
      caracteristicas: ['Bluetooth 5.2', '20h de bateria', 'Case de recarga'],
      preco: 800.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final login = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Produtos - Olá, $login')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(produto.nome),
              subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              leading: Checkbox(
                value: produto.isSelecionado,
                onChanged: (bool? valor) {
                  setState(() {
                    produto.isSelecionado = valor ?? false;
                  });
                },
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/detalhes', arguments: produto);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Ir para o Carrinho'),
        onPressed: () {
          final produtosSelecionados = _produtos
              .where((p) => p.isSelecionado)
              .toList();
          Navigator.pushNamed(
            context,
            '/carrinho',
            arguments: {'login': login, 'produtos': produtosSelecionados},
          );
        },
      ),
    );
  }
}

class TelaDetalhesProduto extends StatelessWidget {
  const TelaDetalhesProduto({super.key});

  @override
  Widget build(BuildContext context) {
    final Produto produto =
        ModalRoute.of(context)!.settings.arguments as Produto;

    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                produto.descricao,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...produto.caracteristicas.map((c) => Text('• $c')).toList(),
              const SizedBox(height: 20),
              Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, color: Colors.indigo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  final _enderecoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dados =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String login = dados['login'];
    final List<Produto> produtos = dados['produtos'];

    final double total = produtos.fold(0, (soma, item) => soma + item.preco);

    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho de Compras')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(produtos[index].nome),
                  trailing: Text(
                    'R\$ ${produtos[index].preco.toStringAsFixed(2)}',
                  ),
                ),
              ),
            ),
            const Divider(),
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço de Entrega',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('FINALIZAR COMPRA'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/finalizar',
                  arguments: {
                    'login': login,
                    'produtos': produtos,
                    'total': total,
                    'endereco': _enderecoController.text,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TelaFinalizarCompra extends StatelessWidget {
  const TelaFinalizarCompra({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dadosFinais =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Compra Finalizada')),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Obrigado, ${dadosFinais['login']}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 30),
              const Text(
                'Resumo do Pedido:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...(dadosFinais['produtos'] as List<Produto>)
                  .map(
                    (p) => ListTile(
                      title: Text(p.nome),
                      trailing: Text('R\$ ${p.preco.toStringAsFixed(2)}'),
                    ),
                  )
                  .toList(),
              const Divider(),
              Text(
                'Total: R\$ ${(dadosFinais['total'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 30),
              const Text(
                'Endereço de Entrega:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(dadosFinais['endereco']),
            ],
          ),
        ),
      ),
    );
  }
}