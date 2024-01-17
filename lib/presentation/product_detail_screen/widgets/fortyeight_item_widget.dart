import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';

// ignore: must_be_immutable
class FortyeightItemWidget extends StatelessWidget {
  final dynamic product;

  FortyeightItemWidget({Key? key, required this.product}) : super(key: key);

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    String baseUrl = _apiService.imgBaseUrl;

    // Use a `return` statement to return the widget being built
    return Container(
      height: 133.adaptSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (product['media'] as List).length,
        itemBuilder: (context, index) {
          String imageUrl = baseUrl + (product['media'][index] as String);
          return CustomImageView(
            imagePath: imageUrl,
            height: 238.adaptSize,
            width: 375.adaptSize,
            radius: BorderRadius.circular(5.h),
          );
        },
      ),
    );
  }
}
