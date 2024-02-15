import 'package:shoper_flutter/widgets/custom_bottom_bar.dart';

import '../offer_screen_page/widgets/offerscreen_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_title.dart';
import 'package:shoper_flutter/widgets/app_bar/appbar_trailing_image.dart';
import 'package:shoper_flutter/widgets/app_bar/custom_app_bar.dart';

class OfferScreenPage extends StatefulWidget {
  const OfferScreenPage({Key? key}) : super(key: key);
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferScreenPage> {
  String currentRoute = AppRoutes.offerScreenPage;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(context),
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 28.v),
                child: Column(children: [
                  _buildCuponPromotion(context),
                  SizedBox(height: 16.v),
                  _buildOfferScreen(context)
                ])),
            bottomNavigationBar: CustomBottomBar(
              currentRoute: currentRoute,
              onChanged: (BottomBarEnum type) {
                setState(() {
                  currentRoute = getCurrentRoute(type);
                });
              },
            )));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        title: AppbarTitle(
            text: "lbl_offer".tr, margin: EdgeInsets.only(left: 16.h)),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgNotificationIcon,
              margin: EdgeInsets.fromLTRB(13.h, 16.v, 13.h, 15.v),
              onTap: () {
                onTapNotificationIcon(context);
              })
        ]);
  }

  /// Section Widget
  Widget _buildCuponPromotion(BuildContext context) {
    return Container(
        width: 343.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 17.v),
        decoration: AppDecoration.fillPrimary
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
        child: SizedBox(
            width: 201.h,
            child: Text("msg_use_megsl_cupon".tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleMediumOnPrimaryContainer
                    .copyWith(height: 1.50))));
  }

  /// Section Widget
  Widget _buildOfferScreen(BuildContext context) {
    return Expanded(
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 16.v);
            },
            itemCount: 2,
            itemBuilder: (context, index) {
              return OfferscreenItemWidget();
            }));
  }

  void onTapNotificationIcon(BuildContext context) {}

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
