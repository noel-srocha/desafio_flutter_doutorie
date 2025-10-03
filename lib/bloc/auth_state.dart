part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool loading;
  final bool authenticated;
  final String? error;
  final bool unknownState;

  const AuthState({
    required this.loading,
    required this.authenticated,
    required this.unknownState,
    this.error,
  });

  const AuthState.unknown()
    : loading = false,
      authenticated = false,
      unknownState = true,
      error = null;

  const AuthState.loading()
    : loading = true,
      authenticated = false,
      unknownState = false,
      error = null;

  const AuthState.authenticated()
    : loading = false,
      authenticated = true,
      unknownState = false,
      error = null;

  const AuthState.unauthenticated()
    : loading = false,
      authenticated = false,
      unknownState = false,
      error = null;

  const AuthState.failure(this.error)
    : loading = false,
      authenticated = false,
      unknownState = false;

  @override
  List<Object?> get props => [loading, authenticated, error, unknownState];
}
