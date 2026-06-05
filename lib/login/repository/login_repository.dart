import 'dart:convert';
import 'package:flutter2/login/models/login_model.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final http.Client httpClient;

  LoginRepository({required this.httpClient});

  // LOGIN
  Future<LoginModel> login({
    required String identifier,
    required String password,
  }) async {
    final response = await httpClient.post(
      Uri.parse('https://api.ppb.widiarrohman.my.id/api/auth/local'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'identifier': identifier, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('LoginModel gagal');
    }

    final json = jsonDecode(response.body);

    return LoginModel.fromMap(json);
  }

  // LOGOUT
  Future<void> logout() async {
    final response = await httpClient.post(
      Uri.parse('https://api.ppb.widiarrohman.my.id/api/auth/logout'),
    );

    if (response.statusCode != 200) {
      throw Exception('Logout gagal');
    }
  }
}
