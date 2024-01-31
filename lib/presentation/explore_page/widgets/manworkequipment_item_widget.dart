import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';

class ManWorkEquipmentItemWidget extends StatelessWidget {
  final dynamic category;
  final bool hasGridView;

  const ManWorkEquipmentItemWidget({
    Key? key,
    required this.category,
    this.hasGridView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();
    String baseUrl = _apiService.imgBaseUrl;
    String imageUrl = category['categoryImg'] != null
        ? baseUrl + (category['categoryImg'] as String)
        : '';

    // Check if the category has child categories
    bool hasChildCategories =
        category['Childs'] != null && (category['Childs'] as List).isNotEmpty;

    return GestureDetector(
        onTap: () {
          onProductDetailsClicked(context, category);
        },
        child: Column(
          children: [
            Container(
              child: CustomIconButton(
                height: 50.adaptSize,
                width: 50.adaptSize,
                child: CustomImageView(
                  imagePath: imageUrl,
                ),
              ),
            ),
            SizedBox(height: 8.v),
            Text(
              "${category['name']}".tr,
              style: CustomTextStyles.labelMediumBluegray300,
            ),
            // Show the GridView.builder only if the category has child categories
            // if (hasChildCategories)
            //   GridView.builder(
            //     shrinkWrap: true,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       mainAxisExtent: 94.v,
            //       crossAxisCount: 4,
            //       mainAxisSpacing: 21.h,
            //       crossAxisSpacing: 21.h,
            //     ),
            //     itemCount: category['Childs'].length,
            //     itemBuilder: (context, index) {
            //       var subCategory = category['Childs'][index];
            //       return ManWorkEquipmentItemWidget(category: subCategory);
            //     },
            //   ),
            SizedBox(height: 8.v),
          ],
        ));
  }

  void onProductDetailsClicked(
      BuildContext context, Map<String, dynamic> category) async {
    Navigator.pushNamed(
      context,
      AppRoutes.categorydetails,
      arguments: {
        'categoryId': category['_id'],
        'categoryName': category['name'], // Replace with the actual product ID
        // 'otherParam': 'otherValue', // Replace with other parameters
        // 'otherParam': 'otherValue', // Replace with other parameters
      },
    );
  }
}
