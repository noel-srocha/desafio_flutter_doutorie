import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as fdotenv;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String get baseUrl =>
      fdotenv.dotenv.env['BASE_URL'] ?? 'http://18.231.37.245:8080/api/v1';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final headers = await _headers(auth: auth);
    final uri = Uri.parse('$baseUrl$path');
    return http.post(uri, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final headers = await _headers(auth: auth);
    final uri = Uri.parse('$baseUrl$path');
    return http.put(uri, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> get(String path, {bool auth = false}) async {
    final headers = await _headers(auth: auth);
    final uri = Uri.parse('$baseUrl$path');
    return http.get(uri, headers: headers);
  }

  Future<http.Response> delete(String path, {bool auth = false}) async {
    final headers = await _headers(auth: auth);
    final uri = Uri.parse('$baseUrl$path');
    return http.delete(uri, headers: headers);
  }

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (auth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }
}
