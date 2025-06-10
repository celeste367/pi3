// lib/models/venda_model.dart

import 'package:pi3/servicos/servico_autentificac%C3%A3o.dart'; // Para associar a venda a um usuário

class Venda {
  final String id;
  final DateTime data;
  final List<Map<String, dynamic>> itensVendidos;
  final double totalVenda;
  final double totalImpostos;
  final Usuario? usuario; // Usuário que realizou a venda

  Venda({
    required this.id,
    required this.data,
    required this.itensVendidos,
    required this.totalVenda,
    required this.totalImpostos,
    this.usuario,
  });
}
