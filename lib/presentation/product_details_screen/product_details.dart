import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/dashboard_page/dashboard_page.dart';
import 'package:shoper_flutter/routes/app_routes.dart';

// ignore: unused_element
class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;

  // Initialize fetchedData in the initState method
  @override
  void initState() {
    super.initState();
    fetchedData = FetchedData(
      message: '',
      responseCode: '',
      result: {},
      totalCounts: 0,
      statusCode: 0,
    );
  }

  Future<void> fetchData(String productId) async {
    if (isDataFetched) return;
    final filter = {'_id': productId};
    try {
      final response =
          await _apiService.fetchDataWithFilter('api/v1/product/fetch', filter);
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          fetchedData = FetchedData.fromJson(json.decode(response.body));
        });
      }
    } catch (error) {
      setState(() {
        fetchedData = FetchedData(
          message: 'Error: $error',
          responseCode: '',
          result: {},
          totalCounts: 0,
          statusCode: 0,
        );
      });
    }

    isDataFetched = true; // Set the flag to true after fetching data
    // }sDataFetched = true; // Set the flag to true after fetching data
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments == null || !arguments.containsKey('productId')) {
      // Handle the case where arguments are null or productId is not found
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid arguments'),
        ),
      );
    }

    // Access the parameters
    String productId = arguments['productId'];

    return FutureBuilder(
      future: fetchData(productId),
      builder: (context, snapshot) {
        Map<String, dynamic> result = fetchedData.result;

        if (result.containsKey('products')) {
          dynamic productsData = result['products'];

          if (productsData is List) {
            // Handle the case where 'products' is a List
            List<dynamic> productList = productsData;
            // You may want to iterate through the list or use specific items
            // depending on your API response structure
            return _buildProductList(productList);
          } else if (productsData is Map<String, dynamic>) {
            // Handle the case where 'products' is a Map
            Map<String, dynamic> productMap = productsData;
            return ProductGrid(product: productMap);
          } else {
            // Handle other cases if needed
            return _buildErrorWidget("Unexpected data type for 'products'");
          }
        } else {
          return _buildErrorWidget("Product key not found.");
        }
      },
    );
  }

  Widget _buildProductList(List<dynamic> productList) {
    // Handle the list of products as needed
    // You may want to create a list view, grid view, or any other UI widget
    // based on your application requirements.
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) {
        dynamic productItem = productList[index];
        // Return a widget for each product item
        return ProductGrid(product: productItem);
      },
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(
        'Error: $errorMessage',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class ProductDetailsPageState {}

class ProductGrid extends StatelessWidget {
  final Map<String, dynamic> product;
  final ApiService _apiService = ApiService();

  ProductGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    return buildProductCard(context, product);
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      elevation: 4.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            product['title'] ?? 'Unknown Product',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Price: \$${product['currentPrice']}',
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Add the product to the cart
              // You can implement your cart logic here
              addToCart(context, product);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Set the background color of the button
            ),
            child: Text('Add to Cart',
                style: TextStyle(color: Colors.white)), // Set the text color
          ),
        ],
      ),
    );
  }

  void addToCart(BuildContext context, Map<String, dynamic> product) async {
    try {
      if (product.isEmpty) {
        return;
      }

      final userData = {'productId': product['_id']};

      final response =
          await _apiService.postData('api/v1/cart/addProduct', userData);

      // if (response.statusCode == 200) {
      Navigator.pushNamed(context, AppRoutes.cartPage);
      // }
    } catch (error) {
      print('Error: $error');
      showSnackBar(context, 'An error occurred. Please try again later.');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
