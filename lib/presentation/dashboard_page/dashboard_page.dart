import 'package:dio/dio.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/core/service/storage_service.dart';

import '../dashboard_page/widgets/categories_item_widget.dart';
import '../dashboard_page/widgets/dashboard_item_widget.dart';
import '../dashboard_page/widgets/slider_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:convert';

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

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService _apiService = ApiService();
  int sliderIndex = 1;
  FetchedData fetchedData = FetchedData(
    message: '',
    responseCode: '',
    result: {},
    totalCounts: 0,
    statusCode: 0,
  );

  bool isDataFetched = false; // Flag to track whether data has been fetched

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!isDataFetched) {
      try {
        final response = await _apiService.fetchData('api/v1/product/fetch');
        print('API Response: ${response}');

        if (response.statusCode == 200) {
          final responseData = response.data;

          final fetchedDataResponse =
              FetchedData.fromJson(json.decode(responseData));

          setState(() {
            fetchedData = fetchedDataResponse;
          });
        } else {
          print('Non-200 status code: ${response.statusCode}');
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
      } finally {}

      isDataFetched = true;
    }
  }

  Dio dioInstance =
      Dio(); // Example definition, replace it with your actual Dio instance creation.
  StorageService storageServiceInstance =
      StorageService(); // Example definition, replace it with your actual StorageService instance creation.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildScaffoldWithContent(_buildLoadingWidget());
        } else if (snapshot.hasError) {
          return _buildScaffoldWithContent(
              _buildErrorWidget(snapshot.error.toString()));
        } else {
          Map<String, dynamic> result = fetchedData.result;

          if (result.containsKey('products')) {
            dynamic products = result['products'];
            return ProductGrid.products(
                products: products,
                dioInstance: dioInstance,
                storageServiceInstance: storageServiceInstance);
          } else {
            return _buildScaffoldWithContent(
                _buildErrorWidget("Products key not found."));
          }
        }
      },
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

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildScaffoldWithContent(Widget content) {
    print('Building scaffold with content: $content');
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 27.v),
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, bottom: 5.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSlider(context),
                  SizedBox(height: 16.v),
                  Container(
                    height: 8.v,
                    margin: EdgeInsets.only(left: 135.h),
                    child: AnimatedSmoothIndicator(
                      activeIndex: sliderIndex,
                      count: 1,
                      axisDirection: Axis.horizontal,
                      effect: ScrollingDotsEffect(
                        spacing: 8,
                        activeDotColor:
                            theme.colorScheme.primary.withOpacity(1),
                        dotColor: appTheme.blue50,
                        dotHeight: 8.v,
                        dotWidth: 8.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.v),
                  _buildCategories(context),
                  SizedBox(height: 23.v),
                  Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: _buildFlashSaleHeader(
                      context,
                      flashSaleText: "lbl_flash_sale".tr,
                      seeMoreText: "lbl_see_more".tr,
                      onTapFlashSaleHeader: () {
                        onTapFlashSaleHeader(context);
                      },
                    ),
                  ),
                  SizedBox(height: 12.v),
                  content, // This is where your ProductGrid is placed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 48.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgSearch,
            margin: EdgeInsets.only(left: 32.h, top: 20.v, bottom: 20.v)),
        title: AppbarSubtitleOne(
            text: "lbl_search_product".tr,
            margin: EdgeInsets.only(left: 8.h),
            onTap: () {
              onTapSearchProduct(context);
            }),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgDownload,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 16.h),
              onTap: () {
                onTapDownload(context);
              }),
          Container(
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 32.h),
              child: Stack(alignment: Alignment.topRight, children: [
                CustomImageView(
                    imagePath: ImageConstant.imgNotificationIcon,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.center,
                    onTap: () {
                      onTapImgNotificationIcon(context);
                    }),
                CustomImageView(
                    imagePath: ImageConstant.imgClosePink300,
                    height: 8.adaptSize,
                    width: 8.adaptSize,
                    alignment: Alignment.topRight,
                    margin:
                        EdgeInsets.only(left: 14.h, right: 2.h, bottom: 16.v))
              ]))
        ]);
  }

  /// Section Widget
  Widget _buildSlider(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 16.h),
        child: CarouselSlider.builder(
            options: CarouselOptions(
                height: 206.v,
                initialPage: 0,
                autoPlay: true,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  sliderIndex = index;
                }),
            itemCount: 1,
            itemBuilder: (context, index, realIndex) {
              return SliderItemWidget();
            }));
  }

  /// Section Widget
  Widget _buildCategories(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(right: 16.h),
          child: _buildFlashSaleHeader(context,
              flashSaleText: "lbl_category".tr,
              seeMoreText: "lbl_more_category".tr, onTapSeeMoreLink: () {
            onTapTxtMoreCategoryLink(context);
          })),
      SizedBox(height: 10.v),
      SizedBox(
          height: 108.v,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return SizedBox(width: 12.h);
              },
              itemCount: 5,
              itemBuilder: (context, index) {
                return CategoriesItemWidget();
              }))
    ]);
  }

  /// Section Widget
  Widget _buildDashboard(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 16.h),
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 283.v,
                crossAxisCount: 2,
                mainAxisSpacing: 13.h,
                crossAxisSpacing: 13.h),
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return DashboardItemWidget();
            }));
  }

  /// Common widget
  Widget _buildFlashSaleHeader(
    BuildContext context, {
    required String flashSaleText,
    required String seeMoreText,
    Function? onTapFlashSaleHeader,
    Function? onTapSeeMoreLink,
  }) {
    return GestureDetector(
        onTap: () {
          onTapFlashSaleHeader!.call();
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(flashSaleText,
              style: theme.textTheme.titleSmall!
                  .copyWith(color: theme.colorScheme.onPrimary.withOpacity(1))),
          GestureDetector(onTap: () {
            onTapSeeMoreLink!.call();
          }),
          Text(seeMoreText,
              style: CustomTextStyles.titleSmallPrimary
                  .copyWith(color: theme.colorScheme.primary.withOpacity(1)))
        ]));
  }

  void onTapFlashSaleHeader(BuildContext context) {}

  void onTapImgNotificationIcon(BuildContext context) {}

  void onTapProductItem(BuildContext context) {
    print('onClick Product');
  }

  void onTapTxtMoreCategoryLink(BuildContext context) {}

  void onTapDownload(BuildContext context) {}

  void onTapSearchProduct(BuildContext context) {}
}

class ProductGrid extends StatelessWidget {
  final List<dynamic> products;
  final Dio dioInstance;
  final StorageService storageServiceInstance;
  final ApiService _apiService;

  // Named constructor
  ProductGrid.apiService(this.dioInstance, this.storageServiceInstance)
      : _apiService = ApiService(dioInstance, storageServiceInstance),
        products = [];

  // Named constructor
  ProductGrid.products(
      {required this.products,
      required this.dioInstance,
      required this.storageServiceInstance})
      : _apiService = ApiService(dioInstance, storageServiceInstance);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return buildProductCard(context, products[index]);
      },
    );
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        onProductClicked(context, product);
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product['title'] ?? 'Unknown Product',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Price: \$${product['currentPrice']}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Inventory: ${product['inventoryQuantity']}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Status: ${product['status']}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Threshold Quantity: ${product['thresholdQuantity']}',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  void onProductClicked(
      BuildContext context, Map<String, dynamic> product) async {
    try {
      if (product.isEmpty) {
        return;
      }

      final userData = {'productId': product['_id']};

      final response =
          await _apiService.postData('api/v1/cart/addProduct', userData);

      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      }
    } catch (error) {
      print('Error: $error');
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

  void main() {
    // Define a sample list of products
    List<dynamic> myProductsList = [
      {
        'title': 'Product 1',
        'currentPrice': 10.0,
        'inventoryQuantity': 20,
        'status': 'Available',
        'thresholdQuantity': 5
      },
      {
        'title': 'Product 2',
        'currentPrice': 15.0,
        'inventoryQuantity': 15,
        'status': 'Out of Stock',
        'thresholdQuantity': 3
      },
      // Add more products as needed
    ];

    // Create an instance using the named constructor and pass the defined products
    var grid2 = ProductGrid.products(
        products: myProductsList,
        dioInstance: dioInstance,
        storageServiceInstance: storageServiceInstance);

    // Example: runApp(grid2);
  }
}
