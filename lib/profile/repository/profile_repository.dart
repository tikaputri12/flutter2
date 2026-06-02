import 'dart:convert';

import 'package:flutter2/profile/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final http.Client httpClient;

  ProfileRepository({
    required this.httpClient,
  });

  // fungsi get profile
  Future<ProfileModel> getprofile({
    required String token,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(
      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/users/me',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(
        "Response get profile: ${response.body}",
      );

      final json = jsonDecode(
        response.body,
      );

      return ProfileModel.fromMap(json);
    } else {
      throw Exception(
        'Failed to load data',
      );
    }
  }

  // update profile
  Future<ProfileModel> updateProfile({
    required String username,
    required String email,
  }) async {

    // diambil dari local storage
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token');

    var headers = {
      'Authorization': 'Bearer $token',
      'content-type': 'application/json',
    };

    var response = await http.put(
      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/users/update',
      ),

      headers: headers,

      body: jsonEncode({
        'username': username,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);

      final json = jsonDecode(
        response.body,
      );

      return ProfileModel.fromMap(json);
    } else {
      throw Exception(
        'Failed to load data',
      );
    }
  }
}