import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/address_screen/address_screen.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
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

class AddAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  AddAddressScreen({Key? key, Map<String, dynamic>? addressData})
      : addressData = addressData ?? {},
        super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;

  TextEditingController countryController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController streetaddressController = TextEditingController();
  TextEditingController streetaddressController1 = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fetchCountryData();

    // Initialize controllers based on addressData
    countryController.text =
        widget.addressData['countryId']?['displayName'] ?? '';
    firstNameController.text = widget.addressData['firstName'] ?? '';
    lastNameController.text = widget.addressData['lastName'] ?? '';
    streetaddressController.text = widget.addressData['address1'] ?? '';
    streetaddressController1.text = widget.addressData['address2'] ?? '';
    cityController.text = widget.addressData['city'] ?? '';
    zipcodeController.text = widget.addressData['postalCode'] ?? '';
    typeController.text = widget.addressData['type'] ?? '';
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 10.v),
            child: Column(
              children: [
                SizedBox(height: 29.v),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.h, right: 16.h, bottom: 5.v),
                      child: Column(
                        children: [
                          _buildCountry(context),
                          SizedBox(height: 22.v),
                          _buildFirstName(context),
                          SizedBox(height: 22.v),
                          _buildLastName(context),
                          SizedBox(height: 23.v),
                          _buildStreetAddress(context),
                          SizedBox(height: 21.v),
                          _buildStreetAddress2(context),
                          SizedBox(height: 22.v),
                          _buildCity(context),
                          SizedBox(height: 23.v),
                          // _buildStateProvinceRegion(context),
                          // SizedBox(height: 24.v),
                          _buildZipCode(context),
                          SizedBox(height: 23.v),
                          _buildPhoneNumber(context),
                          SizedBox(height: 23.v),
                          _buildType(context),
                          SizedBox(height: 23.v),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildAddAddress(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftBlueGray300,
        margin: EdgeInsets.only(left: 16.h, top: 15.v, bottom: 16.v),
        onTap: () {
          onTapArrowLeft(context);
        },
      ),
      title: AppbarSubtitle(
        text: "lbl_add_address".tr,
        margin: EdgeInsets.only(left: 12.h),
      ),
    );
  }

  Widget _buildCountry(BuildContext context) {
    List<Map<String, dynamic>> countries = [];
    Map<String, dynamic>? selectedType;

    if (fetchedData.result.containsKey('countries')) {
      countries =
          List<Map<String, dynamic>>.from(fetchedData.result['countries']);
      selectedType = countries.isNotEmpty ? countries[0] : null;
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
                countryController.text = selectedType![
                    '_id']; // Update the controller value with the country name
              });
            }
          },
          items: countries.map((Map<String, dynamic> country) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: country,
              child: Text(country['displayName']),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.v, horizontal: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildType(BuildContext context) {
    List<String> addressTypes = ["BILLING", "SHIPPING"];
    String selectedType = addressTypes[0]; // Default selected type

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address Type".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 11.v),
        DropdownButtonFormField<String>(
          value: selectedType,
          onChanged: (String? newValue) {
            setState(() {
              selectedType = newValue!;
              typeController.text = selectedType; // Update the controller value
            });
          },
          items: addressTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.v, horizontal: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(
        'Error: $errorMessage',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildFirstName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_first_name".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 13.v),
        CustomTextFormField(
          controller: firstNameController,
          hintText: "msg_enter_the_first".tr,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildLastName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_last_name".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 12.v),
        CustomTextFormField(
          controller: lastNameController,
          hintText: "msg_enter_the_last_name".tr,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildStreetAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_street_address".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 12.v),
        CustomTextFormField(
          controller: streetaddressController,
          hintText: "msg_enter_the_street".tr,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildStreetAddress2(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("msg_street_address_2".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 16.v),
        CustomTextFormField(
          controller: streetaddressController1,
          hintText: "msg_enter_the_street2".tr,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildCity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_city".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 11.v),
        CustomTextFormField(
          controller: cityController,
          hintText: "lbl_enter_the_city".tr,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildZipCode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_zip_code".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 11.v),
        CustomTextFormField(
          controller: zipcodeController,
          hintText: "msg_enter_the_zip_code".tr,
          textInputType: TextInputType.number,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_phone_number".tr, style: theme.textTheme.titleSmall),
        SizedBox(height: 12.v),
        CustomTextFormField(
          controller: phoneNumberController,
          hintText: "msg_enter_the_phone".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.phone,
          borderDecoration: TextFormFieldStyleHelper.outlineBlueTL5,
          filled: false,
        ),
      ],
    );
  }

  Widget _buildAddAddress(BuildContext context) {
    print('add line: ${widget.addressData}');
    final buttonText =
        widget.addressData.isNotEmpty ? "Update".tr : "lbl_add_address".tr;

    return CustomElevatedButton(
      text: buttonText,
      margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 50.v),
      onPressed: () {
        onTapAddAddress(context);
      },
    );
  }

  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> onTapAddAddress(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'countryId': countryController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'address1': streetaddressController.text,
        'address2': streetaddressController1.text,
        'city': cityController.text,
        'postalCode': zipcodeController.text,
        'type': typeController.text,
        'isDefault': 'false',
      };
      try {
        final postData = userData;
        final response =
            await _apiService.postData('api/v1/address/create', postData);

        if (response.statusCode == 201) {
          Navigator.pop(context);
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
}
