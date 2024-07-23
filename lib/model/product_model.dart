import 'dart:convert';

import 'package:thigiuaky/model/category_model.dart';

class Product {
  final int id;
  String title;
  double price;
  String description;
  List<String> images;
  final DateTime creationAt;
  DateTime updatedAt;
  Category category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = parseImages(json['images']);
    
    // Check if parsedImages is empty, indicating invalid format
    if (parsedImages.isEmpty) {
      throw Exception('Invalid image format');
    }

    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      images: parsedImages,
      creationAt: DateTime.parse(json['creationAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'images': jsonEncode(images), // Convert List<String> to JSON string
      'creationAt': creationAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category.toString(), // Convert Category to JSON
    };
  }

  static List<String> parseImages(dynamic imagesJson) {
    List<String> result = [];

    if (imagesJson is List) {
      for (var image in imagesJson) {
        if (image is String) {
          // Check if image is a JSON-like string representing a list of URLs
          try {
            var jsonList = jsonDecode(image);
            if (jsonList is List) {
              result.addAll(jsonList.map((url) => url.toString()));
            }
          } catch (e) {
            // If parsing fails, add the image as is to the result
            result.add(image);
          }
        }
      }
    }

    return result;
  }
}
