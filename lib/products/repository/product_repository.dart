import 'dart:convert';

import 'package:flutter2/products/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final http.Client httpClient;

  ProductRepository({
    required this.httpClient,
  });

  static const String baseUrl =
      'https://api.ppb.widiarrohman.my.id/api/products';

  // ================= GET PRODUCT =================
  Future<List<ProductModel>> getProducts({
    required String token,
  }) async {

    final response = await httpClient.get(
      Uri.parse(baseUrl),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil product");
    }

    final decoded = jsonDecode(response.body);

    final List data = decoded['data'];

    return data
        .map((e) => ProductModel.fromMap(e))
        .toList();
  }

  // ================= CREATE PRODUCT =================
  Future<void> createProduct({
    required String token,
    required int idCategory,
    required String name,
    required String description,
    required bool available,
    required int stock,
    String? expired,
  }) async {

    final response = await httpClient.post(
      Uri.parse(baseUrl),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode({
        "data": {
          "id_category": idCategory,
          "name": name,
          "description": description,
          "available": available,
          "stock": stock,
          "expired": expired,
        }
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception("Gagal menambah product");
    }
  }

  // ================= UPDATE PRODUCT =================
  Future<void> updateProduct({
    required String token,
    required int id,
    required String name,
    required String description,
    required int idCategory,
    required int stock,
    required bool available,
    String? expired,
  }) async {

    final response = await httpClient.put(
      Uri.parse("$baseUrl/$id"),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode({
        "data": {
          "id_category": idCategory,
          "name": name,
          "description": description,
          "available": available,
          "stock": stock,
          "expired": expired,
        }
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Gagal update product");
    }
  }

  // ================= DELETE PRODUCT =================
  Future<void> deleteProduct({
    required String token,
    required int id,
  }) async {

    final response = await httpClient.delete(
      Uri.parse("$baseUrl/$id"),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception("Gagal delete product");
    }
  }
}