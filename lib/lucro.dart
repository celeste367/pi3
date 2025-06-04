import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar data e moeda

// Exemplo de impostos por estado (simplificado, consulte legislação!)
const Map<String, double> kImpostosPorEstado = {
  'SP': 0.18, 'RJ': 0.20, 'MG': 0.18, 'RS': 0.17, 'PR': 0.19, 'SC': 0.17,
  'BA': 0.19, 'PE': 0.18, 'CE': 0.20, 'DF': 0.18, 'ES': 0.17, 'GO': 0.17,
  'MT': 0.17, 'MS': 0.17, 'AL': 0.19, 'AM': 0.20, 'AP': 0.18, 'MA': 0.20,
  'PA': 0.19, 'PB': 0.20, 'PI': 0.21, 'RN': 0.20, 'RO': 0.175, 'RR': 0.20,
  'SE': 0.22, 'TO': 0.20, 'AC': 0.19,
  // Adicione mais estados e alíquotas conforme necessário
};

// Custo por metro quadrado de referência (simplificado)
const double kCustoPorMetroQuadradoReferencia =
    15.0; // Ex: R$15/m² para aluguel/IPTU estimado

class LucroPage extends StatefulWidget {
  final List<Map<String, dynamic>> itensDaNotaFiscal;
  final double totalDaNotaFiscal;
  final DateTime dataDaVenda;
  final double gastosOperacionaisFixosIniciais;
  final String estadoSelecionado;
  final double metrosQuadrados;
  final bool isAnaliseSimulada; // Novo parâmetro

  const LucroPage({
    super.key,
    required this.itensDaNotaFiscal,
    required this.totalDaNotaFiscal,
    required this.dataDaVenda,
    required this.gastosOperacionaisFixosIniciais,
    required this.estadoSelecionado,
    required this.metrosQuadrados,
    this.isAnaliseSimulada = false, // Default para falso
  });

  @override
  _LucroPageState createState() => _LucroPageState();
}

class _LucroPageState extends State<LucroPage> {
  late TextEditingController _gastosOperacionaisController;
  late double _impostoEstadualCalculado;
  late double _custoInfraestruturaEstimado;
  late double _lucroBruto;
  late double _lucroLiquidoEstimado;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

  @override
  void initState() {
    super.initState();
    _gastosOperacionaisController = TextEditingController(
      text: widget.gastosOperacionaisFixosIniciais.toStringAsFixed(2),
    );
    _calcularEstimativas();
    _gastosOperacionaisController.addListener(_calcularEstimativas);
  }

  @override
  void dispose() {
    _gastosOperacionaisController.removeListener(_calcularEstimativas);
    _gastosOperacionaisController.dispose();
    super.dispose();
  }

  void _calcularEstimativas() {
    final double gastosOperacionais =
        double.tryParse(
          _gastosOperacionaisController.text.replaceAll(',', '.'),
        ) ??
        widget.gastosOperacionaisFixosIniciais;

    // Imposto estadual (ICMS ou similar - simplificado)
    final double aliquotaImposto =
        kImpostosPorEstado[widget.estadoSelecionado] ??
        0.18; // Padrão 18% se não encontrado
    _impostoEstadualCalculado = widget.totalDaNotaFiscal * aliquotaImposto;

    // Custo de infraestrutura (aluguel, IPTU, etc. - simplificado)
    _custoInfraestruturaEstimado =
        widget.metrosQuadrados * kCustoPorMetroQuadradoReferencia;

    // Lucro Bruto = Total da Venda - Gastos Operacionais Variáveis (que já estão no controller)
    // Para simplificar, vamos assumir que os "gastos operacionais" no controller são os custos DIRETOS dos produtos.
    // E os custos fixos são imposto e infraestrutura.
    // Neste modelo, o totalDaNotaFiscal JÁ É A RECEITA BRUTA da venda.
    // Custo dos Produtos Vendidos (CPV) - Para este exemplo, não temos o custo individual de compra dos produtos.
    // Vamos assumir que o "lucro" é sobre o preço de venda, e os "gastos operacionais" são outros custos.
    // Uma forma mais realista seria: Lucro Bruto = Total Venda - Custo dos Produtos Vendidos.
    // E Lucro Líquido = Lucro Bruto - Impostos - Gastos Operacionais Fixos - Custo Infraestrutura.
    // Por ora, vamos manter a lógica original do app e adicionar os novos custos.

    _lucroBruto = widget.totalDaNotaFiscal; // Receita da venda

    double totalDespesas =
        gastosOperacionais +
        _impostoEstadualCalculado +
        _custoInfraestruturaEstimado;
    _lucroLiquidoEstimado = _lucroBruto - totalDespesas;

    setState(() {});
  }

  Widget _buildInfoCard(
    String title,
    String value, {
    Color valueColor = Colors.black87,
    IconData? icon,
  }) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Theme.of(context).primaryColor, size: 28),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAnaliseSimulada
              ? 'Análise de Lucro (Simulação)'
              : 'Detalhes da Venda e Lucro',
        ),
        backgroundColor: Colors.teal, // Theming
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Seção da Nota Fiscal
            Card(
              elevation: 3.0,
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isAnaliseSimulada
                          ? 'Itens da Simulação:'
                          : 'Nota Fiscal Simplificada',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Data: ${_dateFormat.format(widget.dataDaVenda)}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Estado: ${widget.estadoSelecionado}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                    if (widget.itensDaNotaFiscal.isEmpty ||
                        (widget.isAnaliseSimulada &&
                            widget.totalDaNotaFiscal == 0))
                      const Text(
                        'Nenhum item nesta venda/simulação.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.itensDaNotaFiscal.length,
                        itemBuilder: (context, index) {
                          final item = widget.itensDaNotaFiscal[index];
                          // Para simulação sem itens, pode não ter imageUrl
                          final hasImage =
                              item['imageUrl'] != null &&
                              (item['imageUrl'] as String).isNotEmpty;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                if (hasImage)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Image.network(
                                      item['imageUrl'],
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (ctx, err, st) => Container(
                                            width: 40,
                                            height: 40,
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 20,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                    ),
                                  ),
                                if (hasImage) const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${item['nome']} (Qtd: ${(item['quantidade'] is double ? (item['quantidade'] as double).toInt() : item['quantidade'])})', // Handle double or int
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                Text(
                                  _currencyFormat.format(item['subtotal']),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const Divider(height: 20, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'TOTAL DA VENDA: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currencyFormat.format(widget.totalDaNotaFiscal),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Text(
              'Estimativa de Custos e Lucro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Total da Venda (Receita Bruta)
            _buildInfoCard(
              'Receita Bruta da Venda:',
              _currencyFormat.format(widget.totalDaNotaFiscal),
              icon: Icons.monetization_on_outlined,
              valueColor: Colors.green[700]!,
            ),

            TextField(
              controller: _gastosOperacionaisController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText:
                    'Custos Operacionais Variáveis (Ex: Custo Produtos, Embalagens)',
                hintText: '0.00',
                prefixIcon: Icon(
                  Icons.shopping_bag_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixText: 'R\$',
              ),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              'Imposto Estadual Estimado (${widget.estadoSelecionado} - ${(kImpostosPorEstado[widget.estadoSelecionado]! * 100).toStringAsFixed(1)}%):',
              _currencyFormat.format(_impostoEstadualCalculado),
              icon: Icons.gavel_outlined,
              valueColor: Colors.red[700]!,
            ),

            _buildInfoCard(
              'Custo de Infraestrutura Estimado (${widget.metrosQuadrados.toStringAsFixed(1)} m²):',
              _currencyFormat.format(_custoInfraestruturaEstimado),
              icon: Icons.store_mall_directory_outlined,
              valueColor: Colors.orange[700]!,
            ),

            const Divider(height: 24, thickness: 1.5),

            _buildInfoCard(
              'LUCRO LÍQUIDO ESTIMADO:',
              _currencyFormat.format(_lucroLiquidoEstimado),
              icon:
                  _lucroLiquidoEstimado >= 0
                      ? Icons.trending_up_outlined
                      : Icons.trending_down_outlined,
              valueColor:
                  _lucroLiquidoEstimado >= 0
                      ? Colors.blue[700]!
                      : Colors.red[700]!,
            ),

            const SizedBox(height: 20),
            Text(
              'Atenção: Esta é uma estimativa simplificada. Custos reais podem variar. Consulte um contador para análises financeiras precisas.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
