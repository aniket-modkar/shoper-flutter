import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class ManworkequipmentItemWidget extends StatelessWidget {
  final dynamic category;
  const ManworkequipmentItemWidget({Key? key, required this.category})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();
    String baseUrl = _apiService.imgBaseUrl;
    String imageUrl = baseUrl + (category['categoryImg'] as String);
    return Column(
      children: [
        CustomIconButton(
          height: 70.adaptSize,
          width: 70.adaptSize,
          padding: EdgeInsets.all(23.h),
          child: CustomImageView(
            imagePath: imageUrl,
          ),
        ),
        SizedBox(height: 8.v),
        Text(
          "${category['name']}".tr,
          style: CustomTextStyles.labelMediumBluegray300,
        ),
      ],
    );
  }
}
