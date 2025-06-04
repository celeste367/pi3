class EmpresaDetalhes {
  final String nome;
  final String cnpj;
  final String endereco;
  final String telefone;
  final String email;

  EmpresaDetalhes({
    required this.nome,
    required this.cnpj,
    required this.endereco,
    required this.telefone,
    required this.email,
  });
}

class ClienteDetalhes {
  final String nome;
  final String cpf; // ou CNPJ
  final String endereco;

  ClienteDetalhes({
    required this.nome,
    required this.cpf,
    required this.endereco,
  });
}

class ItemNotaFiscal {
  final String nomeProduto;
  final int quantidade;
  final double precoUnitario;
  final double subtotal;

  ItemNotaFiscal({
    required this.nomeProduto,
    required this.quantidade,
    required this.precoUnitario,
    required this.subtotal,
  });
}

class NotaFiscal {
  final String numero;
  final DateTime dataEmissao;
  final EmpresaDetalhes empresa;
  final ClienteDetalhes cliente;
  final List<ItemNotaFiscal> itens;
  final double totalDescontos;
  final double totalImpostosAproximado; // Simplificado
  final double valorTotal;
  final String? observacoes;

  NotaFiscal({
    required this.numero,
    required this.dataEmissao,
    required this.empresa,
    required this.cliente,
    required this.itens,
    this.totalDescontos = 0.0,
    required this.totalImpostosAproximado,
    required this.valorTotal,
    this.observacoes,
  });
}
