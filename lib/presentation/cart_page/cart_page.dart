import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/address_screen/address_screen.dart';
import 'package:shoper_flutter/presentation/cart_page/widgets/cartlist_item_widget.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
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

class FetchedAddressData {
  final String message;
  final String responseCode;
  final Map<String, dynamic> result;
  final int totalCounts;
  final int statusCode;

  FetchedAddressData({
    required this.message,
    required this.responseCode,
    required this.result,
    required this.totalCounts,
    required this.statusCode,
  });

  factory FetchedAddressData.fromJson(Map<String, dynamic> json) {
    return FetchedAddressData(
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
  late FetchedAddressData fetchedAddressData;

  bool isDataFetched = false;
  bool isAddressDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAddressData();
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

  Future<void> fetchAddressData() async {
    if (!isAddressDataFetched) {
      try {
        final response = await _apiService.fetchData('api/v1/address/fetch');
        if (response.statusCode == 200) {
          if (mounted) {
            setState(() {
              fetchedAddressData =
                  FetchedAddressData.fromJson(json.decode(response.body));
              isAddressDataFetched = true;
            });
          }
        }
      } catch (error) {
        // Handle errors
        if (mounted) {
          setState(() {
            fetchedAddressData = FetchedAddressData(
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
              // _buildAddressList(context),
              // SizedBox(height: 20.v),
              _buildAddressSelection(context),
              SizedBox(height: 20.v),
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
      leadingWidth: 40.h,
      // leading: AppbarLeadingImage(
      //   imagePath: ImageConstant.imgArrowLeftBlueGray300,
      //   margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 15.v),
      //   onTap: () => onTapArrowLeft(context),
      // ),
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

  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
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

  Widget _buildAddressSelection(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showAddressSelectionDialog(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Set the button color
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Text(
        "Select Address",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white, // Set the text color
        ),
      ),
    );
  }

  void _showAddressSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (fetchedAddressData.result.containsKey('addresses')) {
          dynamic addressData = fetchedAddressData.result['addresses'];

          if (addressData is List && addressData.isNotEmpty) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          children: [
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 12.v);
                              },
                              itemCount: addressData.length,
                              itemBuilder: (context, index) {
                                return AddresslistItemSelectionWidget(
                                  addressData: addressData[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Display "Add Address" button when there are no addresses
            return Container(
              padding: EdgeInsets.all(16),
              child: buildAddAddressButton(context),
            );
          }
        } else {
          return Container(
            padding: EdgeInsets.all(16),
            child: _buildErrorWidget("Address key not found."),
          );
        }
      },
    );
  }

  Widget buildAddAddressButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add logic to navigate or perform actions for adding an address
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressScreen()),
        );
      },
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the children horizontally
        children: [
          Text(
            "Add Address",
            style: TextStyle(
              // Add default styling here
              fontSize: 16.0, // Example font size, adjust as needed
              fontWeight: FontWeight.bold,
              color: Colors.white, // Example text color, adjust as needed
            ),
          ),
          SizedBox(width: 8.h), // Adjust the spacing if needed
        ],
      ),
      style: ElevatedButton.styleFrom(
          // Add styling properties if needed
          ),
    );
  }

  Widget _buildTotalPriceDetailsColumn(BuildContext context) {
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
                children: [],
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
                priceLabel: "₹ 00.00".tr,
              ),
              SizedBox(height: 14.v),
              Divider(),
              _buildShoppingPriceRow(
                context,
                shippingLabel: "lbl_import_charges".tr,
                priceLabel: " ₹ 00.00".tr,
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

  void onTapCheckOut(BuildContext context) async {
    try {
      final response =
          await _apiService.postDataWithoutBody('api/v1/order/create');
      if (response.statusCode == 202) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String orderId = responseData['result']['orderId'];
        Navigator.pushNamed(
          context,
          AppRoutes.orderDetailsScreen,
          arguments: {'orderId': orderId},
        );
      }
    } catch (error) {
      showSnackBar(context, 'An error occurred. Please try again later.');
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

  void onTapNotificationIcon(BuildContext context) {
    // Implement your notification icon tap logic
  }
}

class AddresslistItemSelectionWidget extends StatelessWidget {
  final dynamic addressData;
  final ApiService _apiService = ApiService();

  AddresslistItemSelectionWidget({Key? key, required this.addressData})
      : super(key: key);
  Widget build(BuildContext context) {
    final Map<String, dynamic> countryId = addressData['countryId'];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 23.h,
        vertical: 21.v,
      ),
      decoration: AppDecoration.outlinePrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${addressData['firstName']} ${addressData['lastName']}".tr,
            style: theme.textTheme.titleSmall, // Make sure 'theme' is defined
          ),
          SizedBox(height: 19.v),
          Container(
            width: 264.h,
            margin: EdgeInsets.only(right: 30.h),
            child: Text(
              "Type: ${addressData['type']}".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(
                height: 1.80,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Text(
            "${addressData['address1']} ${addressData['city']},${addressData['postalCode']}"
                .tr,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 19.v),
          Text(
            "Country Name: ${countryId['displayName']}",
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 19.v),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  onSelectPressed(context, addressData['_id']);
                },
                child: Text(
                  "Select Address".tr,
                  style: CustomTextStyles.titleSmallPrimary,
                ),
              ),
              SizedBox(width: 32.h),
            ],
          )
        ],
      ),
    );
  }

  void onSelectPressed(BuildContext context, String address) async {
    try {
      final userData = {
        'billingAddressId': address,
        'shippingAddressId': address
      };
      final response =
          await _apiService.postData('api/v1/cart/setAddress', userData);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, AppRoutes.cartPage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed. Please check.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
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
