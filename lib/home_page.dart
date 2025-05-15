import 'package:flutter/material.dart';
import 'lucro.dart';
import 'videos.dart';

// Classe Produto
class Produto {
  final String nome;
  final double preco;
  double estoque;

  Produto({required this.nome, required this.preco, required this.estoque});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Catálogo de produtos
  List<Produto> produtos = [
    Produto(nome: 'Arroz', preco: 5.99, estoque: 150.0),
    Produto(nome: 'Feijão', preco: 4.99, estoque: 200.0),
    Produto(nome: 'Óleo', preco: 7.99, estoque: 120.0),
    Produto(nome: 'Açúcar', preco: 3.49, estoque: 180.0),
    Produto(nome: 'Café', preco: 9.99, estoque: 160.0),
  ];

  bool showSuggestions = false;
  String? selectedState;

  void updateStock(double value) {
    setState(() {
      // Atualiza o estoque para o valor fornecido
    });
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

  void comprarProduto(int index) {
    setState(() {
      if (produtos[index].estoque > 0) {
        produtos[index].estoque--;
      }
    });
  }

  double calcularTotalVendas() {
    return produtos.fold(
      0.0,
      (sum, produto) => sum + (produto.preco * (150 - produto.estoque)),
    );
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
            // Dropdown para selecionar o estado
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
              // Exibição do catálogo de produtos, após selecionar o estado
              Text(
                'Catálogo de Produtos:',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Exibição dos produtos
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
                      trailing: Text(
                        'Estoque: ${produto.estoque.toStringAsFixed(0)}',
                      ),
                      onTap: () {
                        // Quando o produto é selecionado, diminui o estoque
                        comprarProduto(index);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              // Botão para visualizar as sugestões de estoque
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

              // Exibição das dicas de estoque
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

              // Botão: Cálculo de lucro estimado
              ElevatedButton.icon(
                onPressed: () {
                  double totalVendas = calcularTotalVendas();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LucroPage(totalVendas: totalVendas),
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

              // Botão: Ver vídeos de gestão
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
