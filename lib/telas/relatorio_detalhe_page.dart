// lib/screens/relatorio_detalhe_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi3/modelos/produto_model.dart';
import 'package:pi3/modelos/venda_model.dart';
import 'package:pi3/servicos/estoque_servico.dart';
import 'package:pi3/servicos/vendas_service.dart';

enum TipoRelatorio { vendas, estoqueBaixo }

class RelatorioDetalhePage extends StatefulWidget {
  final String titulo;
  final TipoRelatorio tipoRelatorio;

  const RelatorioDetalhePage({
    super.key,
    required this.titulo,
    required this.tipoRelatorio,
  });

  @override
  _RelatorioDetalhePageState createState() => _RelatorioDetalhePageState();
}

class _RelatorioDetalhePageState extends State<RelatorioDetalhePage> {
  final VendasService _vendasService = VendasService();
  final EstoqueService _estoqueService = EstoqueService();
  late Future<Widget> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = _buildReportWidget();
  }

  Future<Widget> _buildReportWidget() async {
    switch (widget.tipoRelatorio) {
      case TipoRelatorio.vendas:
        final vendas = await _vendasService.getHistoricoDeVendas();
        return _buildRelatorioVendas(vendas);
      case TipoRelatorio.estoqueBaixo:
        final produtos = _estoqueService.getProdutosComEstoqueBaixo();
        return _buildRelatorioEstoque(produtos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Widget>(
          future: _reportFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao gerar relatório: ${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("Nenhum dado para exibir."));
            }
            return snapshot.data!;
          },
        ),
      ),
    );
  }

  // WIDGETS CONSTRUTORES DE RELATÓRIO

  Widget _buildRelatorioVendas(List<Venda> vendas) {
    if (vendas.isEmpty) {
      return const Center(child: Text("Nenhuma venda registrada ainda."));
    }

    final fMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final totalFaturado = vendas.fold(0.0, (sum, v) => sum + v.totalVenda);
    final totalImpostos = vendas.fold(0.0, (sum, v) => sum + v.totalImpostos);
    final totalItens = vendas.fold(0, (sum, v) => sum + v.itensVendidos.length);

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoRow(
                  "Faturamento Bruto Total:",
                  fMoeda.format(totalFaturado),
                  isHeader: true,
                ),
                _buildInfoRow(
                  "Total de Impostos (ICMS):",
                  fMoeda.format(totalImpostos),
                ),
                _buildInfoRow("Número de Vendas:", vendas.length.toString()),
                _buildInfoRow(
                  "Total de Itens Vendidos:",
                  totalItens.toString(),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Histórico de Vendas",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...vendas.map(
          (venda) => Card(
            child: ListTile(
              title: Text("Venda #${venda.id.substring(venda.id.length - 4)}"),
              subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(venda.data)),
              trailing: Text(fMoeda.format(venda.totalVenda)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatorioEstoque(List<Produto> produtos) {
    if (produtos.isEmpty) {
      return const Center(child: Text("Nenhum produto com estoque baixo."));
    }
    return ListView.builder(
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        final produto = produtos[index];
        return Card(
          color:
              produto.estoque < 20 ? Colors.red.shade50 : Colors.orange.shade50,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(produto.imageUrl),
            ),
            title: Text(produto.nome),
            trailing: Text(
              "Estoque: ${produto.estoque.toInt()}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHeader ? 18 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHeader ? 18 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
