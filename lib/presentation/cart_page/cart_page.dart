import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/cart_page/widgets/cartlist_item_widget.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_title.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';
import 'package:shoper_flutter/widgets/custom_text_form_field.dart';

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

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 7.v),
          child: Column(
            children: [
              _buildCartList(context),
              SizedBox(height: 52.v),
              _buildCouponCodeRow(context),
              SizedBox(height: 16.v),
              _buildTotalPriceDetailsColumn(context),
              SizedBox(height: 16.v),
              CustomElevatedButton(
                text: "lbl_check_out".tr,
                onPressed: () {
                  onTapCheckOut(context);
                },
              ),
              SizedBox(height: 8.v),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: AppbarTitle(
        text: "lbl_your_cart".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgNotificationIcon,
          margin: EdgeInsets.fromLTRB(13.h, 15.v, 13.h, 16.v),
          onTap: () {
            onTapNotificationIcon(context);
          },
        ),
      ],
    );
  }

  Widget _buildCartList(BuildContext context) {
    if (fetchedData.result.containsKey('cart')) {
      dynamic cartData = fetchedData.result['cart'];

      if (cartData is List) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 16.v);
          },
          itemCount: cartData.length,
          itemBuilder: (context, index) {
            return CartlistItemWidget(cartData: cartData[index]);
          },
        );
      } else {
        return _buildErrorWidget("Unexpected data type for 'cart'");
      }
    } else {
      return _buildErrorWidget("Cart key not found.");
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

  Widget _buildCouponCodeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: TextEditingController(), // Use the provided controller
            hintText: "msg_enter_cupon_code".tr,
            textInputAction: TextInputAction.done,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.h, vertical: 19.v),
          ),
        ),
        CustomElevatedButton(
          width: 87.h,
          text: "lbl_apply".tr,
          buttonStyle: CustomButtonStyles.fillPrimary,
          buttonTextStyle: CustomTextStyles.labelLargeOnPrimaryContainer,
        ),
      ],
    );
  }

  Widget _buildTotalPriceDetailsColumn(BuildContext context) {
    print("Fetched Data: ${fetchedData.result}");

    if (fetchedData.result.containsKey('cart')) {
      dynamic cartData = fetchedData.result['cart'];

      if (cartData is List) {
        int cartTotal =
            int.tryParse(fetchedData.result['cartTotal']?.toString() ?? '0') ??
                0;

        return Column(
          children: [
            for (var cartEntry in cartData) _buildCartEntry(context, cartEntry),
            Container(
              padding: EdgeInsets.all(15.h),
              decoration: AppDecoration.outlineBlue50.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add other shopping price rows here
                  Divider(),
                  SizedBox(height: 10.v),
                  // _buildShoppingPriceRow(
                  //   context,
                  //   shippingLabel: "lbl_total_price".tr,
                  //   priceLabel: cartTotal.toString(),
                  // ),
                ],
              ),
            ),
          ],
        );
      } else {
        return _buildErrorWidget(
            "Unexpected data type for 'cartData': ${cartData.runtimeType}");
      }
    } else {
      return _buildErrorWidget("Cart key not found.");
    }
  }

  Widget _buildCartEntry(BuildContext context, dynamic cartEntry) {
    if (cartEntry is Map) {
      final List<dynamic>? products = cartEntry['products'] as List<dynamic>?;

      if (products != null) {
        int cartTotal =
            int.tryParse(fetchedData.result['cartTotal']?.toString() ?? '0') ??
                0;
        return Container(
          padding: EdgeInsets.all(15.h),
          decoration: AppDecoration.outlineBlue50.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildShoppingPriceRow(
                context,
                shippingLabel: "Total Cart item(${products.length})".tr,
                priceLabel: '₹ ${cartTotal.toString()}.00',
              ),
              SizedBox(height: 14.v),
              Divider(),

              _buildShoppingPriceRow(
                context,
                shippingLabel: "lbl_shipping".tr,
                priceLabel: "₹ 40.00".tr,
              ),
              SizedBox(height: 14.v),
              Divider(),
              _buildShoppingPriceRow(
                context,
                shippingLabel: "lbl_import_charges".tr,
                priceLabel: " ₹ 128.00".tr,
              ),
              SizedBox(height: 12.v),
              Divider(),
              _buildShoppingPriceRow(
                context,
                shippingLabel: "lbl_total_price".tr,
                priceLabel: '₹ ${cartTotal.toString()}.00',
              ),

              // Add other shopping price rows here
            ],
          ),
        );
      } else {
        return _buildErrorWidget("Products key not found or is not a list");
      }
    } else {
      return _buildErrorWidget(
          "Unexpected data type for 'cartEntry': ${cartEntry.runtimeType}");
    }
  }

  Widget _buildShoppingPriceRow(
    BuildContext context, {
    required String shippingLabel,
    required String priceLabel,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.v),
          child: Text(
            shippingLabel,
            style: theme.textTheme.bodySmall!.copyWith(
              color: appTheme.blueGray300,
            ),
          ),
        ),
        Text(
          priceLabel,
          style: CustomTextStyles.bodySmallOnPrimary.copyWith(
            color: theme.colorScheme.onPrimary.withOpacity(1),
          ),
        ),
      ],
    );
  }

  void onTapCheckOut(BuildContext context) {
    // Implement your checkout logic
  }

  void onTapNotificationIcon(BuildContext context) {
    // Implement your notification icon tap logic
  }

  Widget buildCartItemWidget(dynamic productData) {
    return ListTile(
      title: Text(productData['_id']),
      // Customize based on your product data structure
    );
  }
}
