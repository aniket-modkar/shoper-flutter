import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/address_screen/address_screen.dart';
import 'package:shoper_flutter/presentation/cart_page/widgets/cartlist_item_widget.dart';
import 'package:shoper_flutter/presentation/cart_page/widgets/coupon_item_list.dart';
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

class FetchedCouponData {
  final String message;
  final String responseCode;
  final Map<String, dynamic> result;
  final int totalCounts;
  final int statusCode;

  FetchedCouponData({
    required this.message,
    required this.responseCode,
    required this.result,
    required this.totalCounts,
    required this.statusCode,
  });

  factory FetchedCouponData.fromJson(Map<String, dynamic> json) {
    return FetchedCouponData(
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      result: json['result'] ?? {},
      totalCounts: json['totalCounts'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'FetchedCouponData { message: $message, responseCode: $responseCode, result: $result, totalCounts: $totalCounts, statusCode: $statusCode }';
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
  late FetchedCouponData fetchedCouponData;

  bool isCouponDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAddressData();
    fetchCouponData();
  }

  Future<void> fetchData() async {
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

  Future<void> fetchCouponData() async {
    if (!isCouponDataFetched) {
      try {
        final response = await _apiService.fetchData('api/v1/discount/fetch');
        if (response.statusCode == 200) {
          setState(() {
            fetchedCouponData =
                FetchedCouponData.fromJson(json.decode(response.body));
            isCouponDataFetched = true;
          });
        } else {
          // Handle non-200 status code, if needed
        }
      } catch (error) {
        setState(() {
          fetchedCouponData = FetchedCouponData(
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
    dynamic cartData = fetchedData.result['cart'];

    if (cartData != null) {
      final List<dynamic> products = cartData[0]['products'] ?? <dynamic>[];

      if (products.isNotEmpty) {
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
      } else {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 48.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Your Cart is empty!',
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } else {
      // Handle the case when 'cart' is null
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Text("Error: Cart data is null"),
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftBlueGray300,
        margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 15.v),
        onTap: () => onTapArrowLeft(context),
      ),
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
            return CartlistItemWidget(
              cartData: cartData[index],
              onChanged: () {
                fetchData();
              },
            );
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
    if (!isCouponDataFetched) {
      return _buildLoadingWidget();
    }
    if (fetchedData.result.containsKey('cart')) {
      dynamic cartData = fetchedData.result['cart'];

      if (cartData is List) {
        if (fetchedCouponData.result.containsKey('discounts')) {
          final couponData = fetchedCouponData.result['discounts'];
          if (couponData is List) {
            if (couponData.isEmpty) {
              return SizedBox(); // Return an empty widget if there are no coupons
            }
            // Cast couponData to List<Map<String, dynamic>>
            final List<Map<String, dynamic>> typedCouponData =
                couponData.cast<Map<String, dynamic>>();
            return GestureDetector(
              onTap: () {
                if (cartData[0]['discount'].isEmpty) {
                  _showCouponListModal(context, typedCouponData);
                } else {
                  // Do something when there is already a selected coupon
                  print('A coupon is already selected.');
                }
              },
              child: Container(
                width: double.infinity, // Set width to 100%
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 19.v),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cartData[0]['discount'].isEmpty
                          ? "Select Coupon"
                          : "Selected Coupon : ${cartData[0]['discount']['code']}",
                      style: TextStyle(
                        color: cartData[0]['discount'].isEmpty
                            ? Colors.blue
                            : Colors.red,
                      ),
                    ),
                    if (!cartData[0]['discount'].isEmpty)
                      IconButton(
                        icon: Icon(Icons.cancel),
                        color: Colors.red,
                        onPressed: () {
                          // Call your function to remove the selected coupon
                          _removeCouponFunction();
                        },
                      ),
                  ],
                ),
              ),
            );
          } else {
            return _buildErrorWidget("Unexpected data type for 'discounts'");
          }
        } else {
          return _buildErrorWidget("Discounts key not found.");
        }
      } else {
        return _buildErrorWidget("Unexpected data type for 'cart'");
      }
    } else {
      return _buildErrorWidget("Cart key not found.");
    }
  }

  void _showCouponListModal(
      BuildContext context, List<Map<String, dynamic>> coupons) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Coupons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: coupons.length,
                      itemBuilder: (context, index) {
                        final coupon = coupons[index];
                        return CouponListItem(
                          discount: coupon,
                          onPressed: () {
                            print(coupon);
                            onApplyingCoupon(
                                context, coupon); // Print the selected coupon
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _removeCouponFunction() async {
    // try {
    //   final userData = {
    //     'discountCode': coupon['code'],
    //     'discountId': coupon['_id']
    //   };
    //   final response = await _apiService.fetchDataWithFilter(
    //       'api/v1/discount/applyDiscount', userData);

    //   if (response.statusCode == 200) {
    //     // Navigator.pushNamed(context, AppRoutes.cartPage);
    //     showSnackBar(context, 'Coupon Successfully Applied.');
    //     Navigator.pop(context);
    //     fetchData();
    //   } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('in Discussion.'),
        duration: Duration(seconds: 3),
      ),
    );
    // }
    // } catch (error) {
    //   // Display an error message
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('An error occurred. Please try again later.'),
    //       duration: Duration(seconds: 3),
    //     ),
    //   );
    // }
  }

  void onApplyingCoupon(BuildContext context, dynamic coupon) async {
    try {
      final userData = {
        'discountCode': coupon['code'],
        'discountId': coupon['_id']
      };
      final response = await _apiService.fetchDataWithFilter(
          'api/v1/discount/applyDiscount', userData);

      if (response.statusCode == 200) {
        showSnackBar(context, 'Coupon Successfully Applied.');
        Navigator.pop(context);
        fetchData();
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

  Widget _buildLoadingWidget() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
      height: 100.0, // Adjust the height as needed
    );
  }

  Widget _buildAddressSelection(BuildContext context) {
    final dynamic addressData =
        fetchedData.result['cart'][0]['billingAddressId'];
    if (addressData != null) {
      final Map<String, dynamic> countryId = addressData['countryId'];

      return _buildAddressContainer(
        "${addressData['firstName']} ${addressData['lastName']}".tr,
        "${addressData['address1']} ${addressData['city']},${addressData['postalCode']}"
            .tr,
        "Country Name: ${countryId['displayName']}",
        CustomTextStyles.titleSmallPink300,
        "Change Address".tr,
        context,
      );
    } else {
      return _buildAddressContainer(
        "",
        "",
        "",
        CustomTextStyles.titleSmallPink300,
        "Add Address".tr,
        context,
      );
    }
  }

  Widget _buildAddressContainer(
    String name,
    String address,
    String country,
    TextStyle textStyle,
    String buttonText,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 18.v,
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
            name,
            style: textStyle,
          ),
          SizedBox(height: 9.v),
          Text(
            address,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 9.v),
          Text(
            country,
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 9.v),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _showAddressSelectionDialog(context);
                  },
                  child: Text(
                    buttonText,
                    style: textStyle,
                  ),
                ),
              ],
            ),
          )
        ],
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
                                  onChanged: () {
                                    fetchData();
                                    print('item onchanged');
                                  },
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
  final VoidCallback onChanged;
  AddresslistItemSelectionWidget(
      {required this.onChanged, Key? key, required this.addressData})
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
        // Navigator.pushNamed(context, AppRoutes.cartPage);
        showSnackBar(context, 'Address Successfully Selected.');
        _handleTap();
        Navigator.of(context).pop();
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

  void _handleTap() {
    onChanged();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
