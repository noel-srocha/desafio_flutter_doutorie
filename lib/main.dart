import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as fdotenv;

import 'bloc/auth_cubit.dart';
import 'bloc/books_cubit.dart';
import 'core/api_client.dart';
import 'repositories/auth_repository.dart';
import 'repositories/books_repository.dart';
import 'ui/book_detail_page.dart';
import 'ui/book_form_page.dart';
import 'ui/books_list_page.dart';
import 'ui/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fdotenv.dotenv.load(fileName: ".env");
  final api = ApiClient();
  final authRepo = AuthRepository(api);
  final booksRepo = BooksRepository(api);
  runApp(MyApp(authRepo: authRepo, booksRepo: booksRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepo;
  final BooksRepository booksRepo;
  const MyApp({super.key, required this.authRepo, required this.booksRepo});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: booksRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(authRepo)..checkAuth()),
          BlocProvider(create: (_) => BooksCubit(booksRepo)),
        ],
        child: MaterialApp(
          title: 'Desafio Flutter Doutor-IE',

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          routes: {
            '/': (_) => const _Root(),
            '/livros': (_) => const BooksListPage(),
            '/livros/detalhe': (_) => const BookDetailPage(),
            '/livros/form': (_) => const BookFormPage(),
          },
        ),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.unknownState || state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.authenticated) {
          return const BooksListPage();
        }
        return const LoginPage();
      },
    );
  }
}
