import 'package:flutter/material.dart';

class EnergyMonitorPage extends StatefulWidget {
  final double currentConsumption;

  // Recebe o consumo atual da página inicial
  EnergyMonitorPage({required this.currentConsumption});

  @override
  _EnergyMonitorPageState createState() => _EnergyMonitorPageState();
}

class _EnergyMonitorPageState extends State<EnergyMonitorPage> {
  late double energyConsumption;
  String? selectedState;
  GastoEnergia? gasto;

  // Exemplo de dados de preços de energia para todos os estados
  final Map<String, double> energyPrices = {
    'AC': 0.65,
    'AL': 0.58,
    'AP': 0.60,
    'AM': 0.70,
    'BA': 0.59,
    'CE': 0.52,
    'DF': 0.55,
    'ES': 0.58,
    'GO': 0.55,
    'MA': 0.60,
    'MT': 0.65,
    'MS': 0.63,
    'MG': 0.53,
    'PA': 0.68,
    'PB': 0.57,
    'PR': 0.60,
    'PE': 0.58,
    'PI': 0.62,
    'RJ': 0.55,
    'RN': 0.57,
    'RS': 0.60,
    'RO': 0.68,
    'RR': 0.72,
    'SC': 0.60,
    'SP': 0.60,
    'SE': 0.58,
    'TO': 0.65,
  };

  @override
  void initState() {
    super.initState();
    energyConsumption =
        widget.currentConsumption; // Inicializa com o valor vindo da HomePage
  }

  // Função para calcular o gasto de energia
  GastoEnergia calcularGastoEnergia(String state, double consumption) {
    double pricePerKWh = energyPrices[state] ?? 0.60;
    double dailyConsumption = consumption / 30;
    double dailyCost = dailyConsumption * pricePerKWh;
    double monthlyCost = dailyCost * 30;
    double annualCost = monthlyCost * 12;

    return GastoEnergia(
      consumoDiario: dailyConsumption,
      custoDiario: dailyCost,
      custoMensal: monthlyCost,
      custoAnual: annualCost,
    );
  }

  // Função chamada ao clicar no botão "Calcular Custos"
  void calcularGasto() {
    if (selectedState != null) {
      setState(() {
        gasto = calcularGastoEnergia(selectedState!, energyConsumption);
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
        title: Text('Monitor de Energia Comunitário'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Consumo Mensal: ${energyConsumption.toStringAsFixed(2)} kWh',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: energyConsumption,
              min: 0,
              max: 1000,
              divisions: 100,
              label: '${energyConsumption.toStringAsFixed(2)} kWh',
              onChanged: (value) {
                setState(() {
                  energyConsumption = value;
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
                  energyPrices.keys.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularGasto,
              child: Text('Calcular Custos'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            // Exibe a tabela apenas após o cálculo do gasto
            if (gasto != null)
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
                      DataCell(Text(selectedState!)),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Consumo Diário')),
                      DataCell(
                        Text('${gasto!.consumoDiario.toStringAsFixed(2)} kWh'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Custo Diário')),
                      DataCell(
                        Text('R\$ ${gasto!.custoDiario.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Custo Mensal')),
                      DataCell(
                        Text('R\$ ${gasto!.custoMensal.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Custo Anual')),
                      DataCell(
                        Text('R\$ ${gasto!.custoAnual.toStringAsFixed(2)}'),
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
              child: Text('Ir para Página Inicial'),
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

class GastoEnergia {
  final double consumoDiario;
  final double custoDiario;
  final double custoMensal;
  final double custoAnual;

  GastoEnergia({
    required this.consumoDiario,
    required this.custoDiario,
    required this.custoMensal,
    required this.custoAnual,
  });
}
