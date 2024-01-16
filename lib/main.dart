import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shoper_flutter/core/service/auth_guard.dart';
import 'core/app_export.dart';

class ApiInterceptor implements InterceptorContract {
  final HttpClientWithInterceptor _client;

  ApiInterceptor()
      : _client = HttpClientWithInterceptor.build(interceptors: []);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // Implement your request interception logic here
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // Implement your response interception logic here
    return data;
  }

  // Getter for the HttpClientWithInterceptor instance
  HttpClientWithInterceptor get client => _client;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final apiInterceptor = ApiInterceptor();

  // Pass the client to the AppRoutes to be used for API calls
  AppRoutes.client = apiInterceptor.client;

  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthGuard _authGuard = AuthGuard(); // Instantiate the AuthGuard

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'shoper_flutter',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorService.navigatorKey,
      localizationsDelegates: [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale(
          'en',
          '',
        ),
      ],
      navigatorObservers: [_authGuard], // Pass the AuthGuard instance
      initialRoute: AppRoutes.loginScreen,
      // initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
    );
  }
}
