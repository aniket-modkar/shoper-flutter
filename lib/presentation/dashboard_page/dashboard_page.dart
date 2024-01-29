import 'dart:convert';

import 'package:shoper_flutter/core/service/api_service.dart';
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
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!isDataFetched) {
      final userData = {'status': "PUBLISHED"};
      try {
        final response = await _apiService.fetchDataWithFilter(
            'api/v1/product/fetch', userData);
        if (response.statusCode == 200) {
          setState(() {
            fetchedData = FetchedData.fromJson(json.decode(response.body));
          });
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
      isDataFetched = true; // Set the flag to true after fetching data
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
                            // _buildMsNikeAirMax(context),
                            // SizedBox(height: 29.v),
                            CustomImageView(
                                imagePath: ImageConstant.imgRecomendedProduct,
                                height: 206.v,
                                width: 343.h,
                                radius: BorderRadius.circular(5.h)),
                            SizedBox(height: 16.v),
                            _buildDashboard(context)
                          ])))),
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
        return _buildErrorWidget("Unexpected data type for 'address'");
      }
    } else {
      return _buildErrorWidget("address key not found.");
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

  void onTapSearchProduct(BuildContext context) {}

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
