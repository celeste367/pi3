// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:pi3/modelos/produto_model.dart';
import 'package:pi3/servicos/vendas_service.dart';
import 'package:pi3/servicos/estoque_servico.dart'; // Importe o novo serviço
import 'lucro_page.dart';
import 'nota_fiscal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Obtenha instâncias dos serviços
  final VendasService _vendasService = VendasService();
  final EstoqueService _estoqueService = EstoqueService();

  // A lista de produtos virá do serviço
  late List<Produto> _todosProdutos;

  List<Produto> _produtosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega os produtos do serviço
    _todosProdutos = _estoqueService.getProdutos();
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
    final query = _searchController.text.toLowerCase().trim();
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
    return _todosProdutos.fold(0.0, (sum, p) => sum + (p.preco * p.vendas));
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
    _mostrarFeedback(
      "Carrinho esvaziado! Itens devolvidos ao estoque.",
      Colors.blueGrey,
    );
  }

  void _finalizarCompraEProcessarNota() async {
    final itensNoCarrinho = _todosProdutos.where((p) => p.vendas > 0).toList();
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
      Navigator.pop(context); // Fecha o modal do carrinho
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), // <- ADICIONADO
      appBar: AppBar(
        title: const Text("Frente de Caixa"),
        actions: [
          Center(
            child: Tooltip(
              message: "Ver Carrinho",
              child: Badge(
                label: Text(_calcularTotalItensCarrinho().toString()),
                isLabelVisible: _calcularTotalItensCarrinho() > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => _mostrarCarrinho(context),
                ),
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
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Buscar por nome do produto...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Produto produto) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    "R\$ ${produto.preco.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, color: Colors.teal.shade700),
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
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
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
              padding: EdgeInsets.fromLTRB(
                16,
                20,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Meu Carrinho",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  if (itensNoCarrinho.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text("O carrinho está vazio."),
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
                              "${item.vendas.toInt()} x R\$ ${item.preco.toStringAsFixed(2)}",
                            ),
                            trailing: Text(
                              "R\$ ${(item.vendas * item.preco).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text("Limpar"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _limparCarrinho();
                            modalSetState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment_outlined),
                          label: const Text("Finalizar Venda"),
                          onPressed: _finalizarCompraEProcessarNota,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
