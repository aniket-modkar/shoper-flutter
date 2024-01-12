import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shoper_flutter/core/service/auth_interceptor.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';

class ApiService {
  final String baseUrl = 'https://dev-shoper.technomize.com/';
  final String imgBaseUrl = 'https://dev-shoper.technomize.com/api/';
  // final String baseUrl = 'http://localhost:3000/';
  // final String imgBaseUrl = 'http://localhost:3000/api/';

  static final ApiInterceptor apiInterceptor = ApiInterceptor(StorageService());

  static final HttpClientWithInterceptor client =
      HttpClientWithInterceptor.build(interceptors: [apiInterceptor]);

  ApiService();

  Future<http.Response> fetchData(String path) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final response = await client.get(
        uri,
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
      // Convert queryParams to a string and append them to the URL
      String queryString = Uri(queryParameters: queryParams).query;
      final completeUri = uri.replace(query: queryString);

      final response = await client.get(
        completeUri,
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

      final response = await client.post(
        uri,
        body: body,
      );
      return response;
    } catch (error) {
      throw Exception('Failed to post data: $error');
    }
  }

  Future<http.Response> deteleData(
    String path,
  ) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      // Adding headers to the request

      final response = await client.post(
        uri,
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

      final response = await client.post(
        uri,
      );
      return response;
    } catch (error) {
      throw Exception('Failed to post data: $error');
    }
  }
}
