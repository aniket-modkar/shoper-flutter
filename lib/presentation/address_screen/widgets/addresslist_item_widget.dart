import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';

class AddresslistItemWidget extends StatelessWidget {
  final dynamic addressData;

  AddresslistItemWidget({Key? key, required this.addressData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> countryId = addressData['countryId'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 23.h,
        vertical: 21.v,
      ),
      decoration: AppDecoration.outlinePrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${addressData['firstName']} ${addressData['lastName']}".tr,
            style: theme.textTheme.titleSmall, // Make sure 'theme' is defined
          ),
          SizedBox(height: 19.v),
          Container(
            width: 264.h,
            margin: EdgeInsets.only(right: 30.h),
            child: Text(
              "Type: ${addressData['type']}".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(
                height: 1.80,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Text(
            "${addressData['address1']} ${addressData['city']},${addressData['postalCode']}"
                .tr,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 19.v),
          Text(
            "Country Name: ${countryId['displayName']}",
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 19.v),
          Row(
            children: [
              Text(
                "lbl_edit".tr,
                style: CustomTextStyles.titleSmallPrimary,
              ),
              SizedBox(width: 32.h),
              Text(
                "lbl_delete".tr,
                style: CustomTextStyles.titleSmallPink300,
              ),
            ],
          ),
          SizedBox(height: 3.v),
        ],
      ),
    );
  }
}
