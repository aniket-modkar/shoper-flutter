import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/presentation/login_screen/login_screen.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color of button
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate back or perform cancel action
                onTapArrowLeft(context);
              },
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 252, 60, 60)),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_emailController.text.isNotEmpty) {
        final response = await _apiService.postData(
            'api/v1/account/sendEmailResetPassword',
            {"email": _emailController.text});
        if (response.statusCode == 202) {
          showSnackBar(context, 'Reset link sent successfully to your email.');
          onTapArrowLeft(context);
        }
      } else {
        showSnackBar(context, 'Enter a valid email.');
      }
    } catch (error) {
      showSnackBar(
          context, 'An error occurred. Please try again later: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void onTapArrowLeft(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            LoginScreen(), // Replace with the actual widget or screen you want to navigate to
      ),
    );
  }
}
