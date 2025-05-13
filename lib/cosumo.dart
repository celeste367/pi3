import 'package:flutter/material.dart';
import 'package:pi3/preco.dart'; // Certifique-se de que a página EnergyMonitorPage está importada corretamente
import 'package:pi3/videos.dart'; // Certifique-se de que a página EnergySavingVideosPage está importada corretamente

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double energyConsumption = 150.0; // Consumo inicial em kWh
  bool isLampOn = true; // Estado inicial da lâmpada (acesa)
  bool showSuggestionsList = false; // Controla a visibilidade das sugestões

  // Função para atualizar o consumo de energia
  void updateConsumption(double newConsumption) {
    setState(() {
      energyConsumption = newConsumption;

      // Se o consumo for acima de 500 kWh, a lâmpada se apaga
      if (energyConsumption > 500) {
        isLampOn = false;
      } else {
        isLampOn = true;
      }
    });
  }

  // Função para sugerir ações de redução de consumo
  List<String> getEnergySavingSuggestions() {
    if (energyConsumption <= 200) {
      return [
        "Continue assim! Seu consumo está ótimo.",
        "Tente manter o consumo abaixo de 200 kWh para reduzir ainda mais.",
      ];
    } else if (energyConsumption <= 500) {
      return [
        "Desligue aparelhos em standby.",
        "Troque lâmpadas incandescentes por lâmpadas LED.",
        "Tente reduzir o uso de ar-condicionado.",
      ];
    } else {
      return [
        "O consumo está muito alto. Aqui estão algumas sugestões:",
        "Desligue aparelhos em standby.",
        "Evite o uso excessivo de ar-condicionado.",
        "Troque lâmpadas incandescentes por lâmpadas LED.",
        "Verifique vazamentos de energia em sua casa.",
      ];
    }
  }

  // Função para navegar para a página de sugestões (caso necessário)
  void showSuggestions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                EnergyMonitorPage(currentConsumption: energyConsumption),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Energia Comunitário'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Consumo Atual: ${energyConsumption.toStringAsFixed(2)} kWh',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Lâmpada (ícone)
            Icon(
              isLampOn ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: isLampOn ? Colors.yellow : Colors.grey,
            ),
            const SizedBox(height: 20),
            // Slider para ajustar o consumo
            Slider(
              min: 0,
              max: 1000,
              divisions: 30,
              label: energyConsumption.toStringAsFixed(2),
              value: energyConsumption,
              onChanged: (value) {
                updateConsumption(value);
              },
            ),
            const SizedBox(height: 20),
            // Botão para exibir as sugestões de redução
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showSuggestionsList = !showSuggestionsList;
                });
              },
              child: Text(
                showSuggestionsList
                    ? 'Ocultar Sugestões de Redução'
                    : 'Receber Sugestões de Redução',
              ),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            // Exibir as sugestões de redução se showSuggestionsList for true
            if (showSuggestionsList)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    getEnergySavingSuggestions().map((suggestion) {
                      return Text(
                        suggestion,
                        style: const TextStyle(fontSize: 16),
                      );
                    }).toList(),
              ),
            const SizedBox(height: 20),
            // Botão para navegar para a página de calcular preço de energia
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/energy',
                  arguments:
                      energyConsumption, // Passando o consumo para a próxima tela
                );
              },
              child: const Text('Calcular Preço de Energia'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            // Botão para navegar para a página de vídeos de economia de energia
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnergySavingVideosPage(),
                  ),
                );
              },
              child: const Text('Ver Vídeos de Economia de Energia'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
