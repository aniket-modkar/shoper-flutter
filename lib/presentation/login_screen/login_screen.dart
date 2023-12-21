import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/dashboard_page/dashboard_page.dart';
import 'package:shoper_flutter/presentation/register_screen/register_screen.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';
import 'package:shoper_flutter/widgets/custom_outlined_button.dart';
import 'package:shoper_flutter/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  LoginScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

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
                    padding:
                        EdgeInsets.only(left: 16.h, top: 68.v, right: 16.h),
                    child: Column(children: [
                      _buildPageHeader(context),
                      SizedBox(height: 28.v),
                      CustomTextFormField(
                          controller: emailController,
                          hintText: "lbl_your_email".tr,
                          textInputType: TextInputType.emailAddress,
                          prefix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
                              child: CustomImageView(
                                  imagePath: ImageConstant.imgMail,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize)),
                          prefixConstraints: BoxConstraints(maxHeight: 48.v),
                          contentPadding: EdgeInsets.only(
                              top: 15.v, right: 30.h, bottom: 15.v)),
                      SizedBox(height: 10.v),
                      CustomTextFormField(
                          controller: passwordController,
                          hintText: "lbl_password".tr,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          prefix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(16.h, 12.v, 10.h, 12.v),
                              child: CustomImageView(
                                  imagePath: ImageConstant.imgLock,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize)),
                          prefixConstraints: BoxConstraints(maxHeight: 48.v),
                          obscureText: true,
                          contentPadding: EdgeInsets.only(
                              top: 15.v, right: 30.h, bottom: 15.v)),
                      SizedBox(height: 16.v),
                      CustomElevatedButton(
                          text: "lbl_sign_in".tr,
                          onPressed: () {
                            onTapSignIn(context);
                          }),
                      SizedBox(height: 18.v),
                      _buildOrLine(context),
                      SizedBox(height: 16.v),
                      _buildSocialAuthentication(context),
                      SizedBox(height: 17.v),
                      Text("msg_forgot_password".tr,
                          style: CustomTextStyles.labelLargePrimary),
                      SizedBox(height: 7.v),
                      GestureDetector(
                          onTap: () {
                            onTapTxtDonthaveanaccount(context);
                          },
                          child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "msg_don_t_have_an_account2".tr,
                                    style: theme.textTheme.bodySmall),
                                TextSpan(text: " "),
                                TextSpan(
                                    text: "lbl_register".tr,
                                    style: CustomTextStyles.labelLargePrimary_1)
                              ]),
                              textAlign: TextAlign.left)),
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
      Text("msg_welcome_to_e_com".tr, style: theme.textTheme.titleMedium),
      SizedBox(height: 10.v),
      Text("msg_sign_in_to_continue".tr, style: theme.textTheme.bodySmall)
    ]);
  }

  /// Section Widget
  Widget _buildOrLine(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: EdgeInsets.only(top: 10.v, bottom: 9.v),
          child: SizedBox(width: 134.h, child: Divider())),
      Text("lbl_or".tr, style: CustomTextStyles.titleSmallBluegray300_1),
      Padding(
          padding: EdgeInsets.only(top: 10.v, bottom: 9.v),
          child: SizedBox(width: 137.h, child: Divider()))
    ]);
  }

  /// Section Widget
  Widget _buildSocialAuthentication(BuildContext context) {
    return Column(children: [
      CustomOutlinedButton(
          text: "msg_login_with_google".tr,
          leftIcon: Container(
              margin: EdgeInsets.only(right: 30.h),
              child: CustomImageView(
                  imagePath: ImageConstant.imgGoogleIcon,
                  height: 24.adaptSize,
                  width: 24.adaptSize))),
      SizedBox(height: 8.v),
      CustomOutlinedButton(
          text: "msg_login_with_facebook".tr,
          leftIcon: Container(
              margin: EdgeInsets.only(right: 30.h),
              child: CustomImageView(
                  imagePath: ImageConstant.imgFacebookIcon,
                  height: 24.adaptSize,
                  width: 24.adaptSize)))
    ]);
  }

  Future<void> onTapSignIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        // 'email': emailController.text,
        // 'password': passwordController.text
        'email': 'admin@gmail.com',
        'password': '12345678'
      };
      try {
        final postData = userData;
        final response =
            await _apiService.postData('api/v1/account/login', postData);

        if (response.statusCode == 200) {
          // Successful login
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        } else {
          // Display an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please check your credentials.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (error) {
        print('Error: $error');
        // Display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void onTapTxtDonthaveanaccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
