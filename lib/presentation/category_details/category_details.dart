import 'dart:convert';

import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/dashboard_page/widgets/dashboard_item_widget.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';

import '../search_result_screen/widgets/searchresult_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_title_edittext_one.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';

// ignore_for_file: must_be_immutable
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
} // ignore_for_file: must_be_immutable

class CategoryDetailsScreen extends StatefulWidget {
  CategoryDetailsScreen({Key? key}) : super(key: key);
  @override
  _CategoryDetailsScreen createState() => _CategoryDetailsScreen();
}

class _CategoryDetailsScreen extends State<CategoryDetailsScreen> {
  final ApiService _apiService = ApiService();
  int sliderIndex = 1;
  late FetchedData fetchedData;
  bool isDataFetched = false;
  String categoryName = '';
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Accessing the arguments and calling fetchData
      if (context != null) {
        Map<String, dynamic>? arguments =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        if (arguments != null && arguments.containsKey('categoryId')) {
          String categoryId = arguments['categoryId'];
          categoryName = arguments['categoryName'];
          // Await the fetchData method
          fetchData(categoryId: categoryId);
        } else {
          fetchData();
        }
      }
    });
  }

  Future<void> fetchData({String categoryId = ''}) async {
    if (!isDataFetched) {
      final userData = {
        'status': "PUBLISHED",
        if (categoryId.isNotEmpty) 'categoriesId': categoryId
      };
      try {
        final response = await _apiService.fetchDataWithFilter(
            'api/v1/product/fetch', userData);
        if (response.statusCode == 200) {
          setState(() {
            fetchedData = FetchedData.fromJson(json.decode(response.body));
          });
        } else {
          // Handle non-200 status code responses
          // For example: Show a snackbar with an error message
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
        }
      } catch (error) {
        // Handle errors
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
      isDataFetched = true;
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
    return SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(context),
            body: SizedBox(
                width: mediaQueryData.size.width,
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 27.v),
                    child: Padding(
                        padding: EdgeInsets.only(left: 16.h, bottom: 5.v),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              SizedBox(height: 15.v),
                              _buildResultCounter(context),
                              SizedBox(height: 16.v),
                              _buildDashboard(context),
                              SizedBox(height: 16.v),
                            ]))))));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 40.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeftBlueGray300,
            margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 15.v),
            onTap: () {
              onTapArrowLeft(context);
            }),
        title: AppbarTitleEdittextOne(
            margin: EdgeInsets.only(left: 16.h),
            hintText: "${categoryName}".tr,
            controller: searchController),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgSort,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 16.h),
              onTap: () {
                onTapSort(context);
              }),
          AppbarTrailingImage(
              imagePath: ImageConstant.imgFilter,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 32.h),
              onTap: () {
                onTapFilter(context);
              })
        ]);
  }

  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  /// Section Widget
  Widget _buildResultCounter(BuildContext context) {
    if (fetchedData.result.containsKey('products')) {
      dynamic products = fetchedData.result['products'];
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                    opacity: 0.5,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 4.v),
                        child: Text("${products.length} result".tr,
                            style: CustomTextStyles.labelLargeOnPrimary))),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(top: 2.v, bottom: 3.v),
                    child: Text("${categoryName}".tr,
                        style: theme.textTheme.labelLarge)),
                CustomImageView(
                    imagePath: ImageConstant.imgDownIcon,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    margin: EdgeInsets.only(left: 8.h))
              ]));
    } else {
      return _buildErrorWidget("product key not found.");
    }
  }

  /// Section Widget
  Widget _buildDashboard(BuildContext context) {
    if (fetchedData.result.containsKey('products')) {
      dynamic products = fetchedData.result['products'];
      if (products.length > 0) {
        if (products is List) {
          return Padding(
              padding: EdgeInsets.only(
                right: 16.h,
              ),
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 283.v,
                      crossAxisCount: 2,
                      mainAxisSpacing: 13.h,
                      crossAxisSpacing: 13.h),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return DashboardItemWidget(product: products[index]);
                  }));
        } else {
          return _buildErrorWidget("Unexpected data type for 'Product'");
        }
      } else {
        return Center(
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(16.0), // Adjust padding as needed
            child: Text(
              'No product found',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      return _buildErrorWidget("product key not found.");
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

  void onTapFilter(BuildContext context) {}

  void onTapSort(BuildContext context) {}
}
