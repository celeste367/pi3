import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Certifique-se que o caminho para HomePage está correto

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3), // Duração da tela de splash
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Você pode personalizar esta tela como quiser
    return Scaffold(
      backgroundColor: Colors.teal, // Cor de fundo da splash
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Adicione seu logo aqui se tiver um
            Icon(
              Icons.storefront_outlined, // Ícone de exemplo
              size: 100.0,
              color: Colors.white,
            ),
            const SizedBox(height: 24.0),
            Text(
              'Gestor de Produtos', // Nome do seu app
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
