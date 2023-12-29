import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoper_flutter/presentation/login_screen/sharedLoginPreferences.dart';

class StorageService {
  Future<void> saveResponseToLocalStorage(LoginResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the LoginResponse object to a JSON-encoded string
    String jsonString = jsonEncode(response.toJson());

    // Save the JSON string to local storage
    prefs.setString('login_response', jsonString);
  }

  Future<LoginResponse?> getStoredResponseFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored JSON string
    String? jsonString = prefs.getString('login_response');

    // If the string is not null, decode it and create a LoginResponse object
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return LoginResponse.fromJson(jsonMap);
    }

    // Return null if the stored string is null
    return null;
  }

  Future<String?> getTokenFromStorage() async {
    final LoginResponse? storedResponse =
        await getStoredResponseFromLocalStorage();
    return storedResponse?.result.token;
  }
}
