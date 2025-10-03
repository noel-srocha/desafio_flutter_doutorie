import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  AuthCubit(this._repo) : super(const AuthState.unknown());

  Future<void> checkAuth() async {
    final has = await _repo.hasToken();
    if (has) {
      emit(const AuthState.authenticated());
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String senha) async {
    emit(const AuthState.loading());
    try {
      await _repo.login(email: email, senha: senha);
      emit(const AuthState.authenticated());
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    emit(const AuthState.unauthenticated());
  }
}
