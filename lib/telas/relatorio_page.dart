// lib/screens/relatorios_page.dart

import 'package:flutter/material.dart';
import 'package:pi3/telas/relatorio_detalhe_page.dart';
import '../widgets/app_drawer.dart';
// lib/screens/relatorios_page.dart

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: const Text("Central de Relatórios")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCardRelatorio(
            context,
            icon: Icons.point_of_sale,
            title: "Relatório de Vendas",
            subtitle: "Visualize o desempenho geral das vendas.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => RelatorioDetalhePage(
                        titulo: "Desempenho de Vendas",
                        tipoRelatorio: TipoRelatorio.vendas,
                      ),
                ),
              );
            },
          ),
          _buildCardRelatorio(
            context,
            icon: Icons.inventory,
            title: "Relatório de Estoque Baixo",
            subtitle: "Liste produtos que precisam de reposição.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => RelatorioDetalhePage(
                        titulo: "Estoque Baixo (< 50 itens)",
                        tipoRelatorio: TipoRelatorio.estoqueBaixo,
                      ),
                ),
              );
            },
          ),
          // Adicione outros cards de relatório aqui no futuro
        ],
      ),
    );
  }

  Widget _buildCardRelatorio(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
