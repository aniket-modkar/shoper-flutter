import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:shoper_flutter/presentation/account_page/account_page.dart';
import 'package:shoper_flutter/presentation/cart_page/cart_page.dart';
import 'package:shoper_flutter/presentation/dashboard_page/dashboard_page.dart';
import 'package:shoper_flutter/presentation/explore_page/explore_page.dart';
import 'package:shoper_flutter/presentation/offer_screen_page/offer_screen_page.dart';
import 'package:shoper_flutter/presentation/product_details_screen/product_details.dart';
import 'package:shoper_flutter/presentation/profile_screen/profile_screen.dart';
import 'package:shoper_flutter/presentation/splash_screen/splash_screen.dart';
import 'package:shoper_flutter/presentation/login_screen/login_screen.dart';
import 'package:shoper_flutter/presentation/register_screen/register_screen.dart';
import 'package:shoper_flutter/presentation/dashboard_container_screen/dashboard_container_screen.dart';
// import 'package:shoper_flutter/presentation/super_flash_sale_screen/super_flash_sale_screen.dart';
import 'package:shoper_flutter/presentation/favorite_product_screen/favorite_product_screen.dart';
// import 'package:shoper_flutter/presentation/product_detail_screen/product_detail_screen.dart';
// import 'package:shoper_flutter/presentation/review_product_screen/review_product_screen.dart';
// import 'package:shoper_flutter/presentation/write_review_fill_screen/write_review_fill_screen.dart';
// import 'package:shoper_flutter/presentation/notification_screen/notification_screen.dart';
// import 'package:shoper_flutter/presentation/notification_offer_screen/notification_offer_screen.dart';
// import 'package:shoper_flutter/presentation/notification_feed_screen/notification_feed_screen.dart';
// import 'package:shoper_flutter/presentation/notification_activity_screen/notification_activity_screen.dart';
// import 'package:shoper_flutter/presentation/search_screen/search_screen.dart';
// import 'package:shoper_flutter/presentation/search_result_screen/search_result_screen.dart';
// import 'package:shoper_flutter/presentation/search_result_no_data_found_screen/search_result_no_data_found_screen.dart';
import 'package:shoper_flutter/presentation/list_category_screen/list_category_screen.dart';
// import 'package:shoper_flutter/presentation/sort_by_screen/sort_by_screen.dart';
import 'package:shoper_flutter/presentation/filter_screen/filter_screen.dart';
// import 'package:shoper_flutter/presentation/ship_to_screen/ship_to_screen.dart';
// import 'package:shoper_flutter/presentation/payment_method_screen/payment_method_screen.dart';
import 'package:shoper_flutter/presentation/choose_credit_or_debit_card_screen/choose_credit_or_debit_card_screen.dart';
// import 'package:shoper_flutter/presentation/success_screen/success_screen.dart';
// import 'package:shoper_flutter/presentation/profile_screen/profile_screen.dart';
import 'package:shoper_flutter/presentation/change_password_screen/change_password_screen.dart';
import 'package:shoper_flutter/presentation/order_screen/order_screen.dart';
import 'package:shoper_flutter/presentation/order_details_screen/order_details_screen.dart';
import 'package:shoper_flutter/presentation/add_address_screen/add_address_screen.dart';
import 'package:shoper_flutter/presentation/address_screen/address_screen.dart';
import 'package:shoper_flutter/presentation/add_payment_screen/add_payment_screen.dart';
import 'package:shoper_flutter/presentation/credit_card_and_debit_screen/credit_card_and_debit_screen.dart';
// import 'package:shoper_flutter/presentation/add_card_screen/add_card_screen.dart';
import 'package:shoper_flutter/presentation/lailyfa_febrina_card_screen/lailyfa_febrina_card_screen.dart';
import 'package:shoper_flutter/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static late HttpClientWithInterceptor client;
  static const String splashScreen = 'splash_screen';

  static const String loginScreen = 'login_screen';

  static const String registerScreen = 'register_screen';

  static const String dashboardPage = 'dashboard_page';

  static const String dashboardContainerScreen = 'dashboard_container_screen';

  static const String superFlashSaleScreen = 'super_flash_sale_screen';

  static const String favoriteProductScreen = 'favorite_product_screen';

  static const String productDetailScreen = 'product_detail_screen';

  static const String reviewProductScreen = 'review_product_screen';

  static const String writeReviewFillScreen = 'write_review_fill_screen';

  static const String notificationScreen = 'notification_screen';

  static const String notificationOfferScreen = 'notification_offer_screen';

  static const String notificationFeedScreen = 'notification_feed_screen';

  static const String notificationActivityScreen =
      'notification_activity_screen';

  static const String explorePage = 'explore_page';

  static const String searchScreen = 'search_screen';

  static const String searchResultScreen = 'search_result_screen';

  static const String searchResultNoDataFoundScreen =
      'search_result_no_data_found_screen';

  static const String listCategoryScreen = 'list_category_screen';

  static const String sortByScreen = 'sort_by_screen';

  static const String filterScreen = 'filter_screen';

  static const String cartPage = 'cart_page';

  static const String shipToScreen = 'ship_to_screen';

  static const String paymentMethodScreen = 'payment_method_screen';

  static const String chooseCreditOrDebitCardScreen =
      'choose_credit_or_debit_card_screen';

  static const String successScreen = 'success_screen';

  static const String offerScreenPage = 'offer_screen_page';

  static const String accountPage = 'account_page';

  static const String profileScreen = 'profile_screen';

  static const String changePasswordScreen = 'change_password_screen';

  static const String orderScreen = 'order_screen';

  // static const String orderDetailsScreen = 'order_details_screen';
  static const String orderDetailsScreen = 'order_details_screen';

  static const String addAddressScreen = 'add_address_screen';

  static const String addressScreen = 'address_screen';

  static const String addPaymentScreen = 'add_payment_screen';

  static const String creditCardAndDebitScreen = 'credit_card_and_debit_screen';

  static const String addCardScreen = 'add_card_screen';

  static const String lailyfaFebrinaCardScreen = 'lailyfa_febrina_card_screen';

  static const String appNavigationScreen = 'app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
    registerScreen: (context) => RegisterScreen(),
    dashboardContainerScreen: (context) => DashboardContainerScreen(),
    // superFlashSaleScreen: (context) => SuperFlashSaleScreen(),
    favoriteProductScreen: (context) => FavoriteProductScreen(),
    dashboardPage: (context) => DashboardPage(),
    productDetailScreen: (context) => ProductDetailsPage(),
    // reviewProductScreen: (context) => ReviewProductScreen(),
    // writeReviewFillScreen: (context) => WriteReviewFillScreen(),
    // notificationScreen: (context) => NotificationScreen(),
    // notificationOfferScreen: (context) => NotificationOfferScreen(),
    // notificationFeedScreen: (context) => NotificationFeedScreen(),
    // notificationActivityScreen: (context) => NotificationActivityScreen(),
    // searchScreen: (context) => SearchScreen(),
    // searchResultScreen: (context) => SearchResultScreen(),
    // searchResultNoDataFoundScreen: (context) => SearchResultNoDataFoundScreen(),
    listCategoryScreen: (context) => ListCategoryScreen(),
    // sortByScreen: (context) => SortByScreen(),
    filterScreen: (context) => FilterScreen(),
    // shipToScreen: (context) => ShipToScreen(),
    // paymentMethodScreen: (context) => PaymentMethodScreen(),
    chooseCreditOrDebitCardScreen: (context) => ChooseCreditOrDebitCardScreen(),
    // successScreen: (context) => SuccessScreen(),
    profileScreen: (context) => ProfileScreen(),
    changePasswordScreen: (context) => ChangePasswordScreen(),
    orderScreen: (context) => OrderScreen(),
    orderDetailsScreen: (context) => OrderDetailsScreen(),
    addAddressScreen: (context) => AddAddressScreen(),
    addressScreen: (context) => AddressScreen(),
    addPaymentScreen: (context) => AddPaymentScreen(),
    creditCardAndDebitScreen: (context) => CreditCardAndDebitScreen(),
    // addCardScreen: (context) => AddCardScreen(),
    cartPage: (context) => CartPage(),
    explorePage: (context) => ExplorePage(),
    accountPage: (context) => AccountPage(),
    offerScreenPage: (context) => OfferScreenPage(),
    lailyfaFebrinaCardScreen: (context) => LailyfaFebrinaCardScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
