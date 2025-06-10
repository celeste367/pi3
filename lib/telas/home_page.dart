// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:pi3/modelos/produto_model.dart';
import 'package:pi3/servicos/vendas_service.dart';
import 'lucro_page.dart';
import 'nota_fiscal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VendasService _vendasService = VendasService();

  // A lista de produtos agora usa o 'preco' como valor base (sem imposto)
  final List<Produto> _todosProdutos = [
    Produto(
      nome: 'Arroz Tipo 1 (5kg)',
      preco: 23.36,
      estoque: 150,
      aliquotaIcms: 0.07,
      imageUrl:
          'https://www.arenaatacado.com.br/on/demandware.static/-/Sites-storefront-catalog-sv/default/dw6abd898d/Produtos/78166-7896006711155-arroz%20tipo%201%20camil%20pacote%205kg-camil-1.jpg',
    ),
    Produto(
      nome: 'Feijão Carioca (1kg)',
      preco: 7.94,
      estoque: 200,
      aliquotaIcms: 0.07,
      imageUrl:
          'https://carrefourbrfood.vtexassets.com/arquivos/ids/194917/466506_1.jpg?v=637272434027000000',
    ),
    Produto(
      nome: 'Óleo de Soja (900ml)',
      preco: 6.54,
      estoque: 120,
      aliquotaIcms: 0.07,
      imageUrl:
          'https://carrefourbrfood.vtexassets.com/arquivos/ids/211616/141836_1.jpg?v=637272514200130000',
    ),
    Produto(
      nome: 'Refrigerante Cola (2L)',
      preco: 6.78,
      estoque: 130,
      aliquotaIcms: 0.18,
      imageUrl:
          'https://bretas.vtexassets.com/arquivos/ids/192050-800-auto?v=638375518430000000&width=800&height=auto&aspect=true',
    ),
    Produto(
      nome: 'Açúcar Refinado (1kg)',
      preco: 4.11,
      estoque: 180,
      aliquotaIcms: 0.07,
      imageUrl: 'https://m.media-amazon.com/images/I/811HPMq-KjL.jpg',
    ),
    Produto(
      nome: 'Sabão em Pó (1kg)',
      preco: 10.93,
      estoque: 100,
      aliquotaIcms: 0.18,
      imageUrl:
          'https://images.tcdn.com.br/img/img_prod/767437/sabao_em_po_omo_pacote_1kg_1017_1_20200408102937.jpg',
    ),
  ];

  List<Produto> _produtosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();
  final bool _showSuggestions = false;

  // MÉTODOS RESTAURADOS E CONSOLIDADOS
  @override
  void initState() {
    super.initState();
    _produtosFiltrados = List.from(_todosProdutos);
    _searchController.addListener(_filtrarProdutos);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarProdutos);
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarProdutos() {
    String query = _searchController.text.toLowerCase().trim();
    setState(() {
      _produtosFiltrados =
          _todosProdutos.where((produto) {
            return produto.nome.toLowerCase().contains(query);
          }).toList();
    });
  }

  void _venderProduto(Produto produto, bool devolverEstoque) {
    setState(() {
      if (devolverEstoque) {
        if (produto.vendas > 0) {
          produto.estoque++;
          produto.vendas--;
        }
      } else {
        if (produto.estoque > 0) {
          produto.estoque--;
          produto.vendas++;
        } else {
          _mostrarFeedback(
            'Estoque de "${produto.nome}" esgotado!',
            Colors.redAccent,
          );
        }
      }
    });
  }

  int _calcularTotalItensCarrinho() {
    return _todosProdutos.fold(0, (sum, p) => sum + p.vendas.toInt());
  }

  double _calcularTotalValorCarrinho() {
    return _todosProdutos.fold(0.0, (sum, p) {
      return sum + (p.precoFinalComImposto * p.vendas);
    });
  }

  void _limparCarrinho({bool fecharModal = true}) {
    setState(() {
      for (var produto in _todosProdutos) {
        if (produto.vendas > 0) {
          produto.estoque += produto.vendas;
          produto.vendas = 0;
        }
      }
    });
    if (fecharModal && mounted) Navigator.pop(context);
    _mostrarFeedback("Carrinho esvaziado!", Colors.blueGrey);
  }

  void _finalizarCompraEProcessarNota() async {
    final List<Produto> itensNoCarrinho =
        _todosProdutos.where((p) => p.vendas > 0).toList();
    if (itensNoCarrinho.isEmpty) {
      _mostrarFeedback('Seu carrinho está vazio.', Colors.orangeAccent);
      return;
    }

    final vendaRegistrada = await _vendasService.registrarVenda(
      itensNoCarrinho,
    );

    setState(() {
      for (var produto in itensNoCarrinho) {
        produto.vendas = 0;
      }
    });

    if (mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NotaFiscalPage(venda: vendaRegistrada),
        ),
      );
      _mostrarFeedback('Venda registrada com sucesso!', Colors.teal);
    }
  }

  void _navegarParaAnalise() {
    final itensNoCarrinho = _todosProdutos.where((p) => p.vendas > 0).toList();
    double totalVendas = _calcularTotalValorCarrinho();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => LucroPage(
              itensDaNotaFiscal:
                  itensNoCarrinho.map((p) => p.toMapVendidos()).toList(),
              totalDaNotaFiscal: totalVendas,
              dataDaVenda: DateTime.now(),
              gastosOperacionaisFixosIniciais: totalVendas * 0.10, // Estimativa
            ),
      ),
    );
  }

  void _mostrarFeedback(String mensagem, Color cor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // WIDGET BUILD E MÉTODOS DE UI CONSOLIDADOS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frente de Caixa"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Center(
            child: Badge(
              label: Text(_calcularTotalItensCarrinho().toString()),
              isLabelVisible: _calcularTotalItensCarrinho() > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Ver Carrinho',
                onPressed: () => _mostrarCarrinho(context),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child:
                _produtosFiltrados.isEmpty
                    ? const Center(child: Text("Nenhum produto encontrado."))
                    : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_produtosFiltrados[index]);
                      },
                    ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Buscar por nome do produto...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildProductCard(Produto produto) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                produto.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "R\$ ${produto.precoFinalComImposto.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Estoque: ${produto.estoque.toInt()}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed:
                      produto.vendas > 0
                          ? () => _venderProduto(produto, true)
                          : null,
                ),
                Text(
                  produto.vendas.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed:
                      produto.estoque > 0
                          ? () => _venderProduto(produto, false)
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('Análise de Lucro (Estimativa)'),
        onPressed: _navegarParaAnalise,
      ),
    );
  }

  void _mostrarCarrinho(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            final itensNoCarrinho =
                _todosProdutos.where((p) => p.vendas > 0).toList();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Meu Carrinho",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (itensNoCarrinho.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text("O carrinho está vazio."),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itensNoCarrinho.length,
                        itemBuilder: (context, index) {
                          final item = itensNoCarrinho[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(item.imageUrl),
                            ),
                            title: Text(item.nome),
                            subtitle: Text(
                              "${item.vendas.toInt()} x R\$ ${item.precoFinalComImposto.toStringAsFixed(2)}",
                            ),
                            trailing: Text(
                              "R\$ ${(item.vendas * item.precoFinalComImposto).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "R\$ ${_calcularTotalValorCarrinho().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _limparCarrinho,
                          child: const Text("Limpar"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _finalizarCompraEProcessarNota,
                          child: const Text("Finalizar Venda"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
