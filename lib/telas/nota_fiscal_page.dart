// lib/screens/nota_fiscal_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi3/modelos/venda_model.dart';

class NotaFiscalPage extends StatelessWidget {
  final Venda venda;
  const NotaFiscalPage({super.key, required this.venda});

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final formatadorData = DateFormat('dd/MM/yyyy HH:mm:ss');

    // ATUALIZADO: Calcula o total base dos produtos (Total Final - Impostos)
    final double totalProdutosBase = venda.totalVenda - venda.totalImpostos;

    return Scaffold(
      appBar: AppBar(title: const Text('Nota Fiscal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // (Cabeçalho não muda)
                const Text(
                  'Loja Fictícia LTDA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Divider(height: 30, thickness: 2),

                Text(
                  'Nota Fiscal Nº: ${venda.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Data/Hora: ${formatadorData.format(venda.data)}'),
                const SizedBox(height: 20),

                // ATUALIZADO: A tabela de itens agora usa os valores base e finais corretos
                _buildTabelaItens(context, formatadorMoeda),
                const Divider(height: 30),

                // ATUALIZADO: Totais agora mostram a decomposição do valor
                _buildTotalRow(
                  'Total Produtos (Base):',
                  formatadorMoeda.format(totalProdutosBase),
                ),
                _buildTotalRow(
                  'Valor Total do ICMS:',
                  formatadorMoeda.format(venda.totalImpostos),
                ),
                const SizedBox(height: 8),
                _buildTotalRow(
                  'VALOR TOTAL DA NOTA:',
                  formatadorMoeda.format(
                    venda.totalVenda,
                  ), // Este é o valor final pago
                  isFinalTotal: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ATUALIZADO: Tabela de itens mostra o preço unitário base e o subtotal com imposto
  Widget _buildTabelaItens(BuildContext context, NumberFormat fMoeda) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
      },
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            _tableHeader('Descrição'),
            _tableHeader('Qtd.'),
            _tableHeader('Vl. Unit (Base)'),
            _tableHeader('Vl. Total (Final)'),
          ],
        ),
        ...venda.itensVendidos.map((item) {
          return TableRow(
            children: [
              _tableCell(item['nome'], align: TextAlign.left),
              _tableCell(item['quantidade'].toInt().toString()),
              _tableCell(
                fMoeda.format(item['precoUnitario']),
              ), // Preço base unitário
              _tableCell(
                fMoeda.format(item['subtotalFinal']),
                isBold: true,
              ), // Subtotal final (com imposto)
            ],
          );
        }),
      ],
    );
  }

  // (Os helpers _tableHeader, _tableCell e _buildTotalRow não precisam de alteração)
  Widget _tableHeader(String text) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
  Widget _tableCell(
    String text, {
    TextAlign align = TextAlign.center,
    bool isBold = false,
  }) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
  Widget _buildTotalRow(
    String label,
    String value, {
    bool isFinalTotal = false,
  }) {
    final style = TextStyle(
      fontSize: isFinalTotal ? 18 : 16,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}
