import 'dart:convert';
import 'package:dio/dio.dart';
import 'storage_service.dart';

class ApiService {
  final String baseUrl = 'https://dev-shoper.technomize.com/';

  final Dio dio;
  final StorageService storageService;

  ApiService(this.dio, this.storageService);

  Future<Response> fetchData(String path,
      {Map<String, String>? headers}) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final response =
          await dio.getUri(uri, options: Options(headers: headers));
      return response;
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

  Future<Response> postData(String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    try {
      final response = await dio.postUri(uri,
          data: body, options: Options(headers: headers));
      return response;
    } catch (error) {
      throw Exception('Failed to post data: $error');
    }
  }
}
