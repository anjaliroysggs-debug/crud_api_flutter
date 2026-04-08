// dart:convert use hota hai JSON encode/decode karne ke liye
import 'dart:convert';

// http package API call karne ke liye use hota hai
import 'package:http/http.dart' as http;

// ApiService class ka kaam hai
// saare API operations (GET, POST, PUT, DELETE) handle karna
class ApiService {

  // =========================
  // GET ALL PRODUCTS
  // =========================
  // Ye method server se product list fetch karta hai
  // Return type Future<List<dynamic>> hai
  // kyunki API call asynchronous hoti hai

  Future<List<dynamic>> getProducts() async {

    // API endpoint ko call kar rahe hain
    final response =
    await http.get(Uri.parse("https://dummyjson.com/products"));

    // Response body ko JSON se Dart object me convert kar rahe hain
    final data = jsonDecode(response.body);

    // JSON ke andar 'products' key me list milti hai
    return data['products'];
  }



  // =========================
  // ADD PRODUCT (POST)
  // =========================
  // Ye method new product add karta hai server par

  Future<dynamic> addProduct(
      String title, String description, String image) async {

    // POST request bhej rahe hain
    final response = await http.post(

      // Add product endpoint
      Uri.parse("https://dummyjson.com/products/add"),

      // Header me batate hain ki data JSON format me hai
      headers: {"Content-Type": "application/json"},

      // Body me product ka data bhej rahe hain
      body: jsonEncode({
        "title": title,
        "description": description,
        "thumbnail": image,
      }),
    );

    // Server ka response decode karke return kar rahe hain
    return jsonDecode(response.body);
  }



  // =========================
  //  UPDATE PRODUCT (PUT)
  // =========================
  // Ye method existing product ko update karta hai

  Future<dynamic> updateProduct(
      int id, String title, String description, String image) async {

    // PUT request bhej rahe hain specific product id ke liye
    final response = await http.put(

      // Dynamic id use kar rahe hain
      Uri.parse("https://dummyjson.com/products/$id"),

      headers: {"Content-Type": "application/json"},

      // Updated data bhej rahe hain
      body: jsonEncode({
        "title": title,
        "description": description,
        "thumbnail": image,
      }),
    );

    // Updated response return kar rahe hain
    return jsonDecode(response.body);
  }



  // =========================
  // DELETE PRODUCT
  // =========================
  // Ye method product ko delete karta hai server se

  Future<void> deleteProduct(int id) async {

    // DELETE request specific id ke liye
    await http.delete(
      Uri.parse("https://dummyjson.com/products/$id"),
    );
  }
}
