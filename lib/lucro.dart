import 'package:flutter/material.dart';
import 'dart:math'; // Para o Random

// Modelo de dados para o resultado do lucro
class LucroSupermercadoResultado {
  final double vendasMensaisEstimadas;
  final double cmvEstimado; // Custo da Mercadoria Vendida
  final double gastosOperacionaisVariaveisEstimados;
  final double custosFixosEstruturaEstimados;
  final double outrosGastosOperacionaisFixosRef; // Renomeado para clareza
  final double lucroLiquidoMensalEstimado;
  // Derivados para exibição
  final double vendasDiariasEstimadas;
  final double lucroDiarioEstimado;
  final double lucroAnualEstimado;

  LucroSupermercadoResultado({
    required this.vendasMensaisEstimadas,
    required this.cmvEstimado,
    required this.gastosOperacionaisVariaveisEstimados,
    required this.custosFixosEstruturaEstimados,
    required this.outrosGastosOperacionaisFixosRef,
    required this.lucroLiquidoMensalEstimado,
  }) : vendasDiariasEstimadas = vendasMensaisEstimadas / 30,
       lucroDiarioEstimado = lucroLiquidoMensalEstimado / 30,
       lucroAnualEstimado = lucroLiquidoMensalEstimado * 12;
}

class LucroPage extends StatefulWidget {
  final double
  totalVendasReferencia; // Vendas atuais da HomePage (carrinho), para referência de custos fixos
  final double
  gastosOperacionaisFixosIniciais; // Ex: 10% das vendas de referência da HomePage
  final String estadoSelecionado;
  final double metrosQuadrados;

  const LucroPage({
    super.key,
    required this.totalVendasReferencia,
    required this.gastosOperacionaisFixosIniciais,
    required this.estadoSelecionado,
    required this.metrosQuadrados,
  });

  @override
  _LucroPageState createState() => _LucroPageState();
}

class _LucroPageState extends State<LucroPage> {
  late String _estadoAtual;
  // _vendasMensaisEstimadasMercado será calculado e usado diretamente
  LucroSupermercadoResultado? _lucroCalculado;

  // --- Fatores para Simulação (EXEMPLOS) ---
  // Estes valores devem ser ajustados com base em dados reais ou pesquisas de mercado
  final Map<String, double> _fatorMercadoPorEstado = {
    'AC': 0.7,
    'AL': 0.8,
    'AP': 0.75,
    'AM': 0.65,
    'BA': 0.9,
    'CE': 0.85,
    'DF': 1.1,
    'ES': 0.95,
    'GO': 1.0,
    'MA': 0.7,
    'MT': 0.9,
    'MS': 0.85,
    'MG': 1.05,
    'PA': 0.8,
    'PB': 0.8,
    'PR': 1.1,
    'PE': 0.9,
    'PI': 0.75,
    'RJ': 1.15,
    'RN': 0.85,
    'RS': 1.05,
    'RO': 0.7,
    'RR': 0.6,
    'SC': 1.1,
    'SP': 1.25,
    'SE': 0.8,
    'TO': 0.85,
  };
  final Map<String, double> _custoPercentualProdutoPorEstado = {
    // % do CMV sobre as vendas
    'AC': 0.65,
    'AL': 0.60,
    'AP': 0.62,
    'AM': 0.70,
    'BA': 0.63,
    'CE': 0.58,
    'DF': 0.61,
    'ES': 0.59,
    'GO': 0.62,
    'MA': 0.67,
    'MT': 0.65,
    'MS': 0.64,
    'MG': 0.59,
    'PA': 0.69,
    'PB': 0.61,
    'PR': 0.63,
    'PE': 0.62,
    'PI': 0.66,
    'RJ': 0.60,
    'RN': 0.61,
    'RS': 0.64,
    'RO': 0.68, 'RR': 0.70, 'SC': 0.63, 'SP': 0.62, 'SE': 0.61, 'TO': 0.65,
  };
  final double _custoFixoPorMetroQuadradoMensal =
      25.0; // R$/mês por m² (aluguel, iptu, energia base)
  final double _baseVendasPorMetroQuadradoMensal =
      700.0; // R$/mês de vendas por m² (potencial base)
  final double _percentualGastosOperacionaisVariaveis =
      0.08; // 8% das vendas (embalagens, taxas cartão, etc.)
  // -------------------------------------------

  @override
  void initState() {
    super.initState();
    _estadoAtual = widget.estadoSelecionado;
    _estimarVendasEMostrarLucro();
  }

  void _estimarVendasEMostrarLucro() {
    // 1. Estimar Vendas de Mercado
    double fatorEstado = _fatorMercadoPorEstado[_estadoAtual] ?? 1.0;
    double variacaoMercado =
        (Random().nextDouble() * 0.2) - 0.1; // Variação de -10% a +10%
    double vendasEstimadas =
        widget.metrosQuadrados *
        _baseVendasPorMetroQuadradoMensal *
        fatorEstado *
        (1 + variacaoMercado);
    vendasEstimadas = vendasEstimadas.clamp(
      5000.0,
      500000.0,
    ); // Limita o valor para realismo

    // 2. Calcular Lucro com base na estimativa
    _calcularLucroComVendas(vendasEstimadas);
  }

  void _calcularLucroComVendas(double vendasMensaisConsideradas) {
    // Custos Variáveis (escalam com vendasMensaisConsideradas)
    double custoProdutoPercentual =
        _custoPercentualProdutoPorEstado[_estadoAtual] ?? 0.60;
    double cmvEstimado = vendasMensaisConsideradas * custoProdutoPercentual;
    double gastosOpVariaveisEstimados =
        vendasMensaisConsideradas * _percentualGastosOperacionaisVariaveis;

    // Custos Fixos
    double custosFixosEstrutura =
        widget.metrosQuadrados * _custoFixoPorMetroQuadradoMensal;

    // Outros Gastos Operacionais Fixos (de referência da loja/carrinho atual)
    // Este valor (widget.gastosOperacionaisFixosIniciais) foi calculado como 10% das vendas de REFERÊNCIA.
    // Para uma simulação de mercado, é importante entender se este valor é um custo fixo real da operação
    // ou se deveria também escalar ou ser reavaliado.
    // Mantendo a lógica de subtraí-lo como um custo fixo de referência:
    double outrosGastosFixosRef = widget.gastosOperacionaisFixosIniciais;

    // Cálculo do Lucro Líquido Mensal
    double lucroLiquidoMensal =
        vendasMensaisConsideradas -
        cmvEstimado -
        gastosOpVariaveisEstimados -
        custosFixosEstrutura -
        outrosGastosFixosRef; // Subtrai os custos fixos de referência

    setState(() {
      _lucroCalculado = LucroSupermercadoResultado(
        vendasMensaisEstimadas: vendasMensaisConsideradas,
        cmvEstimado: cmvEstimado,
        gastosOperacionaisVariaveisEstimados: gastosOpVariaveisEstimados,
        custosFixosEstruturaEstimados: custosFixosEstrutura,
        outrosGastosOperacionaisFixosRef: outrosGastosFixosRef,
        lucroLiquidoMensalEstimado: lucroLiquidoMensal,
      );
    });
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    Color? cardColor,
  }) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color:
          cardColor ??
          Theme.of(context).cardTheme.color, // Permite cor customizada
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ), // Consistente com o tema
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const Divider(height: 20, thickness: 1.2),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color valueColor = Colors.black87,
    bool isBold = false,
    int valueFlex = 1,
    int labelFlex = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: labelFlex,
            child: Text(
              label,
              style: TextStyle(fontSize: 15.5, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: valueFlex,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Acesso ao tema para cores, etc.

    return Scaffold(
      appBar: AppBar(title: const Text('Estimativa de Lucro de Mercado')),
      body: SingleChildScrollView(
        // Permite rolagem se o conteúdo for extenso
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              title: 'Parâmetros da Simulação',
              cardColor: Colors.teal[50], // Cor de fundo leve para este card
              children: [
                _buildInfoRow(
                  'Estado (Ref. Custo/Mercado):',
                  _estadoAtual,
                  isBold: true,
                ),
                _buildInfoRow(
                  'Metros Quadrados (Loja):',
                  '${widget.metrosQuadrados.toStringAsFixed(1)} m²',
                ),
                _buildInfoRow(
                  'Base Vendas Estimada/m²:',
                  'R\$ ${_baseVendasPorMetroQuadradoMensal.toStringAsFixed(2)} /mês',
                ),
                _buildInfoRow(
                  'Custo Fixo Estimado por m²:',
                  'R\$ ${_custoFixoPorMetroQuadradoMensal.toStringAsFixed(2)} /mês',
                ),
                _buildInfoRow(
                  'Outros Custos Fixos (Ref.):',
                  'R\$ ${widget.gastosOperacionaisFixosIniciais.toStringAsFixed(2)} /mês',
                  labelFlex: 2, // Dar mais espaço para o label
                ),
                _buildInfoRow(
                  '% Custos Oper. Variáveis:',
                  '${(_percentualGastosOperacionaisVariaveis * 100).toStringAsFixed(0)}% das Vendas Estimadas',
                  labelFlex: 2,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.casino_outlined,
                    ), // Ícone diferente para simulação
                    label: const Text('Nova Simulação de Mercado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                    ),
                    onPressed: _estimarVendasEMostrarLucro,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Nota: A simulação de mercado inclui uma pequena variação aleatória para refletir flutuações.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            if (_lucroCalculado != null) ...[
              _buildInfoCard(
                title: 'Resultado da Estimativa Detalhada',
                children: [
                  _buildInfoRow(
                    '(+) Vendas Mensais Estimadas (Receita Bruta):',
                    'R\$ ${_lucroCalculado!.vendasMensaisEstimadas.toStringAsFixed(2)}',
                    isBold: true,
                    valueColor: theme.primaryColorDark,
                  ),
                  _buildInfoRow(
                    '(-) Custo da Mercadoria Vendida (CMV):',
                    'R\$ ${_lucroCalculado!.cmvEstimado.toStringAsFixed(2)}',
                    valueColor: Colors.red,
                  ),
                  _buildInfoRow(
                    '(-) Gastos Operacionais Variáveis:',
                    'R\$ ${_lucroCalculado!.gastosOperacionaisVariaveisEstimados.toStringAsFixed(2)}',
                    valueColor: Colors.red,
                  ),
                  _buildInfoRow(
                    '(-) Custos Fixos de Estrutura (m²):',
                    'R\$ ${_lucroCalculado!.custosFixosEstruturaEstimados.toStringAsFixed(2)}',
                    valueColor: Colors.red,
                  ),
                  _buildInfoRow(
                    '(-) Outros Gastos Operacionais Fixos (Ref.):',
                    'R\$ ${_lucroCalculado!.outrosGastosOperacionaisFixosRef.toStringAsFixed(2)}',
                    valueColor: Colors.red,
                  ),
                  const Divider(thickness: 1, height: 20),
                  _buildInfoRow(
                    '(=) Lucro Líquido Mensal Estimado:',
                    'R\$ ${_lucroCalculado!.lucroLiquidoMensalEstimado.toStringAsFixed(2)}',
                    isBold: true,
                    valueColor:
                        _lucroCalculado!.lucroLiquidoMensalEstimado >= 0
                            ? Colors.green[800]!
                            : Colors.red[800]!,
                    labelFlex: 2,
                  ),
                ],
              ),
              _buildInfoCard(
                title: 'Projeções Adicionais',
                children: [
                  _buildInfoRow(
                    'Vendas Brutas Diárias (Média):',
                    'R\$ ${_lucroCalculado!.vendasDiariasEstimadas.toStringAsFixed(2)}',
                  ),
                  _buildInfoRow(
                    'Lucro Líquido Diário Estimado:',
                    'R\$ ${_lucroCalculado!.lucroDiarioEstimado.toStringAsFixed(2)}',
                    valueColor:
                        _lucroCalculado!.lucroDiarioEstimado >= 0
                            ? Colors.green[700]!
                            : Colors.red[700]!,
                    isBold: true,
                  ),
                  _buildInfoRow(
                    'Lucro Líquido Anual Estimado:',
                    'R\$ ${_lucroCalculado!.lucroAnualEstimado.toStringAsFixed(2)}',
                    valueColor:
                        _lucroCalculado!.lucroAnualEstimado >= 0
                            ? Colors.green[700]!
                            : Colors.red[700]!,
                    isBold: true,
                  ),
                ],
              ),
            ] else ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        "Calculando estimativa...",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back_ios_new),
                label: const Text('Voltar para Produtos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
