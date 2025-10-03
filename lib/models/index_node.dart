class IndexNode {
  String title;
  int? page;
  List<IndexNode> subindices;

  IndexNode({required this.title, this.page, List<IndexNode>? subindices})
    : subindices = subindices ?? [];

  factory IndexNode.fromJson(Map<String, dynamic> json) {
    return IndexNode(
      title: json['titulo'] ?? '',
      page: (json['pagina'] is int)
          ? json['pagina'] as int
          : int.tryParse('${json['pagina'] ?? ''}'),
      subindices: (json['subindices'] as List? ?? [])
          .map((e) => IndexNode.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'titulo': title,
    'pagina': page ?? 0,
    'subindices': subindices.map((e) => e.toJson()).toList(),
  };

  IndexNode copy() => IndexNode(
    title: title,
    page: page,
    subindices: subindices.map((e) => e.copy()).toList(),
  );
}
