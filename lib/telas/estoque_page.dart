// lib/screens/estoque_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pi3/modelos/produto_model.dart';
import 'package:pi3/servicos/estoque_servico.dart';
import '../widgets/app_drawer.dart'; // Importaremos o drawer que criaremos
// lib/screens/estoque_page.dart

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  _EstoquePageState createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  final EstoqueService _estoqueService = EstoqueService();
  late List<Produto> _produtos;

  @override
  void initState() {
    super.initState();
    _produtos = _estoqueService.getProdutos();
  }

  Future<void> _mostrarDialogoEdicao(Produto produto) async {
    final controller = TextEditingController(
      text: produto.estoque.toInt().toString(),
    );

    final novaQuantidade = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Atualizar Estoque"),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: "Nova quantidade"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text("Salvar"),
                onPressed: () {
                  Navigator.pop(context, controller.text);
                },
              ),
            ],
          ),
    );

    if (novaQuantidade != null && novaQuantidade.isNotEmpty) {
      final double? quantidadeNum = double.tryParse(novaQuantidade);
      if (quantidadeNum != null) {
        await _estoqueService.atualizarEstoque(produto, quantidadeNum);
        setState(() {
          // Apenas atualiza o estado para refletir a mudança
          _produtos = _estoqueService.getProdutos();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Estoque de ${produto.nome} atualizado!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), // Adiciona o menu lateral
      appBar: AppBar(title: const Text("Gerenciamento de Estoque")),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          final corEstoque =
              produto.estoque < 20
                  ? Colors.red.shade700
                  : produto.estoque < 50
                  ? Colors.orange.shade700
                  : Colors.green.shade700;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(produto.imageUrl),
              ),
              title: Text(produto.nome),
              subtitle: Text(
                "Em estoque: ${produto.estoque.toInt()}",
                style: TextStyle(
                  color: corEstoque,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () => _mostrarDialogoEdicao(produto),
              ),
            ),
          );
        },
      ),
    );
  }
}
