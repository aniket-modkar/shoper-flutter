import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/login_screen/login_screen.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';
import 'package:shoper_flutter/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class RegisterScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();
  RegisterScreen({Key? key}) : super(key: key);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordController1 = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
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
                          _buildFirstName(context),
                          SizedBox(height: 8.v),
                          _buildLastName(context),
                          SizedBox(height: 8.v),
                          _buildMobile(context),
                          SizedBox(height: 8.v),
                          _buildCountry(context),
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
                                    style: CustomTextStyles.labelLargePrimary_1,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 5.v)
                        ])))));
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
      hintText: "lbl_mobile".tr,
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
    return CustomTextFormField(
      controller: countryController,
      hintText: "lbl_country".tr,
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
          // Registration successful, navigate to login page
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          // Handle other status codes or display error messages
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed. Please try again.'),
            ),
          );
        }
      } catch (error) {
        print('Error: $error');
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
