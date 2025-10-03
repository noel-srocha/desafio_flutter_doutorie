import 'package:desafio_flutter_doutorie/ui/widgets/user_menu_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/books_cubit.dart';
import '../models/book.dart';
import '../models/index_node.dart';

class BookFormPage extends StatefulWidget {
  const BookFormPage({super.key});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  int? _id;
  final List<IndexNode> _indices = [];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _loadFromArgs(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Book && _indices.isEmpty && _id == null) {
      _id = args.id;
      _titleCtrl.text = args.titulo;
      _indices.addAll(args.indices.map((e) => e.copy()));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadFromArgs(context);
    final isEdit = _id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Livro' : 'Cadastrar Livro'),
        actions: const [UserMenuAction()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final maxWidth = isWide ? 900.0 : double.infinity;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(labelText: 'Título*'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'O título é obrigatório'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Índices',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _indices.add(IndexNode(title: '', page: 1));
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar índice'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _indices.isEmpty
                                ? const Center(
                                    child: Text('Nenhum índice adicionado.'),
                                  )
                                : ListView.builder(
                                    itemCount: _indices.length,
                                    itemBuilder: (context, i) => IndexEditor(
                                      key: ValueKey('root_$i'),
                                      node: _indices[i],
                                      onRemove: () =>
                                          setState(() => _indices.removeAt(i)),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocConsumer<BooksCubit, BooksState>(
                        listener: (context, state) {
                          if (!state.saving && state.error == null) {
                            Navigator.of(context).pop();
                          } else if (state.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: state.saving
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        final book = Book(
                                          id: _id,
                                          titulo: _titleCtrl.text.trim(),
                                          indices: _indices,
                                        );
                                        context
                                            .read<BooksCubit>()
                                            .createOrUpdate(book);
                                      }
                                    },
                              icon: const Icon(Icons.save),
                              label: Text(
                                state.saving ? 'Salvando...' : 'Salvar',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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

class IndexEditor extends StatefulWidget {
  final IndexNode node;
  final VoidCallback onRemove;
  final ValueChanged<IndexNode> onChanged;
  const IndexEditor({
    super.key,
    required this.node,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<IndexEditor> createState() => _IndexEditorState();
}

class _IndexEditorState extends State<IndexEditor> {
  late TextEditingController _titleCtrl;
  late TextEditingController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.node.title);
    _pageCtrl = TextEditingController(text: (widget.node.page ?? 1).toString());
  }

  @override
  void didUpdateWidget(covariant IndexEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node != widget.node) {
      _titleCtrl.text = widget.node.title;
      _pageCtrl.text = (widget.node.page ?? 1).toString();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _commit() {
    widget.node.title = _titleCtrl.text;
    widget.node.page = int.tryParse(_pageCtrl.text) ?? 1;
    widget.onChanged(widget.node);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título do índice',
                    ),
                    onChanged: (_) => _commit(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    controller: _pageCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Página'),
                    onChanged: (_) => _commit(),
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  tooltip: 'Remover',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    widget.node.subindices.add(IndexNode(title: '', page: 1));
                    _commit();
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar subíndice'),
              ),
            ),
            if (widget.node.subindices.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  children: [
                    for (int i = 0; i < widget.node.subindices.length; i++)
                      IndexEditor(
                        key: ValueKey('${hashCode}_$i'),
                        node: widget.node.subindices[i],
                        onRemove: () {
                          setState(() {
                            widget.node.subindices.removeAt(i);
                            _commit();
                          });
                        },
                        onChanged: (_) => _commit(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
