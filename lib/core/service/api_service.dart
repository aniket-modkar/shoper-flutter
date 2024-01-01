import 'package:dio/dio.dart';

class ApiService {
  late Dio _dio;

  // Base URL for your API
  final String baseUrl = 'https://dev-shoper.technomize.com/';

  ApiService() {
    _dio = Dio();
    _configureDio();
  }

  // Optional: You can configure Dio with additional settings
  void _configureDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = 5000; // 5 seconds
    _dio.options.receiveTimeout = 3000; // 3 seconds

    // Add other configurations as needed
  }

  // Set Dio instance if needed (e.g., when using a custom Dio instance)
  void setDioInstance(Dio dio) {
    _dio = dio;
  }

  Future<Response> fetchData(String path) async {
    try {
      print('Request Headers heeee: ${_dio.options.headers}'); // Log headers
      final response = await _dio.get('$baseUrl$path');
      return response;
    } catch (error) {
      // Handle errors here
      throw Exception('Failed to load data: $error');
    }
  }

  Future<Response> postData(String path, Map<String, dynamic> body) async {
    try {
      print('Request Headers shhh: ${_dio.options.headers}'); // Log headers
      final response = await _dio.post('$baseUrl$path', data: body);
      return response;
    } catch (error) {
      throw Exception('Failed to post data: $error');
    }
  }
}
