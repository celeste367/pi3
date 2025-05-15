import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'lucro.dart';
import 'home_page.dart';
import 'videos.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Supermercado',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomePage(),
        '/videos': (context) => const BusinessVideosPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/lucro') {
          final double totalVendas = settings.arguments as double;
          return MaterialPageRoute(
            builder: (context) => LucroPage(totalVendas: totalVendas),
          );
        }
        return null; // Route not found
      },
    );
  }
}
