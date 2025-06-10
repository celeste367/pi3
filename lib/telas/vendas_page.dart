// lib/screens/vendas_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi3/modelos/venda_model.dart';
import 'package:pi3/servicos/vendas_service.dart';
import 'nota_fiscal_page.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  _VendasPageState createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  late Future<List<Venda>> _historicoVendas;
  final VendasService _vendasService = VendasService();

  @override
  void initState() {
    super.initState();
    _historicoVendas = _vendasService.getHistoricoDeVendas();
  }

  @override
  Widget build(BuildContext context) {
    final formatadorMoeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final formatadorData = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Vendas')),
      body: FutureBuilder<List<Venda>>(
        future: _historicoVendas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar vendas: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma venda registrada.'));
          }

          final vendas = snapshot.data!;
          return ListView.builder(
            itemCount: vendas.length,
            itemBuilder: (context, index) {
              final venda = vendas[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.teal),
                  title: Text(
                    'Venda #${venda.id.substring(venda.id.length - 4)}',
                  ),
                  subtitle: Text(formatadorData.format(venda.data)),
                  trailing: Text(
                    formatadorMoeda.format(venda.totalVenda),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotaFiscalPage(venda: venda),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
