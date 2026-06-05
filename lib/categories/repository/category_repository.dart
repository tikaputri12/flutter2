import 'dart:convert';
import 'package:flutter2/categories/models/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryRepository {
  final http.Client httpClient;

  CategoryRepository({required this.httpClient});

  final String baseUrl = 'https://api.ppb.widiarrohman.my.id/api/categories';

  // Header helper agar tidak duplikasi kode
  Map<String, String> _headers(String token) => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

  // GET
  Future<List<CategoryModel>> getCategories(String token) async {
    final response = await httpClient.get(
      Uri.parse(baseUrl),
      headers: _headers(token),
    );
 
    if (response.statusCode != 200) {
      throw Exception("Error ${response.statusCode}");
    }

    final decoded = jsonDecode(response.body);
    final List data = decoded['data'];
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  // CREATE
  Future<void> createCategory(CategoryModel category, String token) async {
    final response = await httpClient.post(
      Uri.parse(baseUrl),
      headers: _headers(token),
      body: jsonEncode({"data": category.toJson()}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Gagal create category");
    }
  }

  // UPDATE
  Future<void> updateCategory(int id, CategoryModel category, String token) async {
    final response = await httpClient.put(
      Uri.parse("$baseUrl/$id"),
      headers: _headers(token),
      body: jsonEncode({"data": category.toJson()}),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update category");
    }
  }

  // DELETE
  Future<void> deleteCategory(int id, String token) async {
    final response = await httpClient.delete(
      Uri.parse("$baseUrl/$id"),
      headers: _headers(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Gagal delete category");
    }
  }
}