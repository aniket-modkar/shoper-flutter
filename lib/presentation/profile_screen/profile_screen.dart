import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';
import 'package:shoper_flutter/presentation/profile_screen/widgets%20/circle.dart';
import 'package:shoper_flutter/presentation/profile_screen/widgets%20/profile_image.dart';
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

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;
  bool isError = false;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    fetchData();
    // for animation
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.forward();
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
          String phone = firstProfile['phone'] ?? '*****000';
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
                                        Padding(
                                          padding: EdgeInsets.only(left: 16.h),
                                          child: ProfileImage(
                                            imagePath: completeImagePath,
                                            radius: BorderRadius.circular(36.h),
                                            animationController: _controller,
                                          ),
                                        ),
                                        // ProfileImage(
                                        //   imagePath: completeImagePath,
                                        //   radius: BorderRadius.circular(48.h),
                                        // ),
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
                                  birthDateValue: "${phone}".tr),
                              SizedBox(height: 5.v),
                              _buildProfileDetailOption(context,
                                  dateIcon: ImageConstant.imgLockPrimary,
                                  birthdayText: "lbl_change_password".tr,
                                  birthDateValue: "msg".tr,
                                  onTapProfileDetailOption: () {
                                onTapPasswordUpdateOption(context);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void onTapPasswordUpdateOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Update Password",
            style: TextStyle(color: const Color.fromARGB(255, 43, 41, 41)),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // Assign the form key to the Form widget
              child: Column(
                children: [
                  _buildPasswordField(),
                  SizedBox(height: 20),
                  _buildConfirmPasswordField(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Logic for cancel button
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Color.fromARGB(255, 12, 68, 56)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form before updating password
                if (_formKey.currentState!.validate()) {
                  onUpdatePassword(context);
                }
              },
              child: Text(
                "Confirm",
                style: TextStyle(color: Color.fromARGB(255, 12, 68, 56)),
              ),
            ),
          ],
        );
      },
    );
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "OldPassword"),
      obscureText: true,
      controller: oldPasswordController,
      // Add any necessary validation logic
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "New Password"),
      obscureText: true,
      controller: newPasswordController,

      // Add any necessary validation logic
    );
  }

  Future<void> onUpdatePassword(BuildContext context) async {
    final userData = {
      'oldPassword': oldPasswordController.text,
      'newPassword': newPasswordController.text,
    };
    try {
      final response =
          await _apiService.postData('api/v1/account/changePassword', userData);
      if (response.statusCode == 202) {
        showSnackBar(context, 'Password Successfully Updated.');
        Navigator.of(context).pop();
      } else {
        // Handle other status codes (e.g., 4xx, 5xx) by displaying an error message
        showSnackBar(context,
            'An error occurred (${response.statusCode}). Please try again later.');
      }
    } catch (error) {
      // Display an error message
      showSnackBar(context, 'An error occurred. Please try again later.');
      print('Error: $error');
    }
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ),
  );
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
