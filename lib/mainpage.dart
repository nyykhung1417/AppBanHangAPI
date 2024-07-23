import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:thigiuaky/screens/AddProduct.dart';
import 'package:thigiuaky/screens/DeleteScreen.dart';
import 'package:thigiuaky/screens/ProductScreens.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:thigiuaky/screens/UpdateScreen.dart';
// ignore: depend_on_referenced_packages


class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'YaMe !!!';
      case 1:
        return 'Thêm sản phẩm mới';
      case 2:
        return 'Xóa sản phẩm';
      case 3:
        return 'Chỉnh sửa sản ph';
      default:
        return 'YaMe !!!';
    }
  }

  Widget _loadWidget(int index) {
    switch (index) {
      case 0:
        return ProductListScreen();
      case 1:
        return AddProductScreen();
      case 2: 
        return ProductDeleteScreen();
      // case 2:
      //   return const CartScreen();
      case 3:
        return ProductEditScreen();
      default:
        return Container();
    }
  }

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
          getTitle(_selectedIndex),
          style: const TextStyle(fontSize: 26, color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(146, 202, 221, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nâng niu vẻ đẹp Á Đông '),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.history),
            //   title: const Text('History'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _onItemTapped(1);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.shop),
            //   title: const Text('Cart'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _onItemTapped(2);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.category_outlined),
            //   title: const Text('Category'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _onItemTapped(0);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const CategoryList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.production_quantity_limits_outlined),
            //   title: const Text('Product'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _onItemTapped(0);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const ProductList()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.pages),
            //   title: const Text('Page3'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     _onItemTapped(0);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const ProductList()),
            //     );
            //   },
            // ),
            //   const Divider(
            //     color: Colors.black,
            //   ),
            //   user.accountId == ''
            //       ? const SizedBox()
            //       : ListTile(
            //           leading: const Icon(Icons.exit_to_app),
            //           title: const Text('Logout'),
            //           onTap: () {
            //             logOut(context);
            //           },
            //         ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.delete, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 44, 199, 32),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
