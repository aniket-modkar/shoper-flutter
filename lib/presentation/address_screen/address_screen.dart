import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/add_address_screen/add_address_screen.dart';
import 'package:shoper_flutter/presentation/address_screen/widgets/addresslist_item_widget.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';

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

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;
  late MediaQueryData mediaQueryData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await _apiService.fetchData('api/v1/address/fetch');
      if (response.statusCode == 200) {
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
            result: {},
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

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: Column(
            children: [
              SizedBox(height: 17.v),
              _buildAddressList(context),
            ],
          ),
        ),
        bottomNavigationBar: _buildAddAddress(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftBlueGray300,
        margin: EdgeInsets.only(left: 16.h, top: 15.v, bottom: 16.v),
        onTap: () {
          onTapArrowLeft(context);
        },
      ),
      title: AppbarSubtitle(
        text: "lbl_address".tr,
        margin: EdgeInsets.only(left: 12.h),
      ),
    );
  }

  Widget _buildAddressList(BuildContext context) {
    if (fetchedData.result.containsKey('addresses')) {
      dynamic addressData = fetchedData.result['addresses'];
      if (addressData is List) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 18.v);
              },
              itemCount: addressData.length,
              itemBuilder: (context, index) {
                return AddresslistItemWidget(
                  addressData: addressData[index],
                  onChanged: () {
                    fetchData();
                    print('item onchanged');
                  },
                );
              },
            ),
          ),
        );
      } else {
        return _buildErrorWidget("Unexpected data type for 'address'");
      }
    } else {
      return _buildErrorWidget("address key not found.");
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

  Widget _buildAddAddress(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_add_address".tr,
      margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 50.v),
      onPressed: () {
        navigateToAddressScreen(context);
      },
    );
  }

  void navigateToAddressScreen(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.addAddressScreen);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddAddressScreen(
                  addressData: null,
                  onChanged: () {
                    fetchData();
                  },
                )));
  }

  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
