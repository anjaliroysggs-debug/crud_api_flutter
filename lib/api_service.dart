import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  // ✅ GET Products
  Future<List<dynamic>> getProducts() async {
    final response =
    await http.get(Uri.parse("https://dummyjson.com/products"));

    final data = jsonDecode(response.body);
    return data['products'];
  }

  // ✅ ADD Product
  Future<dynamic> addProduct(
      String title, String description, String image) async {

    final response = await http.post(
      Uri.parse("https://dummyjson.com/products/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "thumbnail": image,
      }),
    );

    return jsonDecode(response.body);
  }

  // ✅ UPDATE Product
  Future<dynamic> updateProduct(
      int id, String title, String description, String image) async {

    final response = await http.put(
      Uri.parse("https://dummyjson.com/products/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "thumbnail": image,
      }),
    );

    return jsonDecode(response.body);
  }

  // ✅ DELETE Product
  Future<void> deleteProduct(int id) async {
    await http.delete(
      Uri.parse("https://dummyjson.com/products/$id"),
    );
  }
}
