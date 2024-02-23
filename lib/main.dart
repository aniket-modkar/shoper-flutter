import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shoper_flutter/core/service/auth_guard.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';
import 'package:shoper_flutter/firebase_api.dart';
import 'package:shoper_flutter/presentation/shared/check_connection_page.dart';
import 'core/app_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';

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
  try {
    print('init');
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyABNq5_6F602wafP5_spG4u8DrS4KQ2984",
          authDomain: "com.example.shoper",
          projectId: "shoper-d7dbc",
          appId: '1:122379848461:android:a049be66aaa7e22144be44',
          messagingSenderId: '122379848461'),
    );

    await FirebaseApi().initNotification();
  } catch (e) {
    // Handle initialization or notification initialization errors
    print("Error initializing Firebase or setting up notifications: $e");
    // You can display a user-friendly message or perform other error handling actions based on your requirements.
  }
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
  final StorageService _storageService = StorageService();

  final AuthGuard _authGuard = AuthGuard(); // Instantiate the AuthGuard
  bool _isConnected = true; // Initially assuming connected

  @override
  void initState() {
    super.initState();
    // _initConnectivity();
    // Connectivity().onConnectivityChanged.listen((result) {
    //   setState(() {
    //     _isConnected = result != ConnectivityResult.none;
    //     print('internet Connection:$_isConnected');
    //     if (_isConnected == false) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => CheckConnectionPage(),
    //         ),
    //       );
    //     }
    //   });
    // });
    final fcm = _storageService.getStoredResponseFromLocalStorage('FCM Token');
    print(fcm);
  }

  Future<void> _initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
      if (_isConnected == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckConnectionPage(),
          ),
        );
      }
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
      initialRoute: AppRoutes.loginScreen,

      routes: AppRoutes.routes,
      navigatorObservers: [_authGuard], // Pass the AuthGuard instance
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
