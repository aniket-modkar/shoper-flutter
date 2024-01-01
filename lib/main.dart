import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shoper_flutter/presentation/login_screen/login_screen.dart';

import 'core/app_export.dart';
import 'core/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ThemeHelper().changeTheme('primary');

  final ApiService apiService = ApiService();
  runApp(MyApp(apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  MyApp(this.apiService);

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
      initialRoute: AppRoutes.loginScreen,
      home: FutureBuilder(
        future: makeApiCall(apiService),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorScreen(); // Replace with your error screen/widget
            } else {
              return HomeScreen(); // Replace with your main screen/widget
            }
          } else {
            return LoadingScreen(); // Replace with your loading screen/widget
          }
        },
      ),
    );
  }

  Future<void> makeApiCall(ApiService apiService) async {
    final path = 'https://dev-shoper.technomize.com/';
    final body = {'key': 'value'};

    try {
      final response = await apiService.postData(path, body);
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      // Check if the response indicates an error
      if (response.statusCode != 200) {
        throw Exception(
            'API request failed with status code: ${response.statusCode}');
      }

      // Add your further processing logic here
    } catch (error, stackTrace) {
      print('API Error: $error');
      print('Stack Trace: $stackTrace');

      if (error is DioError && error.response != null) {
        print('Response Data: ${error.response?.data}');
        print('Response Status Code: ${error.response?.statusCode}');

        // Navigate to the LoginScreen on error
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Screen'),
      ),
      body: Center(
        child: Text('An error occurred.'),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check your conditions here before navigating
    // if (/* Your condition for redirection */) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    // }

    // Continue with the rest of the HomeScreen
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the home screen.'),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
