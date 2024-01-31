import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/widgets/custom_rating_bar.dart';

// ignore: must_be_immutable
class DashboardItemWidget extends StatelessWidget {
  final dynamic product;

  DashboardItemWidget({Key? key, required this.product}) : super(key: key);
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    String baseUrl = _apiService.imgBaseUrl;
    double percentageDiscount = calculatePercentageDiscount(
        product['originalPrice'], product['currentPrice']);
    return GestureDetector(
      onTap: () {
        onProductDetailsClicked(context, product);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: AppDecoration.outlineBlue50.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.containsKey('media') && product['media'] is List)
              Expanded(
                child: SizedBox(
                  height: 133,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (product['media'] as List).length,
                    itemBuilder: (context, index) {
                      String imageUrl =
                          baseUrl + (product['media'][index] as String);
                      return Padding(
                        padding: EdgeInsets.only(
                            right: 8.0), // Add spacing between images
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            imageUrl,
                            height: 133,
                            width: 133,
                            fit: BoxFit.cover, // Adjust image fit as needed
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Error loading image');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            SizedBox(height: 8),
            SizedBox(
              width: 107,
              child: Text(
                _getTitleCase(product['title']) ?? 'Unknown Product',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge!.copyWith(
                  height: 1.50,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              product['subtitle'] ?? '--',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 2.0),
            // Text(
            //   product['description'] ?? '--',
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(fontSize: 14.0),
            // ),
            // SizedBox(height: 2.0),
            CustomRatingBar(
              ignoreGestures: true,
              initialRating: 4,
            ),
            SizedBox(height: 18),
            Text(
              'Price: ₹ ${product['currentPrice']}',
              style: CustomTextStyles.labelLargePrimary,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '₹ ${product['originalPrice']}',
                  style: CustomTextStyles.bodySmall10.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "${percentageDiscount.toStringAsFixed(1)}%off",
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Add the product to the cart
                // You can implement your cart logic here
                addToCart(context, product);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set the background color of the button
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(8.0), // Adjust the padding as needed
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ), // Set the text color
            ),
          ],
        ),
      ),
    );
  }

  void onProductDetailsClicked(
      BuildContext context, Map<String, dynamic> product) async {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetailScreen,
      arguments: {
        'productId': product['_id'], // Replace with the actual product ID
        // 'otherParam': 'otherValue', // Replace with other parameters
      },
    );
  }

  void addToCart(BuildContext context, Map<String, dynamic> product) async {
    try {
      if (product.isEmpty) {
        return;
      }

      final userData = {'productId': product['_id']};

      final response = await _apiService.postData(
          'api/v1/cart/incrementProductQuantity', userData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added to cart.'),
            action: SnackBarAction(
              label: 'View Cart',
              onPressed: () {
                // Navigate to cart page
                Navigator.pushNamed(context, AppRoutes.cartPage);
              },
            ),
          ),
        );
      } else {
        showSnackBar(context, 'An error occurred. Please try again later.');
      }
    } catch (error) {
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

double calculatePercentageDiscount(double originalPrice, double currentPrice) {
  if (originalPrice <= 0) {
    return 0.0; // Avoid division by zero
  }

  double percentageDiscount =
      ((originalPrice - currentPrice) / originalPrice) * 100;
  return percentageDiscount;
}

String _getTitleCase(String? title) {
  if (title == null) {
    return 'Unknown Product';
  }
  return titleCase(title);
}

String titleCase(String input) {
  List<String> words = input.split(' ');
  List<String> titleCaseWords = words.map((word) {
    if (word.isNotEmpty) {
      return '${word[0].toUpperCase()}${word.substring(1)}';
    } else {
      return '';
    }
  }).toList();
  return titleCaseWords.join(' ');
}
