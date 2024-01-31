import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/add_address_screen/add_address_screen.dart';
import 'package:shoper_flutter/presentation/address_screen/address_screen.dart';
import 'package:badges/badges.dart' as badges;

class AddresslistItemWidget extends StatelessWidget {
  final dynamic addressData;
  final ApiService _apiService = ApiService();
  final VoidCallback onChanged;

  AddresslistItemWidget(
      {Key? key, required this.onChanged, required this.addressData})
      : super(key: key);

  @override
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
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 19.v),
              Text(
                "${addressData['firstName']} ${addressData['lastName']}".tr,
                style: theme.textTheme.titleSmall,
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
                      onEditPressed(context, addressData);
                    },
                    child: Text(
                      "lbl_edit".tr,
                      style: CustomTextStyles.titleSmallPrimary,
                    ),
                  ),
                  SizedBox(width: 32.h),
                  GestureDetector(
                    onTap: () {
                      onDeletePressed(context, addressData['_id']);
                    },
                    child: Text(
                      "lbl_delete".tr,
                      style: CustomTextStyles.titleSmallPink300,
                    ),
                  ),
                ],
              )
            ],
          ),
          Visibility(
            visible: addressData['isDefault'] == true,
            child: Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onEditPressed(BuildContext context, Map<String, dynamic> addressData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          addressData: addressData,
          onChanged: () {
            _handleTap();
          },
        ),
      ),
    );
  }

  void onDeletePressed(BuildContext context, String address) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                try {
                  final response = await _apiService
                      .deteleData('api/v1/address/delete/${address}');

                  if (response.statusCode == 202) {
                    _handleTap();
                    showSnackBar(context, 'Address Successfully Deleted.');
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
                      content:
                          Text('An error occurred. Please try again later.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleTap() {
    onChanged();
  }
}
