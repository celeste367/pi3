// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'widgets/app_widget.dart';

void main() async {
  // Garante que os bindings do Flutter estão prontos antes de rodar o app
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a formatação de datas e moedas para o padrão pt_BR
  await initializeDateFormatting('pt_BR', null);

  runApp(const AppWidget());
}
