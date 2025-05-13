import 'package:flutter/material.dart';
import 'package:pi3/imagens.dart'; // HomePage
import 'package:pi3/preco.dart'; // EnergyMonitorPage
import 'package:pi3/cosumo.dart';
import 'package:pi3/videos.dart'; // SplashScreen

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Energia Comunitário',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Rota inicial
      routes: {
        '/': (context) => const SplashScreen(), // Splash Screen
        '/home': (context) => HomePage(), // Página principal
        '/videos': (context) => const EnergySavingVideosPage(),
        '/energy':
            (context) => EnergyMonitorPage(
              currentConsumption: 150,
            ), // Página de monitoramento
      },
    );
  }
}
