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

    return GestureDetector(
      onTap: () {
        onProductDetailsClicked(context, product);
      },
      child: Container(
        padding: EdgeInsets.all(15.h),
        decoration: AppDecoration.outlineBlue50.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.containsKey('media') && product['media'] is List)
              Container(
                height: 133.adaptSize,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (product['media'] as List).length,
                  itemBuilder: (context, index) {
                    String imageUrl =
                        baseUrl + (product['media'][index] as String);
                    return CustomImageView(
                      imagePath: imageUrl,
                      height: 133.adaptSize,
                      width: 133.adaptSize,
                      radius: BorderRadius.circular(
                        5.h,
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 8.v),
            SizedBox(
              width: 107.h,
              child: Text(
                product['title'] ?? 'Unknown Product',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge!.copyWith(
                  height: 1.50,
                ),
              ),
            ),
            SizedBox(height: 5.v),
            Text(
              product['subtitle'] ?? '--',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 2.0),
            Text(
              product['description'] ?? '--',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 2.0),
            CustomRatingBar(
              ignoreGestures: true,
              initialRating: 4,
            ),
            SizedBox(height: 18.v),
            Text(
              'Price: \ ₹${product['currentPrice']}',
              style: CustomTextStyles.labelLargePrimary,
            ),
            SizedBox(height: 5.v),
            Row(
              children: [
                Text(
                  "lbl_534_33".tr,
                  style: CustomTextStyles.bodySmall10.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "lbl_24_off".tr,
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
              child: Text('Add to Cart',
                  style: TextStyle(color: Colors.white)), // Set the text color
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

      final response =
          await _apiService.postData('api/v1/cart/addProduct', userData);

      // if (response.statusCode == 200) {
      Navigator.pushNamed(context, AppRoutes.cartPage);
      // }
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
