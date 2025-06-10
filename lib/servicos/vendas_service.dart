// lib/services/vendas_service.dart

import 'package:pi3/modelos/venda_model.dart';
import 'package:pi3/modelos/produto_model.dart';
import 'package:pi3/servicos/servico_autentificac%C3%A3o.dart';

class VendasService {
  static final List<Venda> _historicoVendas = [];

  Future<Venda> registrarVenda(List<Produto> produtosNoCarrinho) async {
    // ATUALIZADO: Usa o helper toMapVendidos que já contém a lógica de cálculo
    final List<Map<String, dynamic>> itensParaNota =
        produtosNoCarrinho.map((p) => p.toMapVendidos()).toList();

    // ATUALIZADO: O total da venda é a soma dos subtotais finais de cada item
    final double totalDaVendaFinal = itensParaNota.fold(
      0.0,
      (sum, item) => sum + item['subtotalFinal'],
    );

    // O total de impostos também vem do mapa de cada item
    final double totalImpostos = itensParaNota.fold(
      0.0,
      (sum, item) => sum + item['valorIcms'],
    );

    final novaVenda = Venda(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      data: DateTime.now(),
      itensVendidos: itensParaNota,
      totalVenda: totalDaVendaFinal, // Armazena o valor final com impostos
      totalImpostos: totalImpostos,
      usuario: AuthService.usuarioLogado,
    );

    _historicoVendas.insert(0, novaVenda);
    return novaVenda;
  }

  Future<List<Venda>> getHistoricoDeVendas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_historicoVendas);
  }
}
