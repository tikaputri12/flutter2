import 'dart:convert';

import 'package:flutter2/register/models/register_models.dart';
import 'package:http/http.dart' as http;

class RegisterRepository {
  final http.Client httpClient;

  RegisterRepository({
    required this.httpClient,
  });

  // REGISTER
  Future<RegisterModel> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await httpClient.post(
      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/auth/local/register',
      ),

      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },

      body: {
        'email': email,
        'username': username,
        'password': password,
      },
    );

    print(response.body);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        'Error: ${response.statusCode} - ${responseBody['message']}',
      );
    }

    final json = jsonDecode(response.body);

    return RegisterModel.fromMap(json);
  }
}