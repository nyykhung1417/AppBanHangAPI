import 'package:flutter/material.dart';
import 'package:thigiuaky/model/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple,
                Colors.cyan.withOpacity(0.5),
                Colors.blue.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Chi tiết sản phẩm',
          style: const TextStyle(fontSize: 26, color: Colors.black),
        ), // Remove the shadow under the app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: product.images.isNotEmpty
                    ? NetworkImage(product.images[0])
                      : NetworkImage(
                          '"https://globalseafoods.com/cdn/shop/products/global-seafoods-north-america-fresh-yellowfin-tuna-from-hawaii-28285493346370_2048x.jpg?v=1627997326'),
                  fit: BoxFit.fill,
                ),
                boxShadow: [ // Add a shadow to the image container
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              product.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change the text color to black
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Mô tả:', // Vietnamese for 'Description'
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change the text color to black
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700], // Change the text color to a darker grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}