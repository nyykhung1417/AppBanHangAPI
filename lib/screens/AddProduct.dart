import 'package:flutter/material.dart';
import 'package:thigiuaky/api/api.dart';
import 'package:thigiuaky/model/product_model.dart';
import 'package:thigiuaky/screens/ProductScreens.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController imagesController = TextEditingController();

  Future<void> addProductToApi() async {
    String title = titleController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    String description = descriptionController.text;
    int categoryId = int.tryParse(categoryIdController.text) ?? 0;
    List<String> images =
        imagesController.text.split(',').map((url) => url.trim()).toList();

    try {
      Product product =
          await addProduct(title, price, description, categoryId, images);
    } catch (e) {
      
    }
  }

  



  void navigateToProductScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
   
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Giá tiền'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                  maxLines: 3,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: categoryIdController,
                  decoration: InputDecoration(labelText: 'Mã danh mục'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: imagesController,
                  decoration: InputDecoration(
                      labelText: 'Hình ảnh (comma-separated URLs)'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProductToApi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 71, 176, 39),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: Text('Thêm sản phẩm'),
            ),
          ],
        ),
      ),
    );
  }
}
