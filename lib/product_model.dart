// ProductModel ek data model class hai
// Ye API se aane wale product data ko represent karta hai

class ProductModel {

  // Product ki unique id
  final int id;

  // Product ka title (naam)
  final String title;

  // Product ka description (detail info)
  final String description;

  // Constructor
  // required ka matlab hai ki object banate waqt
  // ye sari values dena compulsory hai
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
  });

  // Factory constructor
  // Ye JSON data ko ProductModel object me convert karta hai
  // Jab API se response aata hai (Map<String, dynamic> format me)
  // tab ye method use hota hai
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(

      // JSON se id fetch kar rahe hain
      id: json['id'],

      // JSON se title fetch kar rahe hain
      title: json['title'],

      // JSON se description fetch kar rahe hain
      description: json['description'],
    );
  }
}
