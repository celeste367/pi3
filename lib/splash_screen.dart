import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Aguarda um tempo para a splash screen
    await Future.delayed(const Duration(seconds: 4)); // Reduzi um pouco o tempo

    // Verifica se o widget ainda está montado antes de navegar
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pode usar a cor primária do tema ou uma cor específica
    // final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.teal[50], // Uma cor suave do tema
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/48459dc8-c0a3-4c14-99fd-6fee1777f4ed/QFesrhW7Jc.json', // Mantenha seu link Lottie
              width: 250,
              height: 250,
              errorBuilder: (context, error, stackTrace) {
                // Tratamento de erro para Lottie
                return Icon(Icons.store, size: 150, color: Colors.teal[300]);
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Gestor de Supermercado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            const SizedBox(height: 40),
            // Botão "Ir para Início" removido pois a navegação é automática
            // e a splash screen é geralmente apenas para branding/carregamento inicial.
            // Se precisar de um botão de skip:
            /*
            ElevatedButton.icon(
              onPressed: () {
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              icon: Icon(Icons.skip_next),
              label: Text('Pular'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[300]),
            ),
            */
          ],
        ),
      ),
    );
  }
}
