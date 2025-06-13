// lib/models/produto_model.dart

class Produto {
  late final String nome;
  // ATENÇÃO: 'preco' agora representa o PREÇO BASE (sem impostos).
  late final double preco;
  double estoque;
  double vendas;
  final String imageUrl;
  final double aliquotaIcms;

  Produto({
    required this.nome,
    required this.preco,
    required this.estoque,
    this.vendas = 0,
    required this.imageUrl,
    required this.aliquotaIcms,
  });

  // Novo getter para calcular o preço final de uma unidade com imposto
  double get precoFinalComImposto {
    return preco * (1 + aliquotaIcms);
  }

  // Helper atualizado para a nota fiscal
  Map<String, dynamic> toMapVendidos() {
    double subtotalBase = vendas * preco;
    double valorIcms = subtotalBase * aliquotaIcms;
    // O subtotal final agora é a soma do valor base + o valor do imposto
    double subtotalFinal = subtotalBase + valorIcms;

    return {
      'nome': nome,
      'quantidade': vendas,
      'precoUnitario': preco, // Preço base
      'subtotalBase': subtotalBase,
      'aliquotaIcms': aliquotaIcms,
      'valorIcms': valorIcms,
      'subtotalFinal': subtotalFinal, // Subtotal com imposto
      'imageUrl': imageUrl,
    };
  }
}
