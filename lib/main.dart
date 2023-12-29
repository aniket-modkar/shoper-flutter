import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shoper_flutter/core/service/interceptor_service.dart';
import 'core/app_export.dart';
import 'core/service/api_service.dart';
import 'core/service/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StorageService storageService;
  late ApiInterceptorService apiInterceptorService;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    storageService = StorageService();
    apiInterceptorService = ApiInterceptorService(storageService);
    apiService = ApiService(apiInterceptorService.dio, storageService);

    // Example API call
    makeApiCall();
  }

  Future<void> makeApiCall() async {
    final path = '/your/api/endpoint';
    final body = {'key': 'value'};

    try {
      final response = await apiService.postData(path, body);
      print('API Response: ${response.statusCode}');
      print('Response Data: ${response}');
    } catch (error) {
      print('API Error: $error');
    }
  }

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
      routes: AppRoutes.routes,
    );
  }
}
