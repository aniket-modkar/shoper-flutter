import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Splash Screen".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Login".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Register".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Dashboard - Container".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Super Flash Sale".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Favorite Product".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Product Detail".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Review Product".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Write Review Fill".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification Offer".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification Feed".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification Activity".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search Result".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search Result No Data Found".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "List Category".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Sort By".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Filter".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Ship To".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Payment Method".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Choose Credit Or Debit Card".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Success Screen".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Profile".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Change Password".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Order".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Order Details".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add Address".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Address".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add Payment".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Credit Card And Debit".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Add Card".tr,
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Lailyfa Febrina Card".tr,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app."
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF888888),
          ),
        ],
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
