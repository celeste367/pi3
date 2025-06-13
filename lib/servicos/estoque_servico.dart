// lib/services/estoque_service.dart

import 'package:pi3/modelos/produto_model.dart';

class EstoqueService {
  // Padrão Singleton para garantir uma única instância do serviço no app
  static final EstoqueService _instance = EstoqueService._internal();

  factory EstoqueService() {
    return _instance;
  }

  EstoqueService._internal();

  // A lista de produtos agora vive aqui, e não mais na HomePage.
  final List<Produto> _produtos = [
    Produto(
      nome: 'Arroz Tipo 1 (5kg)',
      preco: 25.00,
      estoque: 150,
      aliquotaIcms: 0.07,
      imageUrl:
          'https://www.arenaatacado.com.br/on/demandware.static/-/Sites-storefront-catalog-sv/default/dw6abd898d/Produtos/78166-7896006711155-arroz%20tipo%201%20camil%20pacote%205kg-camil-1.jpg',
    ),
    Produto(
      nome: 'Feijão Carioca (1kg)',
      preco: 8.50,
      estoque: 200,
      aliquotaIcms: 0.07,
      imageUrl:
          'https://carrefourbrfood.vtexassets.com/arquivos/ids/194917/466506_1.jpg?v=637272434027000000',
    ),
    Produto(
      nome: 'Óleo de Soja (900ml)',
      preco: 7.00,
      estoque: 35, // Estoque baixo para teste do relatório
      aliquotaIcms: 0.07,
      imageUrl:
          'https://carrefourbrfood.vtexassets.com/arquivos/ids/211616/141836_1.jpg?v=637272514200130000',
    ),
    Produto(
      nome: 'Refrigerante Cola (2L)',
      preco: 8.00,
      estoque: 130,
      aliquotaIcms: 0.18,
      imageUrl:
          'https://bretas.vtexassets.com/arquivos/ids/192050-800-auto?v=638375518430000000&width=800&height=auto&aspect=true',
    ),
    Produto(
      nome: 'Açúcar Refinado (1kg)',
      preco: 4.40,
      estoque: 180,
      aliquotaIcms: 0.07,
      imageUrl: 'https://m.media-amazon.com/images/I/811HPMq-KjL.jpg',
    ),
    Produto(
      nome: 'Sabão em Pó (1kg)',
      preco: 12.90,
      estoque: 18, // Estoque crítico para teste do relatório
      aliquotaIcms: 0.18,
      imageUrl:
          'https://images.tcdn.com.br/img/img_prod/767437/sabao_em_po_omo_pacote_1kg_1017_1_20200408102937.jpg',
    ),
  ];

  // Método para obter a lista de produtos
  List<Produto> getProdutos() {
    return _produtos;
  }

  // Método para atualizar o estoque de um produto
  Future<void> atualizarEstoque(Produto produto, double novaQuantidade) async {
    // Simula uma chamada de API
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _produtos.indexWhere((p) => p.nome == produto.nome);
    if (index != -1) {
      _produtos[index].estoque = novaQuantidade;
    }
  }

  // Método para o relatório de estoque baixo
  List<Produto> getProdutosComEstoqueBaixo({int limite = 50}) {
    return _produtos.where((p) => p.estoque < limite).toList();
  }
}
