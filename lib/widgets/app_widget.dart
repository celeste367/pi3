// lib/widgets/app_widget.dart

import 'package:flutter/material.dart';
import 'package:pi3/telas/splash_screen.dart';
import 'package:pi3/telas/login_page.dart';
import 'package:pi3/telas/menu_page.dart';
import 'package:pi3/telas/home_page.dart';
import 'package:pi3/telas/vendas_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCE - Supermercado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Tema unificado para os componentes da UI
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4.0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        cardTheme: CardTheme(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.teal[800]),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      // Definição das rotas nomeadas da aplicação
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/menu': (context) => const MenuPage(),
        '/home': (context) => const HomePage(),
        '/vendas': (context) => const VendasPage(),
        // As páginas de Lucro e NotaFiscal serão chamadas via MaterialPageRoute
        // pois precisam receber argumentos complexos.
      },
    );
  }
}
