import 'package:flutter/material.dart';
import 'lucro.dart'; // Para navegação à página de lucro

// Lista de estados como uma constante no escopo do arquivo
const List<String> kEstadosBrasileiros = [
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
];

class Produto {
  final String nome;
  final double preco;
  double estoque;
  double vendas; // Usado para contar itens no "carrinho"
  final String imageUrl;

  Produto({
    required this.nome,
    required this.preco,
    required this.estoque,
    this.vendas = 0,
    required this.imageUrl,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de produtos ATUALIZADA com imagens específicas e 5 novos produtos
  final List<Produto> _todosProdutos = [
    Produto(
      nome: 'Arroz Tipo 1 (5kg)',
      preco: 25.00,
      estoque: 150,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Arroz+5kg',
    ),
    Produto(
      nome: 'Feijão Carioca (1kg)',
      preco: 8.50,
      estoque: 200,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Feijão+1kg',
    ),
    Produto(
      nome: 'Óleo de Soja (900ml)',
      preco: 7.00,
      estoque: 120,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Óleo+900ml',
    ),
    Produto(
      nome: 'Açúcar Refinado (1kg)',
      preco: 4.40,
      estoque: 180,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Açúcar+1kg',
    ),
    Produto(
      nome: 'Café Tradicional (500g)',
      preco: 15.00,
      estoque: 160,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Café+500g',
    ),
    Produto(
      nome: 'Leite Integral (1L)',
      preco: 4.80,
      estoque: 300,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Leite+1L',
    ),
    Produto(
      nome: 'Pão de Forma Tradicional',
      preco: 6.50,
      estoque: 90,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Pão+Forma',
    ),
    // --- 5 NOVOS PRODUTOS ---
    Produto(
      nome: 'Maçã Fuji (Kg)',
      preco: 7.99,
      estoque: 70,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Maçã+Kg',
    ),
    Produto(
      nome: 'Banana Prata (Kg)',
      preco: 5.50,
      estoque: 85,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Banana+Kg',
    ),
    Produto(
      nome: 'Sabão em Pó (1kg)',
      preco: 12.90,
      estoque: 100,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Sabão+Pó+1kg',
    ),
    Produto(
      nome: 'Refrigerante Cola (2L)',
      preco: 8.00,
      estoque: 130,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Refrigerante+2L',
    ),
    Produto(
      nome: 'Biscoito Recheado Chocolate',
      preco: 3.50,
      estoque: 200,
      imageUrl: 'https://placehold.co/400x300/E8E8E8/555?text=Biscoito',
    ),
  ];
  List<Produto> _produtosFiltrados = [];

  final TextEditingController _searchController = TextEditingController();
  late TextEditingController _metrosQuadradosController;

  bool _showSuggestions = false;
  String? _selectedState;
  double _metrosQuadradosDefault = 100.0;

  @override
  void initState() {
    super.initState();
    _produtosFiltrados = List.from(_todosProdutos);
    _searchController.addListener(_filtrarProdutos);
    _metrosQuadradosController = TextEditingController(
      text: _metrosQuadradosDefault.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarProdutos);
    _searchController.dispose();
    _metrosQuadradosController.dispose();
    super.dispose();
  }

  void _filtrarProdutos() {
    String query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _produtosFiltrados = List.from(_todosProdutos);
      } else {
        _produtosFiltrados =
            _todosProdutos.where((produto) {
              return produto.nome.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  void _venderProduto(Produto produto, bool devolverEstoque) {
    setState(() {
      if (devolverEstoque) {
        if (produto.vendas > 0) {
          produto.estoque++;
          produto.vendas--;
          _mostrarFeedback(
            'Item removido do carrinho: "${produto.nome}".',
            Colors.orangeAccent,
          );
        }
      } else {
        if (produto.estoque > 0) {
          produto.estoque--;
          produto.vendas++;
          _mostrarFeedback(
            '"${produto.nome}" adicionado ao carrinho!',
            Colors.green,
          );
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
    return _todosProdutos.fold(
      0,
      (sum, produto) => sum + produto.vendas.toInt(),
    );
  }

  void _limparCarrinho() {
    setState(() {
      for (var produto in _todosProdutos) {
        if (produto.vendas > 0) {
          produto.estoque += produto.vendas;
          produto.vendas = 0;
        }
      }
    });
    if (mounted) Navigator.pop(context); // Fecha o modal do carrinho
    _mostrarFeedback("Carrinho esvaziado!", Colors.blueGrey);
  }

  void _mostrarFeedback(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        elevation: 4.0,
      ),
    );
  }

  double _calcularTotalValorCarrinho() {
    return _todosProdutos.fold(
      0.0,
      (sum, produto) => sum + (produto.preco * produto.vendas),
    );
  }

  List<String> _getStockRecommendations() {
    if (_todosProdutos.any((p) => p.estoque < 20)) {
      return [
        "Alerta: Produtos com estoque crítico (<20 unidades)! Reposição urgente.",
      ];
    }
    if (_todosProdutos.any((p) => p.estoque < 50)) {
      return [
        "Atenção: Alguns produtos com estoque baixo (<50 unidades)! Considere reposição.",
      ];
    }
    if (_todosProdutos.any((p) => p.estoque > 250 && p.vendas == 0)) {
      return [
        "Alguns produtos com estoque alto (>250 un.) e sem movimentação no carrinho. Considere promoções ou rever compras.",
      ];
    }
    return [
      "Nível de estoque parece estável. Monitore continuamente as vendas e o giro dos produtos.",
    ];
  }

  void _mostrarImagemProduto(BuildContext context, Produto produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            produto.nome,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    produto.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          strokeWidth: 2.0,
                          color: Colors.teal,
                        ),
                      );
                    },
                    errorBuilder: (
                      BuildContext context,
                      Object exception,
                      StackTrace? stackTrace,
                    ) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Imagem indisponível',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Preço: R\$ ${produto.preco.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('FECHAR'), // Estilo virá do TextButtonTheme
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  // --- FUNCIONALIDADE DO CARRINHO ---
  void _mostrarCarrinho(BuildContext context) {
    final itensNoCarrinho = _todosProdutos.where((p) => p.vendas > 0).toList();
    final totalCompra = _calcularTotalValorCarrinho();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.75,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meu Carrinho',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.grey[700],
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (itensNoCarrinho.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.remove_shopping_cart_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Seu carrinho está vazio.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: itensNoCarrinho.length,
                        separatorBuilder:
                            (context, index) => const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                        itemBuilder: (context, index) {
                          Produto item = itensNoCarrinho[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (imgCtx, err, st) => Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.hide_image_outlined,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nome,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Qtd: ${item.vendas.toInt()} x R\$ ${item.preco.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'R\$ ${(item.vendas * item.preco).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  if (itensNoCarrinho.isNotEmpty) ...[
                    const Divider(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'R\$ ${totalCompra.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('Limpar'),
                            onPressed: _limparCarrinho,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red[700],
                              side: BorderSide(color: Colors.red[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.payment_outlined),
                            label: const Text('Finalizar'),
                            onPressed: () {
                              Navigator.pop(ctx);
                              _mostrarFeedback(
                                'Funcionalidade "Finalizar Compra" não implementada.',
                                Colors.blueAccent,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // --- FIM DA FUNCIONALIDADE DO CARRINHO ---

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Buscar por nome do produto...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildStateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Estado (p/ cálculo de lucro)',
        ),
        hint: const Text('Selecione o Estado'),
        value: _selectedState,
        isExpanded: true,
        items:
            kEstadosBrasileiros.map((String estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Text(estado),
              );
            }).toList(),
        onChanged: (String? newState) {
          setState(() {
            _selectedState = newState;
          });
        },
      ),
    );
  }

  Widget _buildProductCard(Produto produto) {
    final chipTheme = Theme.of(context).chipTheme;
    return Card(
      child: InkWell(
        onTap: () => _mostrarImagemProduto(context, produto),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      produto.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          produto.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.teal[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text('Carrinho: ${produto.vendas.toInt()}'),
                    avatar: Icon(
                      Icons.shopping_cart_checkout,
                      size: chipTheme.iconTheme?.size,
                    ),
                  ),
                  Chip(
                    label: Text('Estoque: ${produto.estoque.toInt()}'),
                    avatar: Icon(
                      Icons.inventory_2_outlined,
                      size: chipTheme.iconTheme?.size,
                    ),
                    backgroundColor:
                        produto.estoque == 0
                            ? Colors.red[100]
                            : produto.estoque < 20
                            ? Colors.orange[100]
                            : chipTheme.backgroundColor,
                    labelStyle:
                        produto.estoque == 0
                            ? TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.w500,
                            )
                            : produto.estoque < 20
                            ? TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w500,
                            )
                            : chipTheme.labelStyle,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red[600],
                      size: 28,
                    ),
                    tooltip: 'Remover do Carrinho',
                    onPressed:
                        produto.vendas > 0
                            ? () => _venderProduto(produto, true)
                            : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.green[600],
                      size: 28,
                    ),
                    tooltip: 'Adicionar ao Carrinho',
                    onPressed:
                        produto.estoque > 0
                            ? () => _venderProduto(produto, false)
                            : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalItensCarrinho = _calcularTotalItensCarrinho();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos da Loja'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Badge(
                // Widget Badge para o contador
                label: Text(totalItensCarrinho.toString()),
                isLabelVisible: totalItensCarrinho > 0,
                backgroundColor: Colors.orangeAccent[700],
                textStyle: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                offset: const Offset(-4, 4),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                  tooltip: 'Ver Carrinho',
                  onPressed: () {
                    _mostrarCarrinho(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStateSelector(),
          Expanded(
            child:
                _produtosFiltrados.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 70,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'Nenhum produto encontrado para "${_searchController.text}".'
                                  : 'Nenhum produto cadastrado.', // Simplificado
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                      itemCount: _produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        Produto produto = _produtosFiltrados[index];
                        return _buildProductCard(produto);
                      },
                    ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _metrosQuadradosController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Metros Quadrados da Loja',
                    hintText: 'Ex: 150.5',
                    prefixIcon: Icon(Icons.square_foot_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: Icon(
                    _showSuggestions
                        ? Icons.visibility_off_outlined
                        : Icons.lightbulb_outline,
                  ),
                  label: Text(
                    _showSuggestions ? 'Ocultar Dicas' : 'Ver Dicas de Estoque',
                  ),
                  onPressed: () {
                    setState(() {
                      _showSuggestions = !_showSuggestions;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueGrey[700],
                    side: BorderSide(color: Colors.blueGrey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                if (_showSuggestions)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.blueGrey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _getStockRecommendations()
                                .map(
                                  (tip) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.blueGrey[700],
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            tip,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('Análise de Lucro (Estimativa)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_selectedState == null) {
                      _mostrarFeedback(
                        'Selecione um estado para a análise de lucro.',
                        Colors.redAccent,
                      );
                      return;
                    }
                    final String metrosQuadradosText =
                        _metrosQuadradosController.text.trim();
                    final double? metrosParsed = double.tryParse(
                      metrosQuadradosText,
                    );

                    if (metrosParsed == null || metrosParsed <= 0) {
                      _mostrarFeedback(
                        'Por favor, insira um valor válido para metros quadrados.',
                        Colors.redAccent,
                      );
                      return;
                    }

                    double totalVendasAtuaisNoCarrinho =
                        _calcularTotalValorCarrinho();
                    // Gastos operacionais de referência (10% das vendas atuais do carrinho)
                    double gastosOperacionaisBase =
                        totalVendasAtuaisNoCarrinho * 0.10;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => LucroPage(
                              totalVendasReferencia:
                                  totalVendasAtuaisNoCarrinho,
                              gastosOperacionaisFixosIniciais:
                                  gastosOperacionaisBase,
                              estadoSelecionado: _selectedState!,
                              metrosQuadrados: metrosParsed,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
