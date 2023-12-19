import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class ManworkequipmentItemWidget extends StatelessWidget {
  const ManworkequipmentItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomIconButton(
          height: 70.adaptSize,
          width: 70.adaptSize,
          padding: EdgeInsets.all(23.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgManWorkEquipment,
          ),
        ),
        SizedBox(height: 8.v),
        Text(
          "lbl_office_bag".tr,
          style: CustomTextStyles.labelMediumBluegray300,
        ),
      ],
    );
  }
}
