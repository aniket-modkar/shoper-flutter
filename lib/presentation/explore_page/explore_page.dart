import 'dart:convert';

import 'package:shoper_flutter/core/service/api_service.dart';

import 'package:shoper_flutter/widgets/custom_bottom_bar.dart';

import '../explore_page/widgets/manworkequipment_item_widget.dart';
import '../explore_page/widgets/womantshirticon_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_title_searchview.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';

// ignore_for_file: must_be_immutable

class FetchedData {
  final String message;
  final String responseCode;
  final List<Map<String, dynamic>> result; // Specify List<Map<String, dynamic>>
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
      result:
          (json['result'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
              [], // Explicitly cast to List<Map<String, dynamic>>
      totalCounts: json['totalCounts'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'FetchedData { message: $message, responseCode: $responseCode, result: $result, totalCounts: $totalCounts, statusCode: $statusCode }';
  }
}

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String currentRoute = AppRoutes.explorePage;
  TextEditingController searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;

  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!isDataFetched) {
      try {
        final response = await _apiService
            .fetchData('api/v1/product_category/fetchCategories');
        if (response.statusCode == 200) {
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
            result: [],
            totalCounts: 0,
            statusCode: 0,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    if (!isDataFetched) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (fetchedData != null && fetchedData.result != null) {
      List<dynamic> categories = fetchedData.result;

      if (categories.isNotEmpty) {
        return SafeArea(
            child: Scaffold(
          appBar: _buildAppBar(context),
          body: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 25.v),
              child: Column(children: [
                _buildCategories(context, categories),
                SizedBox(height: 37.v),
                // _buildWomanFashion(context),
                // SizedBox(height: 5.v)
              ])),
          bottomNavigationBar: CustomBottomBar(
            currentRoute: currentRoute,
            onChanged: (BottomBarEnum type) {
              setState(() {
                currentRoute = getCurrentRoute(type);
              });
            },
          ),
        ));
      }
    }
    return Container();
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        title: AppbarTitleSearchview(
            margin: EdgeInsets.only(left: 16.h),
            hintText: "lbl_search_product".tr,
            controller: searchController),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgDownload,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 16.h)),
          Container(
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 32.h),
              child: Stack(alignment: Alignment.topRight, children: [
                CustomImageView(
                    imagePath: ImageConstant.imgNotificationIcon,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.center,
                    onTap: () {
                      onTapImgNotificationIcon(context);
                    }),
                CustomImageView(
                    imagePath: ImageConstant.imgClosePink300,
                    height: 8.adaptSize,
                    width: 8.adaptSize,
                    alignment: Alignment.topRight,
                    margin:
                        EdgeInsets.only(left: 14.h, right: 2.h, bottom: 16.v))
              ]))
        ]);
  }

  /// Section Widget
  Widget _buildCategories(BuildContext context, List<dynamic> categories) {
    String baseUrl = _apiService.imgBaseUrl;
    if (categories.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          var subCategories = category['Childs'];
          var categoryName = toTitleCase(category['name']);
          String imageUrl = baseUrl + (category['categoryImg'] as String);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomImageView(
                    imagePath: imageUrl,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.topLeft,
                    onTap: () {
                      onTapImgNotificationIcon(context);
                    },
                  ),
                  SizedBox(width: 8.h), // Adjust spacing as needed
                  Text(
                    "${categoryName}".tr,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              SizedBox(height: 13.v),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 94.v,
                  crossAxisCount: 4,
                  mainAxisSpacing: 21.h,
                  crossAxisSpacing: 21.h,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: subCategories.length,
                itemBuilder: (context, subIndex) {
                  var subCategory = subCategories[subIndex];
                  return ManworkequipmentItemWidget(category: subCategory);
                },
              ),
            ],
          );
        },
      );
    } else {
      return _buildErrorWidget("Unexpected data type for 'Category'");
    }
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(
        'Error: $errorMessage',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  /// Section Widget
  Widget _buildWomanFashion(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("lbl_woman_fashion".tr, style: theme.textTheme.titleSmall),
      SizedBox(height: 13.v),
      GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 93.v,
              crossAxisCount: 4,
              mainAxisSpacing: 21.h,
              crossAxisSpacing: 21.h),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) {
            return WomantshirticonItemWidget();
          })
    ]);
  }

  void onTapImgNotificationIcon(BuildContext context) {}
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

  String toTitleCase(String text) {
    if (text == null || text.isEmpty) {
      return '';
    }

    return text.split(' ').map((word) {
      if (word.isEmpty) {
        return '';
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
