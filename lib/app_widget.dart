import 'package:flutter/material.dart';
import 'splash_screen.dart';

import 'home_page.dart';
// import 'videos.dart'; // REMOVIDO

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Supermercado',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4.0,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.0,
            ), // Bordas mais arredondadas
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ), // Aumentar padding vertical
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
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
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
          labelStyle: TextStyle(
            color: Colors.teal[700],
          ), // Cor do label mais escura
          filled: true, // Adicionar preenchimento
          fillColor: Colors.white, // Cor de preenchimento
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 12.0,
          ), // Ajustar padding interno
        ),
        chipTheme: ChipThemeData(
          // Tema para Chips
          backgroundColor: Colors.teal[50],
          labelStyle: TextStyle(
            color: Colors.teal[800],
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: Colors.teal[700], size: 18),
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 4.0,
          ), // Padding do Chip
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), // Bordas do Chip
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomePage(),
        // '/videos': (context) => const BusinessVideosPage(), // ROTA REMOVIDA
      },
    );
  }
}
