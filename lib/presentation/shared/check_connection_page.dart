import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shoper_flutter/routes/app_routes.dart';

class CheckConnectionPage extends StatelessWidget {
  const CheckConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check Connection")),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Check Connection"),
            onPressed: () async {
              final connectivityResult =
                  await Connectivity().checkConnectivity();
              if (connectivityResult == ConnectivityResult.none) {
                _showNetworkErrorDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'You\'re connected to a ${connectivityResult.toString().split('.').last} network')));
                // Navigate to the login screen
                Navigator.pushNamed(context, AppRoutes.loginScreen);
              }
            },
          ),
        ),
      ),
    );
  }

  void _showNetworkErrorDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => NetworkErrorDialog(
        onPressed: () async {
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please turn on your wifi or mobile data')));
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({Key? key, this.onPressed}) : super(key: key);

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/no_connection.png',
              width: 200,
            ),
            const SizedBox(height: 32),
            Text(
              'Whoops!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'No internet connection found.\nCheck your connection and try again.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              child: Text('Try Again'),
            )
          ],
        ));
  }
}
