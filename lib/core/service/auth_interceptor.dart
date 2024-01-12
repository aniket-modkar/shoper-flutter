import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';

class ApiInterceptor implements InterceptorContract {
  final StorageService storageService;

  ApiInterceptor(this.storageService);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // print('ApiInterceptor onRequest called');

    final token = await storageService.getTokenFromStorage();
    // print('Token: $token');

    // Append the 'X-auth-token' header to the request
    data.headers['X-auth-token'] = 'bearer $token';

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // This method can be used for logging or modifying the response
    // print('ApiInterceptor onResponse called');
    return data;
  }
}

void main() async {
  final client = http.Client();
  final request =
      http.Request('GET', Uri.parse('https://dev-shoper.technomize.com/'));
  request.headers['cache-control'] = 'no-cache'; // Disable caching

  final response = await client.send(request);

  // Convert the streamed response to a normal response
  final httpResponse = await http.Response.fromStream(response);

  // Handle the response
  print('Response status code: ${httpResponse.statusCode}');
  print('Response body: ${httpResponse.body}');

  // Close the client when done
  client.close();
}
