import 'package:flutter/material.dart';

class LucroSupermercado {
  final double vendasDiarias;
  final double lucroDiario;
  final double lucroMensal;
  final double lucroAnual;
  final double estoqueRestante; // Estoque restante baseado nas vendas
  final double estoqueTotal; // Novo campo para o estoque total

  LucroSupermercado({
    required this.vendasDiarias,
    required this.lucroDiario,
    required this.lucroMensal,
    required this.lucroAnual,
    required this.estoqueRestante,
    required this.estoqueTotal, // Inicialização do estoque total
  });
}

class LucroPage extends StatefulWidget {
  final double totalVendas;

  const LucroPage({
    super.key,
    required this.totalVendas,
    required double gastosOperacionais,
  });

  @override
  _LucroPageState createState() => _LucroPageState();
}

class _LucroPageState extends State<LucroPage> {
  late double totalVendas;
  String? selectedState;
  LucroSupermercado? lucro;

  final Map<String, double> custoUnitarioPorEstado = {
    'AC': 0.45,
    'AL': 0.40,
    'AP': 0.42,
    'AM': 0.50,
    'BA': 0.43,
    'CE': 0.38,
    'DF': 0.41,
    'ES': 0.39,
    'GO': 0.42,
    'MA': 0.47,
    'MT': 0.45,
    'MS': 0.44,
    'MG': 0.39,
    'PA': 0.49,
    'PB': 0.41,
    'PR': 0.43,
    'PE': 0.42,
    'PI': 0.46,
    'RJ': 0.40,
    'RN': 0.41,
    'RS': 0.44,
    'RO': 0.48,
    'RR': 0.50,
    'SC': 0.43,
    'SP': 0.42,
    'SE': 0.41,
    'TO': 0.45,
  };

  @override
  void initState() {
    super.initState();
    totalVendas = widget.totalVendas;
  }

  LucroSupermercado calcularLucro(String estado, double vendasTotais) {
    double custoMedio =
        custoUnitarioPorEstado[estado] ??
        0.42; // Valor padrão para custoUnitario
    double vendasDiarias = vendasTotais / 30;
    double lucroDiario = vendasDiarias * (1 - custoMedio);
    double lucroMensal = lucroDiario * 30;
    double lucroAnual = lucroMensal * 12;

    // Definindo o estoque total e calculando o estoque restante
    double estoqueTotal = 10000; // Estoque total fixo (pode ser alterado)
    double estoqueRestante =
        estoqueTotal -
        vendasTotais; // Estoque restante baseado nas vendas totais

    return LucroSupermercado(
      vendasDiarias: vendasDiarias,
      lucroDiario: lucroDiario,
      lucroMensal: lucroMensal,
      lucroAnual: lucroAnual,
      estoqueRestante: estoqueRestante,
      estoqueTotal: estoqueTotal, // Passando o valor do estoque total
    );
  }

  void calcular() {
    if (selectedState != null) {
      setState(() {
        lucro = calcularLucro(selectedState!, totalVendas);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecione um estado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estimativa de Lucro'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Vendas Mensais: R\$ ${totalVendas.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: totalVendas,
              min: 1.00,
              max: 50000.00,
              divisions: 100,
              label: 'R\$ ${totalVendas.toStringAsFixed(0)}',
              onChanged: (value) {
                setState(() {
                  totalVendas = value;
                });
              },
            ),
            DropdownButton<String>(
              hint: Text('Selecione um estado'),
              value: selectedState,
              isExpanded: true,
              onChanged: (String? newState) {
                setState(() {
                  selectedState = newState;
                });
              },
              items:
                  custoUnitarioPorEstado.keys.map((String estado) {
                    return DropdownMenuItem<String>(
                      value: estado,
                      child: Text(estado),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcular,
              child: Text('Calcular Lucro'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            if (lucro != null)
              DataTable(
                columnSpacing: 12,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Tipo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Valor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Estado')),
                      DataCell(Text(selectedState ?? 'Não selecionado')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Vendas Diárias')),
                      DataCell(
                        Text('R\$ ${lucro!.vendasDiarias.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Lucro Diário')),
                      DataCell(
                        Text('R\$ ${lucro!.lucroDiario.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Lucro Mensal')),
                      DataCell(
                        Text('R\$ ${lucro!.lucroMensal.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Lucro Anual')),
                      DataCell(
                        Text('R\$ ${lucro!.lucroAnual.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Estoque Total')),
                      DataCell(
                        Text('R\$ ${lucro!.estoqueTotal.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Estoque Restante')),
                      DataCell(
                        Text(
                          'R\$ ${lucro!.estoqueRestante.toStringAsFixed(2)}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Voltar para Início'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
