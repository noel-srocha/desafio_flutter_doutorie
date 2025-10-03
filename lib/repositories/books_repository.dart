import 'dart:convert';

import '../core/api_client.dart';
import '../models/book.dart';

class BooksRepository {
  final ApiClient _client;
  BooksRepository(this._client);

  Future<List<Book>> fetchBooks() async {
    final response = await _client.get('/livros', auth: true);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (data is Map && data['content'] is List) {
        return (data['content'] as List)
            .map((e) => Book.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    }
    throw Exception('Erro ao buscar livros: ${response.statusCode}');
  }

  Future<Book> getBook(int id) async {
    final response = await _client.get('/livros/$id', auth: true);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Book.fromJson(data);
    }
    throw Exception('Erro ao carregar livro: ${response.statusCode}');
  }

  Future<void> createBook(Book book) async {
    final response = await _client.post('/livros', book.toJson(), auth: true);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ao criar livro: ${response.statusCode}');
    }
  }

  Future<void> updateBook(int id, Book book) async {
    final response = await _client.put(
      '/livros/$id',
      book.toJson(),
      auth: true,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ao atualizar livro: ${response.statusCode}');
    }
  }

  Future<void> deleteBook(int id) async {
    final response = await _client.delete('/livros/$id', auth: true);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ao excluir livro: ${response.statusCode}');
    }
  }
}
