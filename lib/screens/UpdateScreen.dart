import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:thigiuaky/api/api.dart'; // Đảm bảo import Api và ProductModel tương ứng
import 'package:thigiuaky/model/product_model.dart';

class ProductEditScreen extends StatefulWidget {
  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  late Future<List<Product>> _productsFuture;
  Api api = Api();

  @override
  void initState() {
    super.initState();
    _productsFuture = api.fetchAllProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = api.fetchAllProducts();
    });
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          product.images.isNotEmpty
                              ? product.images[0]
                              : 'https://globalseafoods.com/cdn/shop/products/global-seafoods-north-america-fresh-yellowfin-tuna-from-hawaii-28285493346370_2048x.jpg?v=1627997326',
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductDetailsScreen(product: product),
                            ),
                          );

                          if (result == true) {
                            _refreshProducts();
                          }
                        },
                      ),
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


class EditProductDetailsScreen extends StatefulWidget {
  final Product product;

  EditProductDetailsScreen({required this.product});

  @override
  _EditProductDetailsScreenState createState() => _EditProductDetailsScreenState();
}

class _EditProductDetailsScreenState extends State<EditProductDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _createdAtController;
  late TextEditingController _updatedAtController;
  late TextEditingController _imagesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _createdAtController = TextEditingController(text: widget.product.creationAt.toString());
    _updatedAtController = TextEditingController(text: widget.product.updatedAt.toString());
    _imagesController = TextEditingController(text: widget.product.images.isNotEmpty ? widget.product.images[0] : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Product Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _imagesController,
              decoration: InputDecoration(labelText: 'Image URLs'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _createdAtController,
              decoration: InputDecoration(labelText: 'Created At'),
              enabled: false, // Không cho phép chỉnh sửa ngày tạo
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _updatedAtController,
              decoration: InputDecoration(labelText: 'Updated At'),
              enabled: false, // Không cho phép chỉnh sửa ngày cập nhật
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Xử lý lưu chỉnh sửa sản phẩm vào API
                  Product editedProduct = Product(
                    id: widget.product.id,
                    title: _titleController.text,
                    price: double.parse(_priceController.text),
                    description: _descriptionController.text,
                    creationAt: widget.product.creationAt,
                    updatedAt: DateTime.now(), // Cập nhật ngày cập nhật mới nhất
                    images: [_imagesController.text],
                    category: widget.product.category, // Thêm hình ảnh từ TextField
                    // Các thuộc tính khác tương tự
                  );

                  try {
                    Response response = await Dio().put(
                      'https://api.escuelajs.co/api/v1/products/${widget.product.id}',
                      data: {
                        "id": editedProduct.id,
                        "title": editedProduct.title,
                        "price": editedProduct.price,
                        "description": editedProduct.description,
                        "images": editedProduct.images,
                        "creationAt": editedProduct.creationAt.toIso8601String(),
                        "updatedAt": editedProduct.updatedAt.toIso8601String(),
                        "category": {
                          "id": editedProduct.category.id,
                          "name": editedProduct.category.name,
                          "image": editedProduct.category.image,
                          "creationAt": editedProduct.category.creationAt.toIso8601String(),
                          "updatedAt": editedProduct.category.updatedAt.toIso8601String()
                        }
                      },
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product edited successfully'),
                        ),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to edit product: ${response.statusCode}'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error editing product: $e'),
                      ),
                    );
                  }
                },
                child: Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _createdAtController.dispose();
    _updatedAtController.dispose();
    _imagesController.dispose();
    super.dispose();
  }
}

