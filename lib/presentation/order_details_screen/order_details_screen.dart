import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/dashboard_page/dashboard_page.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: Column(
            children: [
              SizedBox(height: 27.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 15.h, right: 15.h, bottom: 5.v),
                    child: Column(
                      children: [
                        _buildProduct(context),
                        SizedBox(height: 24.v),
                        _buildShippingDetails(context),
                        SizedBox(height: 46.v),
                        _buildPaymentDetails(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildNotifyMe(context),
      ),
    );
  }

  Widget _buildProduct(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.h),
          child: Text("lbl_product".tr, style: theme.textTheme.titleSmall),
        ),
        SizedBox(height: 12.v),
        Padding(
          padding: EdgeInsets.only(left: 2.h),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.v);
            },
            itemCount: fetchedData.result.length,
            itemBuilder: (context, index) {
              final product = fetchedData.result[index];
              final userData = {
                'productId': product['productId'],
                'name': product['name'],
                'price': product['price'],
                'quantity': product['quantity'],
                // Add other fields as needed
              };

              return OrderdetailsItemWidget(userData: userData);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShippingDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.h),
          child: Text("msg_shipping_details".tr,
              style: theme.textTheme.titleSmall),
        ),
        // ... other widgets for shipping details
      ],
    );
  }

  Widget _buildPaymentDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: Text("lbl_payment_details".tr,
                style: theme.textTheme.titleSmall),
          ),
          // ... other widgets for payment details
        ],
      ),
    );
  }

  Widget _buildNotifyMe(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_notify_me".tr,
      margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 50.v),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftBlueGray300,
        margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 15.v),
        onTap: () {
          onTapArrowLeft(context);
        },
      ),
      title: AppbarSubtitle(
        text: "lbl_order_details".tr,
        margin: EdgeInsets.only(left: 12.h),
      ),
    );
  }

  void onTapArrowLeft(BuildContext context) {
    // Add your logic here
  }
}

class OrderdetailsItemWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const OrderdetailsItemWidget({Key? key, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userData['name'] ?? 'Product Name',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text('Quantity: ${userData['quantity']}'),
          Text('Price: \$${userData['price']}'),
          // Add more details as needed
        ],
      ),
    );
  }
}
