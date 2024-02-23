import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';
import 'package:shoper_flutter/routes/app_routes.dart';

class AuthGuard extends RouteObserver<PageRoute<dynamic>> {
  final StorageService _storageService = StorageService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);
    final token = await _storageService.getTokenFromStorage();

    // Check if the route requires authentication
    if ((token == null || !isValidToken(token))) {
      // If the user is not authenticated or the token is invalid, navigate to the login screen
      Navigator.of(route.navigator!.context).pushReplacementNamed(
        AppRoutes.loginScreen,
      );
    } else if (token!.isNotEmpty &&
        route.settings.name == AppRoutes.loginScreen) {
      // If the token is valid and the current route is the login screen, navigate to the dashboardContainerScreen
      Navigator.of(route.navigator!.context).pushReplacementNamed(
        AppRoutes.dashboardPage,
      );
    }
    // Allow access to the register screen for both authenticated and unauthenticated users
  }

  bool isValidToken(String token) {
    // Implement your token validation logic here
    // For example, check if the token is expired or if it is a valid token
    // Return true if the token is valid, false otherwise
    // You can use external libraries like JWT to validate the token
    return true; // Replace this with your token validation logic
  }
}
