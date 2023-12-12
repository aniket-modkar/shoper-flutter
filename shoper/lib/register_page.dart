import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoper/api_service.dart';
import 'login_page.dart';

class UserData {
  String firstName;
  String lastName;
  String mobile;
  String email;
  String password;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'UserData{firstName: $firstName, lastName: $lastName, mobile: $mobile, email: $email, password: $password}';
  }
}

class RegisterPage extends StatelessWidget {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'mobile': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  Widget _buildTextFormField(
    String labelText, {
    required String key,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(labelText: labelText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $labelText';
            }
            return null;
          },
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userData = UserData(
        firstName: _controllers['firstName']!.text,
        lastName: _controllers['lastName']!.text,
        mobile: _controllers['mobile']!.text,
        email: _controllers['email']!.text,
        password: _controllers['password']!.text,
      );

      try {
        final postData = userData.toMap();
        final response = await _apiService.postData(
            'api/v1/account/adminRegister', postData);

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } catch (error) {
        print('Error: $error');
      }

      print('User Data: $userData');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormField('FirstName', key: 'firstName'),
              _buildTextFormField('LastName', key: 'lastName'),
              _buildTextFormField('Mobile',
                  key: 'mobile', keyboardType: TextInputType.phone),
              _buildTextFormField('Email',
                  key: 'email', keyboardType: TextInputType.emailAddress),
              _buildTextFormField('Password',
                  key: 'password', obscureText: true),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => _registerUser(context),
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
