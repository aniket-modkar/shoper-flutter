import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shoper_flutter/core/service/auth_guard.dart';
import 'package:shoper_flutter/presentation/shared/check_connection_page.dart';
import 'core/app_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  // Initialize DataBloc
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthGuard _authGuard = AuthGuard(); // Instantiate the AuthGuard
  bool _isConnected = true; // Initially assuming connected

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
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
      navigatorObservers: [_authGuard], // Pass the AuthGuard instance
      initialRoute: _isConnected ? AppRoutes.loginScreen : '/',
      // initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.routes,
      home: _isConnected ? null : CheckConnectionPage(),
    );
  }
}

class MyDataProvider extends ChangeNotifier {
  String data = "Hello";

  void updateData(String newData) {
    data = newData;
    notifyListeners();
  }
}
