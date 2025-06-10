// lib/screens/menu_page.dart

import 'package:flutter/material.dart';
import 'package:pi3/servicos/servico_autentificac%C3%A3o.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Busca o usuário logado no serviço de autenticação
    final usuario = AuthService.usuarioLogado;

    // Se não houver usuário logado, redireciona para a tela de login
    if (usuario == null) {
      // Usando um post-frame callback para navegar após o build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              AuthService().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 1.2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          // Botão visível para todos
          if (usuario.nivel == NivelAcesso.caixa ||
              usuario.nivel == NivelAcesso.gerente ||
              usuario.nivel == NivelAcesso.admin)
            _MenuButton(
              label: 'Frente de Caixa',
              icon: Icons.point_of_sale,
              onTap: () => Navigator.of(context).pushNamed('/home'),
            ),

          // Botão visível para Gerente e Admin
          if (usuario.nivel == NivelAcesso.gerente ||
              usuario.nivel == NivelAcesso.admin)
            _MenuButton(
              label: 'Histórico de Vendas',
              icon: Icons.history,
              onTap: () => Navigator.of(context).pushNamed('/vendas'),
            ),

          // Botão visível para Gerente e Admin
          if (usuario.nivel == NivelAcesso.gerente ||
              usuario.nivel == NivelAcesso.admin)
            _MenuButton(
              label: 'Gestão de Estoque',
              icon: Icons.inventory_2,
              onTap: () {
                // Futuramente, navegar para uma tela de gestão de estoque
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tela de Gestão de Estoque em desenvolvimento.',
                    ),
                  ),
                );
              },
            ),

          // Botão visível apenas para Admin
          if (usuario.nivel == NivelAcesso.admin)
            _MenuButton(
              label: 'Relatórios',
              icon: Icons.bar_chart,
              onTap: () {
                // Futuramente, navegar para a tela de relatórios
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tela de Relatórios em desenvolvimento.'),
                  ),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Logado como: ${usuario.nome}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
