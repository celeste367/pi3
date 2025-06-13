// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:pi3/telas/home_page.dart';
import 'package:pi3/telas/estoque_page.dart';
import 'package:pi3/telas/relatorio_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Text(
              'Gestor Supermercado',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('Frente de Caixa'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              // Para evitar empilhar telas, usamos pushReplacementNamed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Gerenciar Estoque'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EstoquePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Relatórios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RelatoriosPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
