// lucro_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class LucroPage extends StatefulWidget {
  final List<Map<String, dynamic>> itensDaNotaFiscal;
  final double totalDaNotaFiscal;
  final DateTime dataDaVenda;
  final double gastosOperacionaisFixosIniciais;

  const LucroPage({
    super.key,
    required this.itensDaNotaFiscal,
    required this.totalDaNotaFiscal,
    required this.dataDaVenda,
    required this.gastosOperacionaisFixosIniciais,
  });

  @override
  _LucroPageState createState() => _LucroPageState();
}

class _LucroPageState extends State<LucroPage> {
  late final TextEditingController _impostosController;
  late final TextEditingController _outrosCustosController;
  late double _lucroLiquido;
  late double _totalCustos;

  @override
  void initState() {
    super.initState();
    _impostosController = TextEditingController(text: '0.00');
    _outrosCustosController = TextEditingController(text: '0.00');

    _recalcularLucro(); // Calcula o lucro inicial

    // Adiciona listeners para recalcular quando os valores mudarem
    _impostosController.addListener(_recalcularLucro);
    _outrosCustosController.addListener(_recalcularLucro);
  }

  void _recalcularLucro() {
    final double impostos =
        double.tryParse(_impostosController.text.replaceAll(',', '.')) ?? 0.0;
    final double outrosCustos =
        double.tryParse(_outrosCustosController.text.replaceAll(',', '.')) ??
        0.0;

    setState(() {
      _totalCustos =
          widget.gastosOperacionaisFixosIniciais + impostos + outrosCustos;
      _lucroLiquido = widget.totalDaNotaFiscal - _totalCustos;
    });
  }

  @override
  void dispose() {
    _impostosController.dispose();
    _outrosCustosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final formatadorData = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Lucro / Nota'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Seção da Nota Fiscal
          _buildSectionCard(
            title: 'Itens da Venda',
            icon: Icons.receipt_long,
            child: Column(
              children:
                  widget.itensDaNotaFiscal.map((item) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            (item['imageUrl'] != null &&
                                    item['imageUrl'].isNotEmpty)
                                ? NetworkImage(item['imageUrl'])
                                : null,
                        child:
                            (item['imageUrl'] == null ||
                                    item['imageUrl'].isEmpty)
                                ? const Icon(Icons.shopping_bag)
                                : null,
                      ),
                      title: Text(item['nome']),
                      subtitle: Text(
                        '${item['quantidade']} x ${formatadorMoeda.format(item['precoUnitario'])}',
                      ),
                      trailing: Text(formatadorMoeda.format(item['subtotal'])),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Seção de Análise de Lucro
          _buildSectionCard(
            title: 'Análise Financeira',
            icon: Icons.analytics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnaliseRow(
                  'Data da Venda:',
                  formatadorData.format(widget.dataDaVenda),
                ),
                const Divider(height: 20),
                _buildAnaliseRow(
                  'Receita Bruta (Total da Venda):',
                  formatadorMoeda.format(widget.totalDaNotaFiscal),
                  isTotal: true,
                ),
                const Divider(height: 20),
                _buildAnaliseRow(
                  '(-) Gastos Operacionais (10%):',
                  formatadorMoeda.format(
                    widget.gastosOperacionaisFixosIniciais,
                  ),
                ),
                _buildCustoTextField(
                  controller: _impostosController,
                  label: '(-) Impostos (Valor Fixo)',
                ),
                _buildCustoTextField(
                  controller: _outrosCustosController,
                  label: '(-) Outros Custos Variáveis',
                ),
                const Divider(height: 20, thickness: 1.5),
                _buildAnaliseRow(
                  '(=) Lucro Líquido Estimado:',
                  formatadorMoeda.format(_lucroLiquido),
                  isTotal: true,
                  color:
                      _lucroLiquido >= 0
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAnaliseRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustoTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: 'R\$ ',
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
        ],
      ),
    );
  }
}
