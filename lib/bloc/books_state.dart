part of 'books_cubit.dart';

class BooksState extends Equatable {
  final List<Book> books;
  final bool loading;
  final bool saving;
  final int? workingId; // id being deleted
  final String? error;

  const BooksState({
    required this.books,
    required this.loading,
    required this.saving,
    this.workingId,
    this.error,
  });

  const BooksState.initial()
    : books = const [],
      loading = false,
      saving = false,
      workingId = null,
      error = null;

  BooksState copyWith({
    List<Book>? books,
    bool? loading,
    bool? saving,
    int? workingId,
    String? error,
  }) => BooksState(
    books: books ?? this.books,
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    workingId: workingId,
    error: error,
  );

  @override
  List<Object?> get props => [books, loading, saving, workingId, error];
}
