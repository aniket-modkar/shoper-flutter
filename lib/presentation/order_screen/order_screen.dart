import 'dart:convert';

import 'package:shoper_flutter/core/service/api_service.dart';

import '../order_screen/widgets/orderlist_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';

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

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
        final response =
            await _apiService.fetchData('api/v1/order/customerOrders');
        if (response.statusCode == 202) {
          if (mounted) {
            setState(() {
              fetchedData = FetchedData.fromJson(json.decode(response.body));
              isDataFetched = true;
            });
          }
        } else {
          // Handle non-200 status code
          print('Error: ${response.statusCode}');
        }
      } catch (error) {
        // Handle errors
        print('Error: $error');
        if (mounted) {
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
      List<dynamic> orders = fetchedData.result;

      if (orders.isNotEmpty) {
        var order = orders.first;

        return SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: Padding(
              padding: EdgeInsets.only(left: 15.h, top: 19.v, right: 15.h),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.v);
                },
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  var order = orders[index];
                  return OrderlistItemWidget(
                    order: order,
                  );
                },
              ),
            ),
          ),
        );
      }
    }

    // If fetchedData is null or has no orders, return an empty container
    return Container();
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 40.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeftBlueGray300,
            margin: EdgeInsets.only(left: 16.h, top: 15.v, bottom: 16.v),
            onTap: () {
              onTapArrowLeft(context);
            }),
        title: AppbarSubtitle(
            text: "lbl_order".tr, margin: EdgeInsets.only(left: 12.h)));
  }

  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
