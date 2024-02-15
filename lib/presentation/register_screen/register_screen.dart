import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/login_screen/login_screen.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';
import 'package:shoper_flutter/widgets/custom_text_form_field.dart';

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
}

class DropdownMenu<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;

  DropdownMenu({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T?>(
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;
  Map<String, dynamic>? selectedCountry;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordController1 = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fetchCountryData();
  }

  Future<void> fetchCountryData() async {
    if (!isDataFetched) {
      try {
        final response = await _apiService.fetchData('api/v1/country/fetch');
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
    } else {
      return SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Form(
                  key: _formKey,
                  child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPageHeader(context),
                            SizedBox(height: 30.v),
                            _buildCountry(context),
                            SizedBox(height: 23.v),
                            _buildFirstName(context),
                            SizedBox(height: 8.v),
                            _buildLastName(context),
                            SizedBox(height: 8.v),
                            _buildMobile(context),
                            SizedBox(height: 8.v),
                            _buildEmail(context),
                            SizedBox(height: 8.v),
                            _buildPassword(context),
                            SizedBox(height: 8.v),
                            _buildPassword1(context),
                            SizedBox(height: 20.v),
                            _buildSignUp(context),
                            SizedBox(height: 20.v),
                            GestureDetector(
                              onTap: () {
                                onTapTxtDonthaveanaccount(context);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "msg_have_an_account2".tr,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    TextSpan(text: " "),
                                    TextSpan(
                                      text: "lbl_sign_in".tr,
                                      style:
                                          CustomTextStyles.labelLargePrimary_1,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 5.v)
                          ])))));
    }
  }

  /// Section Widget
  Widget _buildPageHeader(BuildContext context) {
    return Column(children: [
      CustomIconButton(
          height: 72.adaptSize,
          width: 72.adaptSize,
          padding: EdgeInsets.all(20.h),
          decoration: IconButtonStyleHelper.fillPrimary,
          child: CustomImageView(imagePath: ImageConstant.imgClose)),
      SizedBox(height: 16.v),
      Text("msg_let_s_get_started".tr, style: theme.textTheme.titleMedium),
      SizedBox(height: 9.v),
      Text("msg_create_an_new_account".tr, style: theme.textTheme.bodySmall)
    ]);
  }

  /// Section Widget
  Widget _buildFirstName(BuildContext context) {
    return CustomTextFormField(
        controller: firstNameController,
        hintText: "lbl_first_name".tr,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgUser,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v),
        contentPadding: EdgeInsets.only(top: 15.v, right: 30.h, bottom: 15.v));
  }

  /// Section Widget
  Widget _buildLastName(BuildContext context) {
    return CustomTextFormField(
        controller: lastNameController,
        hintText: "lbl_last_name".tr,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgUser,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v),
        contentPadding: EdgeInsets.only(top: 15.v, right: 30.h, bottom: 15.v));
  }

  /// Section Widget
  Widget _buildMobile(BuildContext context) {
    return CustomTextFormField(
      controller: mobileController,
      hintText: "Mobile".tr,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgUser, // Update with the correct path
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      prefixConstraints: BoxConstraints(maxHeight: 48.v),
      contentPadding: EdgeInsets.only(top: 15.v, right: 30.h, bottom: 15.v),
    );
  }

  /// Section Widget
  Widget _buildCountry(BuildContext context) {
    List<Map<String, dynamic>> countries = [];
    Map<String, dynamic>? selectedType;
    if (fetchedData.result.containsKey('countries')) {
      countries =
          List<Map<String, dynamic>>.from(fetchedData.result['countries']);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("msg_country_or_region".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 11.v),
        DropdownButtonFormField<Map<String, dynamic>>(
          value: selectedType,
          onChanged: (Map<String, dynamic>? newValue) {
            if (newValue != null) {
              setState(() {
                selectedType = newValue;
                countryController.text = newValue['_id'].toString();
              });
            }
          },
          items: countries
              .map<DropdownMenuItem<Map<String, dynamic>>>(
                  (country) => DropdownMenuItem<Map<String, dynamic>>(
                        value: country,
                        child: Text(country['displayName']),
                      ))
              .toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.v, horizontal: 12.h),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
        controller: emailController,
        hintText: "lbl_your_email".tr,
        textInputType: TextInputType.emailAddress,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgMail,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v),
        contentPadding: EdgeInsets.only(top: 15.v, right: 30.h, bottom: 15.v));
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController,
        hintText: "lbl_password".tr,
        textInputType: TextInputType.visiblePassword,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgLock,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v),
        obscureText: true,
        contentPadding: EdgeInsets.only(top: 15.v, right: 30.h, bottom: 15.v));
  }

  /// Section Widget
  Widget _buildPassword1(BuildContext context) {
    return CustomTextFormField(
        controller: passwordController1,
        hintText: "lbl_password_again".tr,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgLock,
                height: 24.adaptSize,
                width: 24.adaptSize)),
        prefixConstraints: BoxConstraints(maxHeight: 48.v),
        obscureText: true,
        contentPadding: EdgeInsets.only(top: 15.v, right: 30.h, bottom: 15.v));
  }

  /// Section Widget
  Widget _buildSignUp(BuildContext context) {
    return CustomElevatedButton(
        text: "lbl_sign_up".tr,
        onPressed: () {
          onTapSignUp(context);
        });
  }

  Future<void> onTapSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != passwordController1.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password and confirm password do not match.'),
          ),
        );
        return;
      }
      if (fetchedData.result.containsKey('countries')) {
        dynamic countries = fetchedData.result['countries'];

        TextEditingController countryController =
            TextEditingController(text: countries[1]['_id']);
        final userData = {
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'phone': mobileController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'country': countryController.text
        };
        try {
          final response = await _apiService.postData(
              'api/v1/account/customerRegister', userData);

          if (response.statusCode == 201) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration failed. Please try again.'),
              ),
            );
          }
        } catch (error) {}
      }
    }
  }

  void onTapTxtDonthaveanaccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
