import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';

// ignore: must_be_immutable

class OrderdetailsItemWidget extends StatelessWidget {
  final dynamic product;

  const OrderdetailsItemWidget({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();
    String baseUrl = _apiService.imgBaseUrl;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.v),
      decoration: AppDecoration.outlineBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomImageView(
            imagePath: product.containsKey('media') && product['media'] is List
                ? baseUrl + (product['media'][0] as String)
                : ImageConstant.imgImageProduct,
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
                      product['name'],
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
                      "${product['price']}",
                      style: CustomTextStyles.labelLargePrimary,
                    ),
                    Spacer(),
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgFolder,
                    //   height: 20.v,
                    //   width: 33.h,
                    // ),
                    // ... Other widgets as needed

                    Text(
                      "${product['quantity']}",
                      style: CustomTextStyles.labelLargePrimary,
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
}
