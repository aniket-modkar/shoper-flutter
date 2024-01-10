import 'package:dio/dio.dart';
import 'storage_service.dart';

class ApiInterceptorService {
  final Dio dio;
  final StorageService storageService;

  ApiInterceptorService(this.dio, this.storageService) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(ApiInterceptor(storageService));
  }
}

class ApiInterceptor extends Interceptor {
  final StorageService storageService;

  ApiInterceptor(this.storageService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('ApiInterceptor onRequest called');

    final token = await storageService.getTokenFromStorage();
    print('Token: $token');

    if (token!.isNotEmpty) {
      options.headers['X-auth-token'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
