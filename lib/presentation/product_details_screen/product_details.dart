import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/dashboard_page/dashboard_page.dart';
import 'package:shoper_flutter/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;

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

    isDataFetched = true;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments == null || !arguments.containsKey('productId')) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid arguments'),
        ),
      );
    }

    String productId = arguments['productId'];

    return FutureBuilder(
      future: fetchData(productId),
      builder: (context, snapshot) {
        Map<String, dynamic> result = fetchedData.result;

        if (result.containsKey('products')) {
          dynamic productsData = result['products'];

          if (productsData is List) {
            return _buildProductList(productsData);
          } else if (productsData is Map<String, dynamic>) {
            return ProductGrid(product: productsData);
          } else {
            return _buildErrorWidget("Unexpected data type for 'products'");
          }
        } else {
          return _buildErrorWidget("Product key not found.");
        }
      },
    );
  }

  Widget _buildProductList(List<dynamic> productList) {
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) {
        dynamic productItem = productList[index];
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

class ProductGrid extends StatelessWidget {
  final Map<String, dynamic> product;
  final ApiService _apiService = ApiService();

  ProductGrid({required this.product});

  @override
  Widget build(BuildContext context) {
    return buildProductCard(context, product);
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product) {
    String baseUrl = _apiService.imgBaseUrl;
    return Card(
      elevation: 4.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (product.containsKey('media') && product['media'] is List)
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (product['media'] as List).length,
                itemBuilder: (context, index) {
                  String imageUrl =
                      baseUrl + (product['media'][index] as String);
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 8.0),
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
              addToCart(context, product);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
            child: Text(
              'Add to Cart',
              style: TextStyle(color: Colors.white),
            ),
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

      Navigator.pushNamed(context, AppRoutes.cartPage);
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
