import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';

class FetchedData {
  final String message;
  final String responseCode;
  final Map<String, dynamic> result;
  final int totalCounts;
  final int statusCode;

  FetchedData({
    required this.message,
    required this.responseCode,
    required this.result,
    required this.totalCounts,
    required this.statusCode,
  });

  factory FetchedData.fromJson(Map<String, dynamic> json) {
    return FetchedData(
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      result: json['result'] ?? {},
      totalCounts: json['totalCounts'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'FetchedData { message: $message, responseCode: $responseCode, result: $result, totalCounts: $totalCounts, statusCode: $statusCode }';
  }
}

class CustomBottomBar extends StatefulWidget {
  final Function(BottomBarEnum)? onChanged;
  final String currentRoute;

  CustomBottomBar({this.onChanged, required this.currentRoute});

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;

  bool isDataFetched = false;
  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgNavHome,
      activeIcon: ImageConstant.imgNavHome,
      title: "lbl_home".tr,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavExplore,
      activeIcon: ImageConstant.imgNavExplore,
      title: "lbl_explore".tr,
      type: BottomBarEnum.Explore,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavCart,
      activeIcon: ImageConstant.imgNavCart,
      title: "lbl_cart".tr,
      type: BottomBarEnum.Cart,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavOffer,
      activeIcon: ImageConstant.imgNavOffer,
      title: "lbl_offer".tr,
      type: BottomBarEnum.Offer,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavAccount,
      activeIcon: ImageConstant.imgNavAccount,
      title: "lbl_account".tr,
      type: BottomBarEnum.Account,
    )
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = getCurrentIndex(widget.currentRoute);
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await _apiService.fetchData('api/v1/cart/fetch');
      if (response.statusCode == 202) {
        setState(() {
          fetchedData = FetchedData.fromJson(json.decode(response.body));
          isDataFetched = true;
        });
      } else {
        // Handle non-200 status code, if needed
      }
    } catch (error) {
      setState(() {
        fetchedData = FetchedData(
          message: 'Error: $error',
          responseCode: '',
          result: {},
          totalCounts: 0,
          statusCode: 0,
        );
      });
    }
  }

  int getCurrentIndex(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.dashboardPage:
        return 0;
      case AppRoutes.explorePage:
        return 1;
      case AppRoutes.cartPage:
        return 2;
      case AppRoutes.offerScreenPage:
        return 3;
      case AppRoutes.accountPage:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Divider(),
        ),
        Container(
          height: 66.v,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            elevation: 0,
            currentIndex: selectedIndex,
            type: BottomNavigationBarType.fixed,
            items: List.generate(bottomMenuList.length, (index) {
              if (bottomMenuList[index].type == BottomBarEnum.Cart) {
                String cartLabel = 'Cart';
                if (fetchedData.result.containsKey('cart')) {
                  dynamic cartData = fetchedData.result['cart'];
                  dynamic products = cartData[0]['products'];
                  if (products != null && products.isNotEmpty) {
                    cartLabel += ' (${products.length})';
                    print(products.length);
                  }
                }
                return BottomNavigationBarItem(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].icon,
                        height: 23.v,
                        width: 24.h,
                        color: appTheme.blueGray300,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.v),
                        child: Text(
                          cartLabel,
                          style: CustomTextStyles.bodySmall10.copyWith(
                            color: appTheme.pink300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].activeIcon,
                        height: 23.v,
                        width: 24.h,
                        color: theme.colorScheme.primary.withOpacity(1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.v),
                        child: Text(
                          cartLabel,
                          style: CustomTextStyles.labelMediumPrimary.copyWith(
                            color: theme.colorScheme.primary.withOpacity(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: '',
                );
              } else {
                // For other menu items
                return BottomNavigationBarItem(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].icon,
                        height: 23.v,
                        width: 24.h,
                        color: appTheme.blueGray300,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.v),
                        child: Text(
                          bottomMenuList[index].title ?? "",
                          style: CustomTextStyles.bodySmall10.copyWith(
                            color: appTheme.blueGray300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: bottomMenuList[index].activeIcon,
                        height: 23.v,
                        width: 24.h,
                        color: theme.colorScheme.primary.withOpacity(1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.v),
                        child: Text(
                          bottomMenuList[index].title ?? "",
                          style: CustomTextStyles.labelMediumPrimary.copyWith(
                            color: theme.colorScheme.primary.withOpacity(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: '',
                );
              }
            }),
            onTap: (index) {
              selectedIndex = index;
              widget.onChanged?.call(bottomMenuList[index].type);
              setState(() {});
              navigateToPage(bottomMenuList[index].type);
            },
          ),
        ),
      ],
    );
  }

  void navigateToPage(BottomBarEnum type) {
    final route = getCurrentRoute(type);
    Navigator.pushNamed(context, route);
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

enum BottomBarEnum {
  Home,
  Explore,
  Cart,
  Offer,
  Account,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
