import 'package:flutter/material.dart';
import 'package:thigiuaky/api/api.dart';
import 'package:thigiuaky/model/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thigiuaky/screens/ProductDetail.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  int _currentPage = 0; // Track current page

  @override
  void initState() {
    super.initState();
    futureProducts = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    try {
      final products = await Api().fetchProducts(currentPage: _currentPage);
      return products;
    } catch (e) {
      print("Error fetching products: $e");
      return []; // Return an empty list or handle the error as needed
    }
  }

  void nextPage() {
    setState(() {
      _currentPage++;
      futureProducts = _fetchProducts();
    });
  }

  void previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
        futureProducts = _fetchProducts();
      }
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[900], // Dark background color
    body: FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          return Column(
            children: <Widget>[
              _buildCarouselBanner(snapshot.data!),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.count(
                    crossAxisCount: 2, // Number of items per row
                    children: snapshot.data!.map((product) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.grey[800], // Darker card background color
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      image: DecorationImage(
                                        image: product.images.isNotEmpty
                                            ? NetworkImage(product.images[0])
                                            : AssetImage('assets/empty.png') as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(12.0),
                                                bottomRight: Radius.circular(12.0),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  product.title,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  '\$${product.price}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Change the button color to blue accent
                      foregroundColor: Colors.white, // Change the text color to white
                      elevation: 0, // Remove the shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Add a rounded corner
                      ),
                    ),
                    onPressed: _currentPage > 0 ? previousPage : null,
                    child: Icon(Icons.arrow_left), // Replace with a left arrow icon
                  ),
                SizedBox(width: 16.0),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      '${_currentPage + 1}', // Display current page number
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent, // Change the button color to orange accent
                      foregroundColor: Colors.white, // Change the text color to white
                      elevation: 0, // Remove the shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Add a rounded corner
                      ),
                    ),
                    onPressed: nextPage,
                    child: Icon(Icons.arrow_right), // Replace with a right arrow icon
                  ),
                ],
              )
            ],
          );
        }
      },
    ),
  );
}


  Widget _buildCarouselBanner(List<Product> products) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16/9,
        viewportFraction: 0.8,
      ),
      items:[
                  'assets/banner2.jpg',
                  'assets/banner3.jpg',
                  'assets/banner4.jpg',
                  'assets/banner5.png',
                        ].map((imagePath) {
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
        }).toList(),
    );
  }
}
