import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoper_flutter/core/constants/constants.dart';
import 'package:shoper_flutter/presentation/login_screen/shared_login_preferences.dart';

class StorageService {
  Future<void> saveResponseToLocalStorage(String key, String jsonString) async {
    Map<String, dynamic> loginResponseMap = jsonDecode(jsonString);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the JSON string to local storage
    prefs.setString(key, jsonString);
  }

  Future<LoginResponse?> getStoredResponseFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the stored JSON string
    String? jsonString = prefs.getString(key);

    // If the string is not null, decode it and create a LoginResponse object
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return LoginResponse.fromJson(jsonMap);
    }

    // Return null if the stored string is null or decoding fails
    return null;
  }

  Future<String?> getTokenFromStorage() async {
    final LoginResponse? storedResponse =
        await getStoredResponseFromLocalStorage(loginResponse);
    return storedResponse?.result?.token;
  }
}
