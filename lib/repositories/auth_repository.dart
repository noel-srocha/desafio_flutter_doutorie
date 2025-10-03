import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';

class AuthRepository {
  final ApiClient _client;
  AuthRepository(this._client);

  Future<String> login({required String email, required String senha}) async {
    final response = await _client.post('/auth/login', {
      'email': email,
      'senha': senha,
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = (data['token'] ?? data['accessToken'] ?? '') as String;
      if (token.isEmpty) {
        throw Exception('Token não encontrado na resposta.');
      }
      // Persist token
      await _client.saveToken(token);

      // Try to extract and persist user name for AppBar action display
      try {
        String? name;
        // direct keys
        if (data['nome'] is String) name = data['nome'] as String;
        if (name == null && data['name'] is String)
          name = data['name'] as String;
        // nested under 'usuario' or 'user'
        if (name == null && data['usuario'] is Map) {
          final u = Map<String, dynamic>.from(data['usuario'] as Map);
          name = (u['nome'] ?? u['name']) as String?;
        }
        if (name == null && data['user'] is Map) {
          final u = Map<String, dynamic>.from(data['user'] as Map);
          name = (u['nome'] ?? u['name']) as String?;
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user_name',
          (name?.trim().isNotEmpty ?? false) ? name!.trim() : 'Usuário',
        );
      } catch (_) {
        // ignore errors silently
      }

      return token;
    }
    throw Exception('Falha no login: ${response.statusCode}');
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_name');
    } catch (_) {}
  }

  Future<bool> hasToken() async {
    final t = await _client.getToken();
    return t != null && t.isNotEmpty;
  }
}
