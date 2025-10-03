import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/book.dart';
import '../repositories/books_repository.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BooksRepository _repo;
  BooksCubit(this._repo) : super(const BooksState.initial());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final books = await _repo.fetchBooks();
      emit(state.copyWith(loading: false, books: books));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> delete(int id) async {
    emit(state.copyWith(workingId: id));
    try {
      await _repo.deleteBook(id);
      final updated = List<Book>.from(state.books)
        ..removeWhere((b) => b.id == id);
      emit(state.copyWith(books: updated, workingId: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), workingId: null));
    }
  }

  Future<void> createOrUpdate(Book book) async {
    emit(state.copyWith(saving: true, error: null));
    try {
      if (book.id == null) {
        await _repo.createBook(book);
      } else {
        await _repo.updateBook(book.id!, book);
      }

      await load();

      emit(state.copyWith(saving: false, error: null));
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }
}
