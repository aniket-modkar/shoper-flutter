import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';

class FetchedData {
  final String message;
  final String responseCode;
  final List<Map<String, dynamic>> result;
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
      result: (json['result'] is List<dynamic>)
          ? (json['result'] as List<dynamic>)
              .map((item) => item is Map<String, dynamic>
                  ? item
                  : <String,
                      dynamic>{}) // Explicit casting to Map<String, dynamic>
              .toList()
          : [json['result'] ?? <String, dynamic>{}], // Handle object case
      totalCounts: json['totalCounts'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }
  @override
  String toString() {
    return 'FetchedData { message: $message, responseCode: $responseCode, result: $result, totalCounts: $totalCounts, statusCode: $statusCode }';
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!isDataFetched && !isError) {
      try {
        final response =
            await _apiService.fetchData('api/v1/account/fetchProfile');
        if (response.statusCode == 200) {
          if (mounted) {
            setState(() {
              fetchedData = FetchedData.fromJson(json.decode(response.body));
              isDataFetched = true;
            });
          }
        } else {
          handleNon200StatusCode(response.statusCode);
        }
      } catch (error) {
        handleError(error);
      }
    }
  }

  void handleNon200StatusCode(int statusCode) {
    // Handle non-200 status code
    print('Error: $statusCode');
    setState(() {
      isError = true;
    });
  }

  void handleError(dynamic error) {
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
        isError = true;
      });
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
    } else {
      String baseUrl = _apiService.imgBaseUrl;

      if (fetchedData != null && fetchedData.result != null) {
        List<dynamic> profiles = fetchedData.result;

        if (profiles.isNotEmpty) {
          Map<String, dynamic> firstProfile = profiles.first;

          String imagePath = firstProfile['media'] ?? '';
          String completeImagePath = baseUrl + imagePath;
          String completeName =
              firstProfile['firstName'] + firstProfile['lastName'] ?? '';
          String email = firstProfile['email'] ?? '';
          if (profiles.isNotEmpty) {
            return SafeArea(
                child: Scaffold(
                    appBar: _buildAppBar(context),
                    body: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(vertical: 36.v),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 16.h),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomImageView(
                                            imagePath: completeImagePath,
                                            height: 72.adaptSize,
                                            width: 72.adaptSize,
                                            radius:
                                                BorderRadius.circular(36.h)),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.h,
                                                top: 9.v,
                                                bottom: 14.v),
                                            child: Column(children: [
                                              Text("${completeName}".tr,
                                                  style: theme
                                                      .textTheme.titleSmall),
                                              SizedBox(height: 8.v),
                                              Text("@${completeName}".tr,
                                                  style:
                                                      theme.textTheme.bodySmall)
                                            ]))
                                      ])),
                              SizedBox(height: 32.v),
                              _buildProfileDetailOption(context,
                                  dateIcon: ImageConstant.imgGenderIcon,
                                  birthdayText: "lbl_gender".tr,
                                  birthDateValue: "lbl_male".tr),
                              _buildProfileDetailOption(context,
                                  dateIcon: ImageConstant.imgDateIcon,
                                  birthdayText: "lbl_birthday".tr,
                                  birthDateValue: "lbl_12_12_2000".tr),
                              _buildProfileDetailOption(context,
                                  dateIcon: ImageConstant.imgMailPrimary,
                                  birthdayText: "lbl_email".tr,
                                  birthDateValue: "${email}".tr),
                              _buildProfileDetailOption(context,
                                  dateIcon: ImageConstant.imgCreditCardIcon,
                                  birthdayText: "lbl_phone_number".tr,
                                  birthDateValue: "lbl_307_555_0133".tr),
                              SizedBox(height: 5.v),
                              _buildProfileDetailOption(context,
                                  dateIcon: ImageConstant.imgLockPrimary,
                                  birthdayText: "lbl_change_password".tr,
                                  birthDateValue: "msg".tr,
                                  onTapProfileDetailOption: () {
                                onTapProfileDetailOption(context);
                              }),
                              SizedBox(height: 50.v),
                              _buildLogoutButton(
                                context,
                              ),
                            ]))));
          }
        }
      }
    }
    return Container();
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
        title: AppbarSubtitle(
            text: "lbl_profile".tr, margin: EdgeInsets.only(left: 12.h)));
  }

  /// Common widget
  Widget _buildProfileDetailOption(
    BuildContext context, {
    required String dateIcon,
    required String birthdayText,
    required String birthDateValue,
    Function? onTapProfileDetailOption,
  }) {
    return GestureDetector(
        onTap: () {
          onTapProfileDetailOption!.call();
        },
        child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 15.v),
            decoration: AppDecoration.fillOnPrimaryContainer,
            child: Row(children: [
              CustomImageView(
                  imagePath: dateIcon,
                  height: 24.adaptSize,
                  width: 24.adaptSize),
              Padding(
                  padding: EdgeInsets.only(left: 16.h, top: 3.v, bottom: 2.v),
                  child: Text(birthdayText,
                      style: theme.textTheme.labelLarge!.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(1)))),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(top: 2.v, bottom: 3.v),
                  child: Text(birthDateValue,
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: appTheme.blueGray300))),
              CustomImageView(
                  imagePath: ImageConstant.imgRightIcon,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(left: 16.h))
            ])));
  }

  void onTapProfileDetailOption(BuildContext context) {}
}

void onTapArrowLeft(BuildContext context) {
  Navigator.pop(context);
}

final StorageService _storageService = StorageService();

Widget _buildLogoutButton(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 15.v),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutConfirmationDialog(context);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // Set the background color of the button
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
        ), // Set the text color
      ),
    ),
  );
}

// ... existing code ...

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Pass context to the method
              _performLogout(context);
            },
            child: Text("Logout"),
          ),
        ],
      );
    },
  );
}

void _performLogout(BuildContext context) async {
  await _storageService.clearStorage();
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.loginScreen,
    (Route<dynamic> route) => false,
  );
}
