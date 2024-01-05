import 'dart:html';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://dev-shoper.technomize.com/';
  final String imgBaseUrl = 'https://dev-shoper.technomize.com/api/';
  // final String baseUrl = 'http://localhost:3000/';
  // final String imgBaseUrl = 'http://localhost:3000/api/';
  final String token =
      'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTk1MDc0NjRhNWFjYjljMTkwNmRmNzUiLCJlbWFpbCI6ImN1c3RvbWVyQGdtYWlsLmNvbSIsInBob25lIjoiNzY5NDQ4NDU2MiIsInR5cGUiOiJDVVNUT01FUiIsImlhdCI6MTcwNDQ0MDIwMiwiZXhwIjoxNzA3MDMyMjAyfQ.1uCXfLGgbLIKqFbpgH57VhzDZDTrLGcAfjbWK2IDhbo';

  ApiService();

  Future<http.Response> fetchData(String path) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      Map<String, String> headers = {'X-auth-token': '${token}'};
      final response = await http.get(
        uri,
        headers: headers,
      );
      return response;
    } catch (error) {
      // Handle errors here
      throw Exception('Failed to load data: $error');
    }
  }

  Future<http.Response> fetchDataWithFilter(
      String path, Map<String, dynamic> queryParams) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      Map<String, String> headers = {'X-auth-token': '${token}'};

      // Convert queryParams to a string and append them to the URL
      String queryString = Uri(queryParameters: queryParams).query;
      final completeUri = uri.replace(query: queryString);

      final response = await http.get(
        completeUri,
        headers: headers,
      );

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
      // Adding headers to the request
      Map<String, String> headers = {
        'X-auth-token': '${token} ' // Include authorization header if needed
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );
      return response;
    } catch (error) {
      throw Exception('Failed to post data: $error');
    }
  }

  Future<http.Response> postDataWithoutBody(
    String path,
  ) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      // Adding headers to the request
      Map<String, String> headers = {
        'X-auth-token': '${token} ' // Include authorization header if needed
      };
      final response = await http.post(
        uri,
        headers: headers,
      );
      return response;
    } catch (error) {
      throw Exception('Failed to post data: $error');
    }
  }
}
