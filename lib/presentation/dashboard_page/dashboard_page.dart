import 'dart:convert';

import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/cart_page/cart_page.dart';
import 'package:shoper_flutter/widgets/custom_bottom_bar.dart';

import '../dashboard_page/widgets/categories_item_widget.dart';
import '../dashboard_page/widgets/dashboard_item_widget.dart';
import '../dashboard_page/widgets/fsnikeairmax_item_widget.dart';
import '../dashboard_page/widgets/msnikeairmax_item_widget.dart';
import '../dashboard_page/widgets/slider_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

class FetchedBannerData {
  final String message;
  final String responseCode;
  final Map<String, dynamic> result;
  final int totalCounts;
  final int statusCode;

  FetchedBannerData({
    required this.message,
    required this.responseCode,
    required this.result,
    required this.totalCounts,
    required this.statusCode,
  });

  factory FetchedBannerData.fromJson(Map<String, dynamic> json) {
    return FetchedBannerData(
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

class FetchedSearchAnalyticsData {
  final String message;
  final String responseCode;
  final Map<String, dynamic> result;
  final int totalCounts;
  final int statusCode;

  FetchedSearchAnalyticsData({
    required this.message,
    required this.responseCode,
    required this.result,
    required this.totalCounts,
    required this.statusCode,
  });

  factory FetchedSearchAnalyticsData.fromJson(Map<String, dynamic> json) {
    return FetchedSearchAnalyticsData(
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
} // ignore_for_file: must_be_immutable

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String currentRoute = AppRoutes.dashboardPage;

  final ApiService _apiService = ApiService();
  int sliderIndex = 1;
  late FetchedData fetchedData;
  late FetchedBannerData fetchedBannerData;
  late FetchedSearchAnalyticsData fetchedSearchAnalyticsData;

  bool isDataFetched = false;
  bool isBannerDataFetched = false;
  bool isSearchAnalyticsFetched = false;

  @override
  void initState() {
    super.initState();
    fetchBanner();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Accessing the arguments and calling fetchData
      if (context != null) {
        Map<String, dynamic>? arguments =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        if (arguments != null && arguments.containsKey('categoryId')) {
          String categoryId = arguments['categoryId'];
          // Await the fetchData method
          fetchData(categoryId: categoryId);
        } else {
          fetchData();
        }
      }
    });
  }

  Future<void> fetchData({String categoryId = ''}) async {
    if (!isDataFetched) {
      final userData = {
        'status': "PUBLISHED",
        if (categoryId.isNotEmpty) 'categoriesId': categoryId
      };
      try {
        final response = await _apiService.fetchDataWithFilter(
            'api/v1/product/fetch', userData);
        if (response.statusCode == 200) {
          setState(() {
            fetchedData = FetchedData.fromJson(json.decode(response.body));
          });
        } else {
          // Handle non-200 status code responses
          // For example: Show a snackbar with an error message
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
        }
      } catch (error) {
        // Handle errors
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
      isDataFetched = true;
    }
  }

  Future<void> fetchBanner() async {
    if (!isBannerDataFetched) {
      try {
        final response = await _apiService.fetchData('api/v1/banners/fetch');
        if (response.statusCode == 200) {
          setState(() {
            fetchedBannerData =
                FetchedBannerData.fromJson(json.decode(response.body));
          });
        } else {
          // Handle non-200 status code responses
          // For example: Show a snackbar with an error message
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
        }
      } catch (error) {
        // Handle errors
        setState(() {
          fetchedBannerData = FetchedBannerData(
            message: 'Error: $error',
            responseCode: '',
            result: {},
            totalCounts: 0,
            statusCode: 0,
          );
        });
      }
      isBannerDataFetched = true;
    }
  }

  Future<void> fetchSearchAnalytics() async {
    if (!isSearchAnalyticsFetched) {
      try {
        final response =
            await _apiService.fetchData('api/v1/searchAnalytics/fetch');
        if (response.statusCode == 200) {
          setState(() {
            fetchedSearchAnalyticsData =
                FetchedSearchAnalyticsData.fromJson(json.decode(response.body));
          });
        } else {
          // Handle non-200 status code responses
          // For example: Show a snackbar with an error message
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch data')));
        }
      } catch (error) {
        // Handle errors
        setState(() {
          fetchedSearchAnalyticsData = FetchedSearchAnalyticsData(
            message: 'Error: $error',
            responseCode: '',
            result: {},
            totalCounts: 0,
            statusCode: 0,
          );
        });
      }
      isSearchAnalyticsFetched = true;
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
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: Container(
              width: mediaQueryData.size.width,
              padding: EdgeInsets.symmetric(horizontal: 15.v, vertical: 7.v),
              child: Column(children: [
                SizedBox(height: 12.v),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 5.v),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSlider(context),
                                  SizedBox(height: 16.v),
                                  Container(
                                      height: 8.v,
                                      margin: EdgeInsets.only(
                                        left: 135.h,
                                      ),
                                      child: AnimatedSmoothIndicator(
                                          activeIndex: sliderIndex,
                                          count: 1,
                                          axisDirection: Axis.horizontal,
                                          effect: ScrollingDotsEffect(
                                              spacing: 8,
                                              activeDotColor: theme
                                                  .colorScheme.primary
                                                  .withOpacity(1),
                                              dotColor: appTheme.blue50,
                                              dotHeight: 8.v,
                                              dotWidth: 8.h))),
                                  SizedBox(height: 25.v),
                                  // _buildCategories(context),
                                  // SizedBox(height: 23.v),
                                  // Padding(
                                  //     padding: EdgeInsets.only(right: 16.h),
                                  //     child: _buildFlashSaleHeader(context,
                                  //         flashSaleText: "lbl_flash_sale".tr,
                                  //         seeMoreText: "lbl_see_more".tr,
                                  //         onTapFlashSaleHeader: () {
                                  //       onTapFlashSaleHeader(context);
                                  //     })),
                                  // SizedBox(
                                  //   height: 12.v,
                                  // ),
                                  // _buildFsNikeAirMax(context),
                                  // SizedBox(height: 23.v),
                                  // Padding(
                                  //     padding: EdgeInsets.only(
                                  //       right: 16.h,
                                  //     ),
                                  //     child: _buildFlashSaleHeader(context,
                                  //         flashSaleText: "lbl_mega_sale".tr,
                                  //         seeMoreText: "lbl_see_more".tr)),
                                  // SizedBox(height: 10.v),
                                  _buildBanner(
                                      context), // _buildMsNikeAirMax(context),
                                  // SizedBox(height: 29.v),
                                  SizedBox(height: 16.v),
                                  _buildDashboard(context)
                                ]))))
              ])),
          bottomNavigationBar: CustomBottomBar(
            currentRoute: currentRoute,
            onChanged: (BottomBarEnum type) {
              setState(() {
                currentRoute = getCurrentRoute(type);
              });
            },
          ),
        ),
      );
    }
  }

  Widget _buildBanner(BuildContext context) {
    String baseUrl = _apiService.imgBaseUrl;

    if (fetchedBannerData.result.containsKey('banners')) {
      List<dynamic> banners = fetchedBannerData.result['banners'];

      if (banners.isNotEmpty) {
        return CarouselSlider(
          options: CarouselOptions(
            height: 250,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
          ),
          items: banners.map((banner) {
            String imageUrl = baseUrl + (banner['mediaPath'] as String);
            String title = banner['title'];
            String subtitle = banner['subtitle'];

            return Builder(
              builder: (BuildContext context) {
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        );
      } else {
        return CustomImageView(
          imagePath: ImageConstant.imgRecomendedProduct,
          height: 206.v,
          width: 343.h,
          radius: BorderRadius.circular(5.h),
        );
      }
    } else {
      return _buildErrorWidget("banner not found.");
    }
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
        padding: EdgeInsets.only(
          right: 16.h,
        ),
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
          padding: EdgeInsets.only(
            right: 16.h,
          ),
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

  // / Section Widget
  Widget _buildFsNikeAirMax(BuildContext context) {
    return SizedBox(
        height: 238.v,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(width: 16.h);
            },
            itemCount: 4,
            itemBuilder: (context, index) {
              return FsnikeairmaxItemWidget(onTapProductItem: () {
                onTapProductItem(context);
              });
            }));
  }

  /// Section Widget
  Widget _buildMsNikeAirMax(BuildContext context) {
    return SizedBox(
        height: 238.v,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 16.h,
              );
            },
            itemCount: 4,
            itemBuilder: (context, index) {
              return MsnikeairmaxItemWidget();
            }));
  }

  /// Section Widget
  Widget _buildDashboard(BuildContext context) {
    if (fetchedData.result.containsKey('products')) {
      dynamic products = fetchedData.result['products'];
      if (products.length > 0) {
        if (products is List) {
          return Padding(
              padding: EdgeInsets.only(
                right: 16.h,
              ),
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 283.v,
                      crossAxisCount: 2,
                      mainAxisSpacing: 13.h,
                      crossAxisSpacing: 13.h),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return DashboardItemWidget(product: products[index]);
                  }));
        } else {
          return _buildErrorWidget("Unexpected data type for 'Product'");
        }
      } else {
        return Center(
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(16.0), // Adjust padding as needed
            child: Text(
              'No product found',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      return _buildErrorWidget("product key not found.");
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

  void onTapProductItem(BuildContext context) {}

  void onTapTxtMoreCategoryLink(BuildContext context) {}

  void onTapDownload(BuildContext context) {}

  void onTapSearchProduct(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.categorydetails,
    );
  }

  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.dashboardPage;
      case BottomBarEnum.Explore:
        return AppRoutes.explorePage;
      case BottomBarEnum.Cart:
        return AppRoutes.cartPage;
      case BottomBarEnum.Offer:
        return AppRoutes.offerScreenPage;
      case BottomBarEnum.Account:
        return AppRoutes.accountPage;
      default:
        return "/";
    }
  }
}
