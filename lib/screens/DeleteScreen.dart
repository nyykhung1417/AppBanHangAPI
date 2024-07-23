import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:thigiuaky/api/api.dart';
import 'package:thigiuaky/model/product_model.dart';

class ProductDeleteScreen extends StatefulWidget {
  @override
  _ProductDeleteScreen createState() => _ProductDeleteScreen();
}

class _ProductDeleteScreen extends State<ProductDeleteScreen> {
  late Future<List<Product>> _productsFuture;
  Api api = Api();

  @override
  void initState() {
    super.initState();
    _productsFuture = api.fetchAllProducts();
  }

  Future<void> deleteProduct(int productId) async {
    final String apiUrl = 'https://api.escuelajs.co/api/v1/products/$productId';

    try {
      Response response = await Dio().delete(
        apiUrl,
        options: Options(
          headers: {
            'accept': '*/*',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Product with ID $productId deleted successfully');
        // Fetch updated product list
        setState(() {
          _productsFuture = api.fetchProducts(currentPage: 0);
        });
      } else {
        throw Exception('Failed to delete product with ID $productId');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5,
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: product.images.isNotEmpty
                              ? NetworkImage(product.images[0])
                              : NetworkImage(
                                  'https://globalseafoods.com/cdn/shop/products/global-seafoods-north-america-fresh-yellowfin-tuna-from-hawaii-28285493346370_2048x.jpg?v=1627997326',
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '\$${product.price}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await deleteProduct(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Product deleted successfully'),
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to delete product: $e'),
                          ));
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
