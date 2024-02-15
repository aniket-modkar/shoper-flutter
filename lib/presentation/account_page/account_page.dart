import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_title.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:shoper_flutter/widgets/custom_bottom_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String currentRoute = AppRoutes.accountPage;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 11.v),
          child: Column(
            children: [
              _buildAccountOptionOrder(
                context,
                bagIconImage: ImageConstant.imgUserPrimary,
                orderText: "lbl_profile".tr,
                onTapAccountOptionOrder: () {
                  onTapAccountOption(context, "lbl_profile");
                },
              ),
              _buildAccountOptionOrder(
                context,
                bagIconImage: ImageConstant.imgBagIcon,
                orderText: "lbl_order".tr,
                onTapAccountOptionOrder: () {
                  onTapAccountOption(context, "lbl_order");
                },
              ),
              _buildAccountOptionOrder(
                context,
                bagIconImage: ImageConstant.imgLocation,
                orderText: "lbl_address".tr,
                onTapAccountOptionOrder: () {
                  onTapAccountOption(context, "lbl_address");
                },
              ),
              SizedBox(height: 5.v),
              _buildAccountOptionOrder(
                context,
                bagIconImage: ImageConstant.imgCreditCardIcon,
                orderText: "lbl_payment".tr,
                onTapAccountOptionOrder: () {
                  onTapAccountOption(context, "lbl_payment");
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          currentRoute: currentRoute,
          onChanged: (BottomBarEnum type) {
            setState(() {
              currentRoute = getCurrentRoute(type);
            });
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: AppbarTitle(
        text: "lbl_account".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgNotificationIcon,
          margin: EdgeInsets.fromLTRB(13.h, 15.v, 13.h, 16.v),
          onTap: () {
            onTapNotificationIcon(context);
          },
        ),
      ],
    );
  }

  Widget _buildAccountOptionOrder(
    BuildContext context, {
    required String bagIconImage,
    required String orderText,
    Function? onTapAccountOptionOrder,
  }) {
    return GestureDetector(
      onTap: () {
        onTapAccountOptionOrder?.call();
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16.h),
        decoration: AppDecoration.fillOnPrimaryContainer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              imagePath: bagIconImage,
              height: 24.adaptSize,
              width: 24.adaptSize,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.h, top: 2.v, bottom: 3.v),
              child: Text(
                orderText,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapAccountOption(BuildContext context, String option) {
    switch (option) {
      case "lbl_profile":
        Navigator.pushNamed(context, AppRoutes.profileScreen);
        break;
      case "lbl_order":
        Navigator.pushNamed(context, AppRoutes.orderScreen);
        break;
      case "lbl_address":
        Navigator.pushNamed(context, AppRoutes.addressScreen);
        break;
      case "lbl_payment":
        // Handle payment screen navigation
        break;
      default:
        break;
    }
  }

  void onTapNotificationIcon(BuildContext context) {
    // Your implementation here
  }

  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.dashboardPage;
      case BottomBarEnum.Explore:
        return AppRoutes.explorePage;
      case BottomBarEnum.Cart:
        return AppRoutes.cartPage;
      case BottomBarEnum.Offer:
        return AppRoutes.offerScreenPage;
      case BottomBarEnum.Account:
        return AppRoutes.accountPage;
      default:
        return "/";
    }
  }
}
