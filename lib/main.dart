import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'package:intl/date_symbol_data_local.dart'; // Adicione este import
import 'home_page.dart'; // Certifique-se que o caminho para HomePage está correto

void main() async {
  // Modifique para async
  WidgetsFlutterBinding.ensureInitialized(); // Garante que os bindings do Flutter estão prontos
  await initializeDateFormatting(
    'pt_BR',
    null,
  ); // Adicione esta linha para inicializar para pt_BR
  runApp(const AppWidget());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCE-Controle de Estoque',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // Você pode adicionar mais customizações de tema aqui
        // Exemplo de como definir alguns temas globais para consistência:
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.teal.shade700, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.teal.shade800),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal.shade700,
            side: BorderSide(color: Colors.teal.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.teal[100],
          labelStyle: TextStyle(color: Colors.teal[800]),
          iconTheme: IconThemeData(color: Colors.teal[700], size: 18),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.teal.shade700),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false, // Opcional: remove o banner de debug
    );
  }
}
