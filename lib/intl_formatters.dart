// lib/intl_formatters.dart

import 'package:intl/intl.dart';

// Formatter para moeda no padrão brasileiro (R$)
final NumberFormat currencyFormat = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
);

// Formatter para data e hora no padrão brasileiro
final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

// Formatter apenas para data no padrão brasileiro
final DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

// Você pode adicionar outros formatadores aqui conforme necessário
// Por exemplo, um formatter para números decimais:
// final NumberFormat decimalFormat = NumberFormat.decimalPattern('pt_BR')
