import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/main.dart';
import 'package:shoper_flutter/presentation/dashboard_page/dashboard_page.dart';

import 'widgets/fortyeight_item_widget.dart';
import 'widgets/products_item_widget.dart';
import 'widgets/recomended_item_widget.dart';
import 'widgets/sizes_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_leading_image.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_subtitle.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:shoper_flutter/widgets/custom_elevated_button.dart';
import 'package:shoper_flutter/widgets/custom_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore_for_file: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailScreen> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = false;

  int sliderIndex = 1;
  @override
  void initState() {
    super.initState();

    // Retrieve arguments using ModalRoute.of(context) inside initState is not recommended
    // Instead, use WidgetsBinding.instance?.addPostFrameCallback to execute the logic after the build is complete

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Map<String, dynamic>? arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (arguments == null || !arguments.containsKey('productId')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text('Invalid arguments'),
              ),
            ),
          ),
        );
      } else {
        String productId = arguments['productId'];
        fetchData(productId);
      }
    });
  }

  Future<void> fetchData(String productId) async {
    if (isDataFetched) return;
    final filter = {'_id': productId};
    try {
      final response =
          await _apiService.fetchDataWithFilter('api/v1/product/fetch', filter);

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

    isDataFetched = true;
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
        body: _buildBody(),
        bottomNavigationBar: _buildAddToCart(context),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: mediaQueryData.size.width,
      padding: EdgeInsets.symmetric(vertical: 9.v),
      child: Column(
        children: [
          SizedBox(height: 12.v),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Column(
                  children: [
                    _buildProductOverview(context),
                    SizedBox(height: 22.v),
                    _buildSelectSize(context),
                    SizedBox(height: 23.v),
                    _buildSelectColor(context),
                    SizedBox(height: 24.v),
                    _buildSpecifications(context),
                    SizedBox(height: 23.v),
                    // _buildReview(context),
                    // SizedBox(height: 23.v),
                    _buildYouMightAlsoLike(context)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    Map<String, dynamic> result = fetchedData.result;

    if (!result.containsKey('products')) {
      // Add a default return statement
      return PreferredSize(
        preferredSize: Size.fromHeight(0), // Adjust the height as needed
        child: AppBar(), // You can also use an empty AppBar
      );
    }

    dynamic productsData = result['products'];

    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftBlueGray300,
        margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 15.v),
        onTap: () => onTapArrowLeft(context),
      ),
      title: AppbarSubtitle(
        text: "${_getTitleCase(productsData[0]['title']) ?? 'Unknown Product'}"
            .tr,
        margin: EdgeInsets.only(left: 12.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgNavExplore,
          margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 15.h),
          onTap: () => onTapSearchIcon(context),
        ),
        AppbarTrailingImage(
          imagePath: ImageConstant.imgMoreIcon,
          margin: EdgeInsets.only(left: 16.h, top: 16.v, right: 31.h),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildProductOverview(BuildContext context) {
    Map<String, dynamic> result = fetchedData.result;

    if (!result.containsKey('products')) {
      return Container();
    }

    dynamic productsData = result['products'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 238.v,
            initialPage: 0,
            autoPlay: true,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              sliderIndex = index;
            },
          ),
          itemCount: 1,
          itemBuilder: (context, index, realIndex) {
            return FortyeightItemWidget(product: productsData[0]);
          },
        ),
        SizedBox(height: 16.v),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 8.v,
            child: AnimatedSmoothIndicator(
              activeIndex: sliderIndex,
              count: 1,
              axisDirection: Axis.horizontal,
              effect: ScrollingDotsEffect(
                spacing: 8,
                activeDotColor: theme.colorScheme.primary.withOpacity(1),
                dotColor: appTheme.blue50,
                dotHeight: 8.v,
                dotWidth: 8.h,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.v),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 275.h,
                    child: Text(
                      "${_getTitleCase(productsData[0]['title']) ?? 'Unknown Product'}"
                          .tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.titleLargeOnPrimary
                          .copyWith(height: 1.50),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgDownload,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(left: 44.h, top: 2.v, bottom: 32.v),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 9.v),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: CustomRatingBar(initialRating: 4, itemSize: 16),
        ),
        SizedBox(height: 16.v),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Text("₹ ${productsData[0]['currentPrice'] ?? '00'}".tr,
              style: theme.textTheme.titleLarge),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSelectSize(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.h),
          // padding: EdgeInsets.only(left: 16.h, top: 310.v),
          child: Text("lbl_select_size".tr, style: theme.textTheme.titleSmall),
        ),
        SizedBox(height: 13.v),
        SizedBox(
          height: 48.v,
          child: ListView.separated(
            padding: EdgeInsets.only(left: 16.h),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(width: 16.h);
            },
            itemCount: 6,
            itemBuilder: (context, index) {
              return SizesItemWidget();
            },
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSelectColor(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 7.h),
            // padding: EdgeInsets.only(left: 7.h, top: 190.v),
            child:
                Text("lbl_select_color".tr, style: theme.textTheme.titleSmall),
          ),
          SizedBox(height: 12.v),
          CustomImageView(
            imagePath: ImageConstant.imgColors,
            height: 48.v,
            width: 359.h,
            margin: EdgeInsets.only(left: 7.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSpecifications(BuildContext context) {
    Map<String, dynamic> result = fetchedData.result;
    if (!result.containsKey('products')) {
      return Container();
    }
    dynamic productsData = result['products'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("lbl_specification".tr, style: theme.textTheme.titleSmall),
          // SizedBox(height: 12.v),
          // _buildStyle(context,
          //     styleText: "lbl_shown".tr,
          //     styleCodeText: "msg_laser_blue_anth".tr),
          // SizedBox(height: 18.v),
          // _buildStyle(context,
          //     styleText: "lbl_style".tr, styleCodeText: "lbl_cd0113_400".tr),
          // SizedBox(height: 19.v),
          Container(
            width: 320.h,
            margin: EdgeInsets.only(right: 31.h),
            // margin: EdgeInsets.only(right: 31.h, top: 400.v),
            child: Text(
              "${_getTitleCase(productsData[0]['title']) ?? 'Unknown Product'}"
                  .tr,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(height: 1.80),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildReview(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStyle(
            context,
            styleText: "lbl_review_product".tr,
            styleCodeText: "lbl_see_more".tr,
            onTapStyleCode: () {
              onTapTxtSeeMoreLink(context);
            },
          ),
          SizedBox(height: 8.v),
          Row(
            children: [
              CustomRatingBar(initialRating: 4, itemSize: 16),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text("lbl_4_5".tr,
                    style: CustomTextStyles.labelMediumBluegray300),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Text("lbl_5_review".tr,
                    style: CustomTextStyles.bodySmall10),
              ),
            ],
          ),
          SizedBox(height: 16.v),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgProfilePicture,
                height: 48.adaptSize,
                width: 48.adaptSize,
                radius: BorderRadius.circular(24.h),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.h, top: 2.v, bottom: 4.v),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("lbl_james_lawson".tr,
                        style: theme.textTheme.titleSmall),
                    SizedBox(height: 4.v),
                    CustomRatingBar(initialRating: 4, itemSize: 16),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.v),
          SizedBox(
            width: 339.h,
            child: Text(
              "msg_air_max_are_always".tr,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(height: 1.80),
            ),
          ),
          SizedBox(height: 16.v),
          SizedBox(
            height: 72.v,
            child: ListView.separated(
              padding: EdgeInsets.only(right: 112.h),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return SizedBox(width: 12.h);
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return ProductsItemWidget();
              },
            ),
          ),
          SizedBox(height: 16.v),
          Text("msg_december_10_2016".tr, style: CustomTextStyles.bodySmall10),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildYouMightAlsoLike(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.h),
          child: Text(
            "msg_you_might_also_like".tr,
            style: CustomTextStyles.titleSmall_1,
          ),
        ),
        SizedBox(height: 11.v),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 238.v,
            child: ListView.separated(
              padding: EdgeInsets.only(left: 16.h),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return SizedBox(width: 16.h);
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return RecomendedItemWidget();
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildAddToCart(BuildContext context) {
    Map<String, dynamic> result = fetchedData.result;

    if (result.containsKey('products')) {
      dynamic productsData = result['products'];
      return CustomElevatedButton(
          onPressed: () {
            addToCart(context, productsData[0]);
          },
          text: "lbl_add_to_cart".tr,
          margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 50.v));
    } else {
      return Container();
    }
  }

  /// Common widget
  Widget _buildStyle(
    BuildContext context, {
    required String styleText,
    required String styleCodeText,
    Function? onTapStyleCode,
  }) {
    return Row(children: [
      Padding(
          padding: EdgeInsets.only(top: 1.v),
          child: Text(styleText,
              style: CustomTextStyles.bodySmallOnPrimary.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(1)))),
      GestureDetector(onTap: () {
        onTapStyleCode!.call();
      }),
      Padding(
          padding: EdgeInsets.only(left: 234.h),
          child: Text(styleCodeText,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: appTheme.blueGray300)))
    ]);
  }

  void onTapSearchIcon(BuildContext context) {}

  void onTapTxtSeeMoreLink(BuildContext context) {}
}

void onTapArrowLeft(BuildContext context) {
  Navigator.pop(context);
}

final ApiService _apiService = ApiService();

void addToCart(BuildContext context, Map<String, dynamic> product) async {
  try {
    if (product.isEmpty) {
      return;
    }

    final userData = {'productId': product['_id']};

    final response = await _apiService.postData(
        'api/v1/cart/incrementProductQuantity', userData);

    if (response.statusCode == 200) {
      Provider.of<MyDataProvider>(context, listen: false)
          .updateData(product['_id']);
      // Navigator.pushNamed(context, AppRoutes.cartPage);
      showSnackBar(context, 'Product added to cart.');
    } else {
      showSnackBar(context, 'An error occurred. Please try again later.');
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

String _getTitleCase(String? title) {
  if (title == null) {
    return 'Unknown Product';
  }
  return titleCase(title);
}

String titleCase(String input) {
  List<String> words = input.split(' ');
  List<String> titleCaseWords = words.map((word) {
    if (word.isNotEmpty) {
      return '${word[0].toUpperCase()}${word.substring(1)}';
    } else {
      return '';
    }
  }).toList();
  return titleCaseWords.join(' ');
}
