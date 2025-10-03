import 'package:desafio_flutter_doutorie/models/book.dart';
import 'package:desafio_flutter_doutorie/models/index_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Book toJson includes indices and subindices', () {
    final book = Book(
      titulo: 'Livro 01',
      indices: [
        IndexNode(
          title: 'indice 1',
          page: 2,
          subindices: [
            IndexNode(
              title: 'sub 1.1',
              page: 3,
              subindices: [IndexNode(title: 'sub 1.1.1', page: 4)],
            ),
          ],
        ),
      ],
    );

    final json = book.toJson();

    expect(json['titulo'], 'Livro 01');
    expect((json['indices'] as List).length, 1);
    final first = json['indices'][0] as Map<String, dynamic>;
    expect(first['titulo'], 'indice 1');
    expect(first['pagina'], 2);
    expect((first['subindices'] as List).length, 1);
  });
}
