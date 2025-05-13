import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar automaticamente após 3 segundos
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void irParaInicio() {
    // Navegar manualmente para a HomePage
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/92636d3c-fd69-42cc-8f39-6a779b776a4d/aCciE5Vl3G.json',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 5),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: irParaInicio,
              icon: Icon(Icons.home),
              label: Text('Ir para Início'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.lightBlue,
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
