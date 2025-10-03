import 'index_node.dart';

class Book {
  final int? id;
  String titulo;
  List<IndexNode> indices;

  Book({this.id, required this.titulo, List<IndexNode>? indices})
    : indices = indices ?? [];

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse('${json['id'] ?? ''}'),
      titulo: json['titulo'] ?? '',
      indices: (json['indices'] as List? ?? [])
          .map((e) => IndexNode.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'indices': indices.map((e) => e.toJson()).toList(),
  };
}
