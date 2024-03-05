import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';
import 'package:shoper_flutter/routes/app_routes.dart';

class AuthGuard extends RouteObserver<PageRoute<dynamic>> {
  final StorageService _storageService = StorageService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);

    final token = await _storageService.getTokenFromStorage();

    if (route.settings.name == AppRoutes.initialScreen) {
      return;
    }

    if (token == null || !isValidToken(token)) {
      if (route.settings.name == AppRoutes.loginScreen ||
          route.settings.name == AppRoutes.registerScreen) {
        return;
      } else {
        Navigator.of(route.navigator!.context).pushReplacementNamed(
          AppRoutes.loginScreen,
        );
      }
    } else if (token.isNotEmpty &&
        route.settings.name == AppRoutes.loginScreen) {
      Navigator.of(route.navigator!.context).pushReplacementNamed(
        AppRoutes.dashboardPage,
      );
    } else if (token.isNotEmpty &&
        route.settings.name == AppRoutes.registerScreen) {
      Navigator.of(route.navigator!.context).pushReplacementNamed(
        AppRoutes.dashboardPage,
      );
    }
  }

  bool isValidToken(String token) {
    // Implement your token validation logic here
    // For example, check if the token is expired or if it is a valid token
    // Return true if the token is valid, false otherwise
    // You can use external libraries like JWT to validate the token
    return true; // Replace this with your token validation logic
  }
}
