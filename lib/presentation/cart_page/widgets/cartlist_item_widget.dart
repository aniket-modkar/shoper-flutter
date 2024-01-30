import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';

class CartlistItemWidget extends StatelessWidget {
  final dynamic cartData;
  final VoidCallback onChanged;
  CartlistItemWidget(
      {Key? key, required this.cartData, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> products = cartData['products'];

    return Column(
      children: products.map((product) {
        return _buildCartItem(context, product);
      }).toList(),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic product) {
    final ApiService _apiService = ApiService();
    String baseUrl = _apiService.imgBaseUrl;
    final String title = product['productId']['title'] ?? '';
    final int quantity = product['quantity'] ?? 0;
    final double price = product['subTotal'] ?? 0.0;
    final List<String> media =
        (product['productId']['media'] as List<dynamic>).cast<String>();
    final String imageUrl = media.isNotEmpty ? media[0] : '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.v),
      decoration: AppDecoration.outlineBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomImageView(
            imagePath: baseUrl + imageUrl, // Use the product image
            height: 72.adaptSize,
            width: 72.adaptSize,
            radius: BorderRadius.circular(5.h),
            margin: EdgeInsets.symmetric(vertical: 1.v),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150.h,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge!.copyWith(
                        height: 1.50,
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgLoveIcon,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    margin: EdgeInsets.only(
                      left: 20.h,
                      bottom: 10.v,
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgTrashIcon,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    margin: EdgeInsets.only(
                      left: 8.h,
                      bottom: 10.v,
                    ),
                    onTap: () {
                      // Add your function here
                      removedToCart(context, product);
                      // You can perform any action or call a function when the image is tapped
                    },
                  ),
                ],
              ),
              SizedBox(height: 17.v),
              SizedBox(
                width: 227.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹ ${price.toStringAsFixed(2)}".tr,
                      style: CustomTextStyles.labelLargePrimary,
                    ),
                    Spacer(),
                    CustomImageView(
                      imagePath: ImageConstant.imgFolder,
                      height: 20.v,
                      width: 33.h,
                      onTap: () {
                        // Add your function here
                        decrementToCart(context, product);
                        // You can perform any action or call a function when the image is tapped
                      },
                    ),
                    SizedBox(
                      height: 20.v,
                      width: 41.h,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 20.v,
                              width: 41.h,
                              decoration: BoxDecoration(
                                color: appTheme.blue50,
                                border: Border.all(
                                  color: appTheme.blue50,
                                  width: 1.h,
                                  strokeAlign: strokeAlignCenter,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Opacity(
                              opacity: 0.5,
                              child: Padding(
                                padding: EdgeInsets.only(right: 17.h),
                                child: Text(
                                  "${quantity.toString()}".tr,
                                  style: CustomTextStyles.bodySmallOnPrimary_2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgPlus,
                      height: 20.v,
                      width: 33.h,
                      onTap: () {
                        // Add your function here
                        incrementToCart(context, product);
                        // You can perform any action or call a function when the image is tapped
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final ApiService _apiService = ApiService();

  void incrementToCart(
      BuildContext context, Map<String, dynamic> product) async {
    try {
      if (product.isEmpty) {
        return;
      }
      final String productId = product['productId']['_id'] ?? '';
      final userData = {'productId': productId};

      final response = await _apiService.postData(
          'api/v1/cart/incrementProductQuantity', userData);
      if (response.statusCode == 200) {
        _handleTap();
      }
    } catch (error) {
      showSnackBar(context, 'An error occurred. Please try again later.');
    }
  }

  void decrementToCart(
      BuildContext context, Map<String, dynamic> product) async {
    try {
      if (product.isEmpty) {
        return;
      }
      final String productId = product['_id'] ?? '';
      final userData = {'productId': productId};

      final response = await _apiService.postData(
          'api/v1/cart/decrementProductQuantity', userData);
      if (response.statusCode == 200) {
        _handleTap();
      }
      // Navigator.pushNamed(context, AppRoutes.cartPage);
    } catch (error) {
      showSnackBar(context, 'An error occurred. Please try again later.');
    }
  }

  void removedToCart(BuildContext context, Map<String, dynamic> product) async {
    try {
      if (product.isEmpty) {
        return;
      }

      final String productId = product['_id'] ?? '';
      final userData = {'productId': productId};

      final response =
          await _apiService.postData('api/v1/cart/removeProduct', userData);
      if (response.statusCode == 200) {
        _handleTap();
      }
    } catch (error) {
      showSnackBar(context, 'An error occurred. Please try again later.');
    }
  }

  void _handleTap() {
    // Perform any necessary logic here

    // Notify the parent widget that a change has occurred
    onChanged();
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
