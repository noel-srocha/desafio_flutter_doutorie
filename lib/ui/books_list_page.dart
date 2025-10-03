import 'package:desafio_flutter_doutorie/ui/widgets/user_menu_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/books_cubit.dart';
import '../models/book.dart';

class BooksListPage extends StatefulWidget {
  const BooksListPage({super.key});

  @override
  State<BooksListPage> createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage> {
  @override
  void initState() {
    super.initState();
    context.read<BooksCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
        actions: const [UserMenuAction()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final maxWidth = isWide ? 1000.0 : double.infinity;
          final padding = EdgeInsets.symmetric(
            horizontal: isWide ? 32 : 12,
            vertical: 12,
          );
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: padding,
                child: BlocBuilder<BooksCubit, BooksState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.error != null) {
                      return Center(child: Text(state.error!));
                    }
                    final books = state.books;
                    if (books.isEmpty) {
                      return const Center(
                        child: Text('Nenhum livro cadastrado.'),
                      );
                    }
                    return Card(
                      elevation: 2,
                      child: ListView.separated(
                        itemBuilder: (_, i) => _BookTile(book: books[i]),
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemCount: books.length,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/livros/form');
        },
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar'),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  final Book book;
  const _BookTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final workingId = context.select((BooksCubit c) => c.state.workingId);
    final isWorking = workingId == book.id;
    return ListTile(
      title: Text(book.titulo),
      trailing: Wrap(
        spacing: 8,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility_outlined),
            tooltip: 'Visualizar',
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed('/livros/detalhe', arguments: book);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () {
              Navigator.of(context).pushNamed('/livros/form', arguments: book);
            },
          ),
          IconButton(
            icon: isWorking
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete),
            tooltip: 'Excluir',
            onPressed: isWorking
                ? null
                : () async {
                    final confirmed =
                        await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirmação'),
                            content: Text(
                              'Deseja realmente excluir o livro ${book.titulo}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Não'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Sim'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                    if (confirmed && book.id != null) {
                      // ignore: use_build_context_synchronously
                      context.read<BooksCubit>().delete(book.id!);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
