import 'dart:html';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://stage-apis.hdexch.com/';

  ApiService();

  Future<http.Response> fetchData(String path) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.get(uri);
      return response;
    } catch (error) {
      // Handle errors here
      throw Exception('Failed to load data: $error');
    }
  }

  // You can add more methods for other types of requests (POST, PUT, etc.)
  Future<http.Response> postData(String path, Map<String, dynamic> body) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.post(
        uri,
        body: body,
        // headers: {
        //   'Content-Type': 'X-auth-token',
        //   'bearer ': '' // adjust content type if needed
        // },
      );
      return response;
    } catch (error) {
      // Handle errors here
      throw Exception('Failed to post data: $error');
    }
  }
}
// 'api/v1/account/login'