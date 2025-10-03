import 'package:desafio_flutter_doutorie/ui/widgets/user_menu_action.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/index_node.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.titulo),
        actions: const [UserMenuAction()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          final maxWidth = isWide ? 900.0 : double.infinity;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _IndicesList(nodes: book.indices),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _IndicesList extends StatelessWidget {
  final List<IndexNode> nodes;
  const _IndicesList({required this.nodes});

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const Text('Sem índices.');
    }
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) => _NodeTile(node: nodes[index]),
    );
  }
}

class _NodeTile extends StatelessWidget {
  final IndexNode node;
  const _NodeTile({required this.node});

  @override
  Widget build(BuildContext context) {
    if (node.subindices.isEmpty) {
      return ListTile(
        title: Text(node.title),
        trailing: node.page != null ? Text('p. ${node.page}') : null,
      );
    }
    return ExpansionTile(
      title: Text(node.title),
      trailing: node.page != null ? Text('p. ${node.page}') : null,
      children: node.subindices.map((e) => _NodeTile(node: e)).toList(),
    );
  }
}
