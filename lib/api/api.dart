import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thigiuaky/model/product_model.dart';

class Api {
  final String baseUrl = "https://api.escuelajs.co/api/v1/products";
  final String productDetailUrl = "https://api.escuelajs.co/api/v1/products/17";

  final int _pageSize = 10; // Number of items per page

  Future<List<Product>> fetchProducts({required int currentPage}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?offset=${currentPage * _pageSize}&limit=$_pageSize'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Product> products = jsonResponse.map((product) => Product.fromJson(product)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }
  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Product> products = jsonResponse.map((product) => Product.fromJson(product)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error fetching products: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }
  Future<Product> fetchProductDetail(int productId) async {
    try {
      final response = await Dio().get('$baseUrl/$productId');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return Product.fromJson(data); // Assuming Product.fromJson method exists
      } else {
        throw Exception('Failed to load product detail');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }


}
  
Future<Product> addProduct(String title, double price, String description,
    int categoryId, List<String> images) async {
  final String apiUrl = 'https://api.escuelajs.co/api/v1/products/';

  try {
    Response response = await Dio().post(
      apiUrl,
      data: {
        'title': title,
        'price': price,
        'description': description,
        'categoryId': categoryId,
        'images': images,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      throw Exception('Failed to add product: ${response.statusCode} - ${response.statusMessage}');
    }
  } catch (e) {
    if (e is DioError) {
      // Handle DioError specifically
      print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Failed to add product: ${e.message}\nResponse data: ${e.response?.data}');
    } else {
      // Handle any other type of error
      print('Error: $e');
      throw Exception('Failed to add product: $e');
    }
  }
}