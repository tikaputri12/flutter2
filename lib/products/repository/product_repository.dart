import 'package:http/http.dart' as http;

class ProductRepository {
  final http.Client httpClient;
  ProductRepository({required this.httpClient});
  static const String baseUrl =
      'https://api.ppb.widiarrohman.my.id/api/products';

}