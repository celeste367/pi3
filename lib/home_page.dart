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

  // Helper para criar uma cópia, útil para a nota fiscal
  Map<String, dynamic> toMapVendidos() {
    return {
      'nome': nome,
      'quantidade': vendas,
      'precoUnitario': preco,
      'subtotal': vendas * preco,
      'imageUrl': imageUrl, // Para exibir imagem na nota também
    };
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Produto> _todosProdutos = [
    Produto(
      nome: 'Arroz Tipo 1 (5kg)',
      preco: 25.00,
      estoque: 150,
      imageUrl:
          'https://www.arenaatacado.com.br/on/demandware.static/-/Sites-storefront-catalog-sv/default/dw6abd898d/Produtos/78166-7896006711155-arroz%20tipo%201%20camil%20pacote%205kg-camil-1.jpg',
    ),
    Produto(
      nome: 'Feijão Carioca (1kg)',
      preco: 8.50,
      estoque: 200,
      imageUrl:
          'https://carrefourbrfood.vtexassets.com/arquivos/ids/194917/466506_1.jpg?v=637272434027000000 ',
    ),
    Produto(
      nome: 'Óleo de Soja (900ml)',
      preco: 7.00,
      estoque: 120,
      imageUrl:
          'https://carrefourbrfood.vtexassets.com/arquivos/ids/211616/141836_1.jpg?v=637272514200130000',
    ),
    Produto(
      nome: 'Açúcar Refinado (1kg)',
      preco: 4.40,
      estoque: 180,
      imageUrl: 'https://m.media-amazon.com/images/I/811HPMq-KjL.jpg',
    ),
    Produto(
      nome: 'Café Tradicional (500g)',
      preco: 15.00,
      estoque: 160,
      imageUrl:
          'https://lojamelitta.vteximg.com.br/arquivos/ids/160281-1000-1000/7891021006125_1--845540a5-083b-4b57-8fde-87681c118e9b-.jpg?v=638169995339870000',
    ),
    Produto(
      nome: 'Leite Integral (1L)',
      preco: 4.80,
      estoque: 300,
      imageUrl:
          'https://piracanjuba-institucional-prd.s3.sa-east-1.amazonaws.com/product_images/image/leite-integral-piracanjuba-frente-1l-848x1007px-460.webp',
    ),
    Produto(
      nome: 'Pão de Forma Tradicional',
      preco: 6.50,
      estoque: 90,
      imageUrl:
          'https://wickbold.com.br/wp-content/uploads/2012/10/pao-tradicional-forma.png',
    ),
    Produto(
      nome: 'Maçã Fuji (Kg)',
      preco: 7.99,
      estoque: 70,
      imageUrl:
          'https://superangeloni.vtexassets.com/arquivos/ids/182199/158070_1_zoom.jpg?v=638039741032670000',
    ),
    Produto(
      nome: 'Banana Prata (Kg)',
      preco: 5.50,
      estoque: 85,
      imageUrl:
          'https://superirmao.com.br/storage/uploads/D1PW6zRVGSysFMXdgeGha5GCP3VUgXlzXoaOrGJd.png',
    ),
    Produto(
      nome: 'Sabão em Pó (1kg)',
      preco: 12.90,
      estoque: 100,
      imageUrl:
          'https://images.tcdn.com.br/img/img_prod/767437/sabao_em_po_omo_pacote_1kg_1017_1_20200408102937.jpg',
    ),
    Produto(
      nome: 'Refrigerante Cola (2L)',
      preco: 8.00,
      estoque: 130,
      imageUrl:
          'https://bretas.vtexassets.com/arquivos/ids/192050-800-auto?v=638375518430000000&width=800&height=auto&aspect=true',
    ),
    Produto(
      nome: 'Biscoito Recheado Chocolate',
      preco: 3.50,
      estoque: 200,
      imageUrl:
          'https://piraque.com.br/wp-content/uploads/2020/11/chocolate.png',
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

  void _limparCarrinho({bool fecharModal = true}) {
    // Adicionado parâmetro opcional
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

  void _mostrarFeedback(String mensagem, Color cor) {
    if (!mounted) return; // Evita erro se o widget não estiver na árvore
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

  // --- NOVA FUNÇÃO PARA FINALIZAR COMPRA E GERAR NOTA ---
  void _finalizarCompraEProcessarNota() {
    if (_selectedState == null) {
      _mostrarFeedback(
        'Selecione um estado para finalizar a compra.',
        Colors.redAccent,
      );
      return;
    }

    final String metrosQuadradosText = _metrosQuadradosController.text.trim();
    final double? metrosParsed = double.tryParse(
      metrosQuadradosText.replaceAll(',', '.'),
    ); // Aceita ',' ou '.'

    if (metrosParsed == null || metrosParsed <= 0) {
      _mostrarFeedback(
        'Por favor, insira um valor válido para metros quadrados.',
        Colors.redAccent,
      );
      return;
    }

    final List<Produto> itensVendidosOriginais =
        _todosProdutos.where((p) => p.vendas > 0).toList();

    if (itensVendidosOriginais.isEmpty) {
      _mostrarFeedback(
        'Seu carrinho está vazio. Adicione itens para finalizar.',
        Colors.orangeAccent,
      );
      return;
    }

    // Criar uma lista de Map para a nota fiscal, capturando o estado atual dos itens vendidos
    final List<Map<String, dynamic>> itensParaNota =
        itensVendidosOriginais.map((p) => p.toMapVendidos()).toList();

    final double totalDaVenda = _calcularTotalValorCarrinho();
    final DateTime dataDaVenda = DateTime.now();

    // Gastos operacionais de referência (10% do total da venda)
    double gastosOperacionaisBase = totalDaVenda * 0.10;

    // Resetar 'vendas' para 0 nos produtos originais
    // O estoque já foi decrementado ao adicionar ao carrinho.
    setState(() {
      for (var produto in itensVendidosOriginais) {
        // Encontrar o produto na lista _todosProdutos para garantir que estamos alterando o objeto correto
        final produtoOriginal = _todosProdutos.firstWhere(
          (p) => p.nome == produto.nome,
        );
        produtoOriginal.vendas = 0;
      }
    });

    if (mounted) Navigator.pop(context); // Fecha o modal do carrinho

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => LucroPage(
              itensDaNotaFiscal: itensParaNota,
              totalDaNotaFiscal: totalDaVenda,
              dataDaVenda: dataDaVenda,
              gastosOperacionaisFixosIniciais: gastosOperacionaisBase,
              estadoSelecionado: _selectedState!,
              metrosQuadrados: metrosParsed,
            ),
      ),
    );
    _mostrarFeedback('Compra finalizada com sucesso!', Colors.teal);
  }
  // --- FIM DA NOVA FUNÇÃO ---

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
    // Modificado: Verificar produtos com estoque alto E POUCAS OU NENHUMA VENDA RECENTE (no carrinho atual)
    if (_todosProdutos.any((p) => p.estoque > 200 && p.vendas < 2)) {
      // Ajustado para > 200 e vendas < 2
      return [
        "Alguns produtos com estoque alto (>200 un.) e baixa movimentação no carrinho. Considere promoções ou rever compras futuras.",
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
              Text(
                // Mostrar estoque no dialog também
                'Estoque: ${produto.estoque.toInt()} unidades',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('FECHAR'),
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
        // Usar StatefulBuilder para que o modal possa ser atualizado
        // se um item for removido de dentro do modal (não implementado aqui, mas boa prática)
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            // Recalcular itens e total DENTRO do builder do StatefulBuilder
            // para refletir mudanças se houvesse botões de +/- no carrinho.
            // Neste caso, _venderProduto atualiza o estado geral, então o modal
            // será reconstruído de qualquer forma.
            final currentItensNoCarrinho =
                _todosProdutos.where((p) => p.vendas > 0).toList();
            final currentTotalCompra = _calcularTotalValorCarrinho();

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
                      if (currentItensNoCarrinho.isEmpty)
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
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            itemCount: currentItensNoCarrinho.length,
                            separatorBuilder:
                                (context, index) => const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                            itemBuilder: (context, index) {
                              Produto item = currentItensNoCarrinho[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
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
                      if (currentItensNoCarrinho.isNotEmpty) ...[
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
                                'R\$ ${currentTotalCompra.toStringAsFixed(2)}',
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
                                // Passar fecharModal: false se o modal não deve fechar automaticamente
                                onPressed:
                                    () => _limparCarrinho(fecharModal: true),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red[700],
                                  side: BorderSide(color: Colors.red[300]!),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.payment_outlined),
                                label: const Text('Finalizar'),
                                onPressed:
                                    _finalizarCompraEProcessarNota, // MODIFICADO AQUI
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
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
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          // Usar InputDecorationTheme
          hintText: 'Buscar por nome do produto...',
          prefixIcon: const Icon(Icons.search),
          // border já vem do tema
        ),
      ),
    );
  }

  Widget _buildStateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          // Usar InputDecorationTheme
          labelText: 'Estado (p/ cálculo de lucro)',
          // border já vem do tema
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
      // CardTheme será aplicado
      child: InkWell(
        onTap: () => _mostrarImagemProduto(context, produto),
        borderRadius: BorderRadius.circular(12.0), // Idealmente do CardTheme
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
                            // Pode vir de TextTheme.titleMedium
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87, // Ou cor do tema
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: TextStyle(
                            // Pode vir de TextTheme.bodyLarge com cor primária
                            fontSize: 15,
                            color:
                                Colors
                                    .teal[700], // Ou Theme.of(context).colorScheme.primary
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
                      size: chipTheme.iconTheme?.size, // Usar tamanho do tema
                    ),
                    // backgroundColor e labelStyle virão do ChipTheme
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
                            : chipTheme.backgroundColor, // Cor padrão do tema
                    labelStyle:
                        produto.estoque == 0
                            ? TextStyle(
                              color: Colors.red[800], // Ou cor de erro do tema
                              fontWeight: FontWeight.w500,
                            )
                            : produto.estoque < 20
                            ? TextStyle(
                              color: Colors.orange[800], // Ou uma cor de aviso
                              fontWeight: FontWeight.w500,
                            )
                            : chipTheme.labelStyle, // Estilo padrão do tema
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
                      color: Colors.red[600], // Ou cor de erro
                      size: 28,
                    ),
                    tooltip: 'Remover do Carrinho',
                    onPressed:
                        produto.vendas > 0
                            ? () => _venderProduto(produto, true)
                            : null, // Desabilitado se não há o que remover
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.green[600], // Ou cor de sucesso/primária
                      size: 28,
                    ),
                    tooltip: 'Adicionar ao Carrinho',
                    onPressed:
                        produto.estoque > 0
                            ? () => _venderProduto(produto, false)
                            : null, // Desabilitado se sem estoque
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
        // AppBarTheme será aplicado
        title: const Text('Produtos da Loja'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Badge(
                label: Text(totalItensCarrinho.toString()),
                isLabelVisible: totalItensCarrinho > 0,
                backgroundColor:
                    Colors.orangeAccent[700], // Pode ser cor do tema
                textStyle: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Ou cor contrastante do tema
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
                              color: Colors.grey[400], // Ou cor do tema
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'Nenhum produto encontrado para "${_searchController.text}".'
                                  : 'Nenhum produto cadastrado.',
                              style: TextStyle(
                                // TextTheme.bodyLarge
                                fontSize: 17,
                                color: Colors.grey[600], // Ou cor do tema
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
            // Estilo de rodapé
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor, // Cor de fundo do tema
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
                    // InputDecorationTheme
                    labelText: 'Metros Quadrados da Loja',
                    hintText: 'Ex: 150.5 ou 150,5',
                    prefixIcon: Icon(Icons.square_foot_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  // OutlinedButtonTheme
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
                  // Estilo virá do OutlinedButtonTheme
                ),
                if (_showSuggestions)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color:
                            Colors
                                .blueGrey[50], // Ou cor de fundo sutil do tema
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.blueGrey[200]!,
                        ), // Ou cor de borda do tema
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
                                          color:
                                              Colors
                                                  .blueGrey[700], // Cor do tema
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            tip,
                                            style: TextStyle(
                                              // TextTheme.bodyMedium
                                              fontSize: 15,
                                              color:
                                                  Colors
                                                      .blueGrey[800], // Cor do tema
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
                  // ElevatedButtonTheme
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('Análise de Lucro (Estimativa)'),
                  // Estilo virá do ElevatedButtonTheme
                  onPressed: () {
                    // AÇÃO ORIGINAL DO BOTÃO DE ANÁLISE DE LUCRO
                    if (_selectedState == null) {
                      _mostrarFeedback(
                        'Selecione um estado para a análise de lucro.',
                        Colors.redAccent,
                      );
                      return;
                    }
                    final String metrosQuadradosText =
                        _metrosQuadradosController.text.trim().replaceAll(
                          ',',
                          '.',
                        );
                    final double? metrosParsed = double.tryParse(
                      metrosQuadradosText,
                    );

                    if (metrosParsed == null || metrosParsed <= 0) {
                      _mostrarFeedback(
                        'Por favor, insira um valor válido para metros quadrados para análise.',
                        Colors.redAccent,
                      );
                      return;
                    }

                    // Para a análise de lucro, usamos o valor do carrinho ATUAL como referência
                    // se o usuário quiser apenas simular sem finalizar uma compra.
                    // Se uma compra foi finalizada, LucroPage usará os dados daquela compra.
                    double totalVendasParaAnalise =
                        _calcularTotalValorCarrinho();
                    double gastosOperacionaisParaAnalise =
                        totalVendasParaAnalise * 0.10;

                    // Criar uma "nota fiscal" fictícia para a análise, se houver itens no carrinho
                    final List<Map<String, dynamic>> itensParaAnalise =
                        _todosProdutos
                            .where((p) => p.vendas > 0)
                            .map((p) => p.toMapVendidos())
                            .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => LucroPage(
                              // Se houver itens no carrinho, usa-os para a análise
                              itensDaNotaFiscal:
                                  itensParaAnalise.isNotEmpty
                                      ? itensParaAnalise
                                      : [
                                        {
                                          'nome':
                                              'Venda de Referência (Simulação)',
                                          'quantidade': 1,
                                          'precoUnitario':
                                              totalVendasParaAnalise,
                                          'subtotal': totalVendasParaAnalise,
                                          'imageUrl': '',
                                        },
                                      ],
                              totalDaNotaFiscal:
                                  totalVendasParaAnalise, // total do carrinho atual
                              dataDaVenda:
                                  DateTime.now(), // data atual para simulação
                              gastosOperacionaisFixosIniciais:
                                  gastosOperacionaisParaAnalise,
                              estadoSelecionado: _selectedState!,
                              metrosQuadrados: metrosParsed,
                              isAnaliseSimulada:
                                  true, // Novo parâmetro para indicar que é simulação
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
