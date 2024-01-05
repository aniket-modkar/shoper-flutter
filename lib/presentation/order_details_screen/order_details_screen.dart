import 'dart:convert';

import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:intl/intl.dart';

import '../order_details_screen/widgets/orderdetails_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';
import 'package:shoper_flutter/widgets/custom_icon_button.dart';

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

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late FetchedData fetchedData;
  bool isDataFetched = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!isDataFetched) {
      try {
        final String orderId = widget.orderId;
        final userData = {'orderId': orderId};

        final response = await _apiService.fetchDataWithFilter(
            'api/v1/order/customerOrders', userData);
        if (response.statusCode == 202) {
          setState(() {
            fetchedData = FetchedData.fromJson(json.decode(response.body));
            isDataFetched = true;
          });

          // Print the fetched data
          print('Fetched Data: $fetchedData');
        } else {
          // Handle non-200 status code, if needed
        }
      } catch (error) {
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
                child: Column(children: [
                  SizedBox(height: 27.v),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, right: 15.h, bottom: 5.v),
                              child: Column(children: [
                                _buildTracking(context),
                                SizedBox(height: 24.v),
                                _buildProduct(context),
                                SizedBox(height: 24.v),
                                _buildShippingDetails(context),
                                SizedBox(height: 46.v),
                                _buildPaymentDetails(context)
                              ]))))
                ])),
            bottomNavigationBar: _buildNotifyMe(context)));
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
            text: "lbl_order_details".tr, margin: EdgeInsets.only(left: 12.h)));
  }

  /// Section Widget
  Widget _buildTracking(BuildContext context) {
    if (fetchedData.result != null) {
      List<dynamic> orders = fetchedData.result;

      if (orders.isNotEmpty) {
        var order = orders.first;

        // Extract relevant data for tracking
        var orderStatus = order['status'];
        return SizedBox(
            height: 57.v,
            width: 342.h,
            child: Stack(alignment: Alignment.center, children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 12.v),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 96.h,
                                child: Divider(
                                    color: theme.colorScheme.primary
                                        .withOpacity(1))),
                            SizedBox(
                                width: 96.h,
                                child: Divider(
                                    color: theme.colorScheme.primary
                                        .withOpacity(1))),
                            SizedBox(width: 96.h, child: Divider())
                          ]))),
              Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          CustomIconButton(
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              padding: EdgeInsets.all(8.h),
                              decoration: IconButtonStyleHelper.fillPrimaryTL12,
                              child: CustomImageView(
                                  imagePath: ImageConstant.imgPacing)),
                          SizedBox(height: 15.v),
                          Text("lbl_packing".tr,
                              style: theme.textTheme.bodySmall)
                        ]),
                        Column(children: [
                          CustomIconButton(
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              padding: EdgeInsets.all(8.h),
                              decoration: IconButtonStyleHelper.fillPrimaryTL12,
                              child: CustomImageView(
                                  imagePath: ImageConstant.imgPacing)),
                          SizedBox(height: 15.v),
                          Text("lbl_shipping".tr,
                              style: theme.textTheme.bodySmall)
                        ]),
                        Column(children: [
                          CustomIconButton(
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              padding: EdgeInsets.all(8.h),
                              decoration: IconButtonStyleHelper.fillPrimaryTL12,
                              child: CustomImageView(
                                  imagePath: ImageConstant.imgPacing)),
                          SizedBox(height: 15.v),
                          Text("lbl_arriving".tr,
                              style: theme.textTheme.bodySmall)
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomImageView(
                                  imagePath: ImageConstant.imgCheckmarkBlue50,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize,
                                  margin: EdgeInsets.only(left: 13.h)),
                              SizedBox(height: 13.v),
                              Text("lbl_success".tr,
                                  style: theme.textTheme.bodySmall)
                            ])
                      ]))
            ]));
      }
    }
    return Container();
  }

  /// Section Widget
  Widget _buildProduct(BuildContext context) {
    if (fetchedData.result != null) {
      List<dynamic> orders = fetchedData.result;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: orders.map<Widget>((order) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.h),
                child: Text("Order ID: ${order['_id']}"),
              ),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.only(left: 2.h),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 8.v),
                  itemCount: order['products'].length,
                  itemBuilder: (context, index) {
                    var product = order['products'][index];
                    return OrderdetailsItemWidget(
                      product: product,
                    );
                  },
                ),
              ),
            ],
          );
        }).toList(),
      );
    } else {
      return _buildErrorWidget("Result is null or not found.");
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

  /// Section Widget
  Widget _buildShippingDetails(BuildContext context) {
    if (fetchedData.result != null) {
      List<dynamic> orders = fetchedData.result;

      if (orders.isNotEmpty) {
        var order = orders.first;

        // Extract relevant data for shipping details
        var billingAddress = order['billingAddress'];
        DateTime createdAt = DateTime.parse(billingAddress['createdAt']);
        String formattedDate = DateFormat.yMMMMd().format(createdAt);

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Text(
              "msg_shipping_details".tr,
              style: theme.textTheme.titleSmall,
            ),
          ),
          SizedBox(height: 11.v),
          Container(
            margin: EdgeInsets.only(left: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 18.v),
            decoration: AppDecoration.outlineBlue
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildShipping(
                  context,
                  shippingLabel: "lbl_date_shipping".tr,
                  pOSReggular: formattedDate,
                ),
                SizedBox(height: 15.v),
                _buildShipping(context,
                    shippingLabel: "lbl_shipping".tr,
                    pOSReggular: "lbl_pos_reggular".tr),
                SizedBox(height: 14.v),
                _buildShipping(context,
                    shippingLabel: "lbl_no_resi".tr,
                    pOSReggular: "lbl_000192848573".tr),
                SizedBox(height: 15.v),
                _buildShipping(context,
                    shippingLabel: "lbl_address".tr,
                    pOSReggular:
                        "${billingAddress['address1']}, ${billingAddress['address2']},"),
                SizedBox(height: 8.v),
                _buildShipping(context,
                    shippingLabel: '-',
                    pOSReggular:
                        "${billingAddress['city']}, ${billingAddress['postalCode']}, ${billingAddress['countryId']}")
              ],
            ),
          ),
        ]);
      }
    }
    return Container(); // Return an empty container if there are no orders or the orders list is empty.
  }

  /// Section Widget
  Widget _buildPaymentDetails(BuildContext context) {
    if (fetchedData.result != null) {
      List<dynamic> orders = fetchedData.result;

      if (orders.isNotEmpty) {
        var order = orders.first;

        // Extract relevant data for payment details
        var orderTotal = order['orderTotal'];
        var totalProduct = order['products'];

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 1.h),
                child: Text(
                  "lbl_payment_details".tr,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              SizedBox(height: 11.v),
              Container(
                padding: EdgeInsets.all(15.h),
                decoration: AppDecoration.outlineBlue
                    .copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShipping1(
                      context,
                      shippingLabel:
                          "Total Cart item(${totalProduct.length})".tr,
                      priceLabel: "₹ ${orderTotal}".tr,
                    ),
                    SizedBox(height: 16.v),
                    _buildShipping1(
                      context,
                      shippingLabel: "lbl_shipping".tr,
                      priceLabel: "lbl_40_00".tr,
                    ),
                    SizedBox(height: 14.v),
                    _buildShipping1(
                      context,
                      shippingLabel: "lbl_import_charges".tr,
                      priceLabel: "lbl_128_00".tr,
                    ),
                    SizedBox(height: 12.v),
                    Divider(),
                    SizedBox(height: 10.v),
                    _buildShipping1(
                      context,
                      shippingLabel: "lbl_total_price".tr,
                      priceLabel:
                          "₹ $orderTotal", // Display the order total here
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
    return Container();
  }

  /// Section Widget
  Widget _buildNotifyMe(BuildContext context) {
    return CustomElevatedButton(
        text: "lbl_notify_me".tr,
        margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 50.v));
  }

  /// Common widget
  Widget _buildShipping(
    BuildContext context, {
    required String shippingLabel,
    required String pOSReggular,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Opacity(
          opacity: 0.5,
          child: Text(shippingLabel,
              style: CustomTextStyles.bodySmallOnPrimary_1
                  .copyWith(color: theme.colorScheme.onPrimary))),
      Text(pOSReggular,
          style: CustomTextStyles.bodySmallOnPrimary
              .copyWith(color: theme.colorScheme.onPrimary.withOpacity(1)))
    ]);
  }

  /// Common widget
  Widget _buildShipping1(
    BuildContext context, {
    required String shippingLabel,
    required String priceLabel,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: EdgeInsets.only(top: 1.v),
          child: Text(shippingLabel,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: appTheme.blueGray300))),
      Text(priceLabel,
          style: CustomTextStyles.bodySmallOnPrimary
              .copyWith(color: theme.colorScheme.onPrimary.withOpacity(1)))
    ]);
  }

  void onTapArrowLeft(BuildContext context) {}
}
