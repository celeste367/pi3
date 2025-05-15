import 'package:flutter/material.dart';
import 'lucro.dart';
import 'videos.dart';

class Produto {
  final String nome;
  final double preco;
  double estoque;
  double vendas;

  Produto({
    required this.nome,
    required this.preco,
    required this.estoque,
    this.vendas = 0,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Produto> produtos = [
    Produto(nome: 'Arroz', preco: 5.00, estoque: 1500),
    Produto(nome: 'Feijão', preco: 4.00, estoque: 2000),
    Produto(nome: 'Óleo', preco: 7.00, estoque: 1200),
    Produto(nome: 'Açúcar', preco: 3.40, estoque: 1800),
    Produto(nome: 'Café', preco: 9.00, estoque: 1600),
  ];

  bool showSuggestions = false;
  String? selectedState;

  void venderProduto(int index) {
    setState(() {
      if (produtos[index].estoque > 0) {
        produtos[index].estoque--;
        produtos[index].vendas++;
      }
    });
  }

  double calcularTotalVendas() {
    return produtos.fold(
      0.0,
      (sum, produto) => sum + (produto.preco * produto.vendas),
    );
  }

  double calcularGastosOperacionais(double totalVendas) {
    return totalVendas * 0.10;
  }

  List<String> getStockRecommendations() {
    if (produtos.any((produto) => produto.estoque >= 300)) {
      return [
        "Estoque elevado! Considere criar promoções.",
        "Revise produtos com baixa rotatividade.",
      ];
    } else if (produtos.any((produto) => produto.estoque >= 100)) {
      return [
        "Estoque em nível estável.",
        "Monitore a saída e planeje reabastecimento.",
      ];
    } else {
      return [
        "Estoque crítico! Reposição urgente recomendada.",
        "Priorize compra dos itens mais vendidos.",
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Supermercado'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (selectedState == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecione o Estado:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    hint: const Text('Selecione um estado'),
                    value: selectedState,
                    isExpanded: true,
                    onChanged: (String? newState) {
                      setState(() {
                        selectedState = newState;
                      });
                    },
                    items:
                        [
                          'AC',
                          'AL',
                          'AP',
                          'AM',
                          'BA',
                          'CE',
                          'DF',
                          'ES',
                          'GO',
                          'MA',
                          'MT',
                          'MS',
                          'MG',
                          'PA',
                          'PB',
                          'PR',
                          'PE',
                          'PI',
                          'RJ',
                          'RN',
                          'RS',
                          'RO',
                          'RR',
                          'SC',
                          'SP',
                          'SE',
                          'TO',
                        ].map((String estado) {
                          return DropdownMenuItem<String>(
                            value: estado,
                            child: Text(estado),
                          );
                        }).toList(),
                  ),
                ],
              )
            else ...[
              Text(
                'Catálogo de Produtos:',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  Produto produto = produtos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(produto.nome),
                      subtitle: Text(
                        'Preço: R\$ ${produto.preco.toStringAsFixed(2)}',
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Estoque: ${produto.estoque.toStringAsFixed(0)}',
                          ),
                          Text('Vendas: ${produto.vendas.toStringAsFixed(0)}'),
                        ],
                      ),
                      onTap: () {
                        venderProduto(index);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSuggestions = !showSuggestions;
                  });
                },
                child: Text(
                  showSuggestions ? 'Ocultar Dicas' : 'Ver Dicas de Estoque',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              if (showSuggestions)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      getStockRecommendations()
                          .map(
                            (tip) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                "• $tip",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  double totalVendas = calcularTotalVendas();
                  double gastosOperacionais = calcularGastosOperacionais(
                    totalVendas,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => LucroPage(
                            totalVendas: totalVendas,
                            gastosOperacionais: gastosOperacionais,
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.attach_money),
                label: const Text('Calcular Lucro Estimado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BusinessVideosPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Ver Vídeos sobre Gestão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
