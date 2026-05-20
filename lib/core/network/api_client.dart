import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiClient {
  final Dio dio;

  ApiClient({
    required Interceptor authInterceptor,
    @Named('BaseUrl') required String baseUrl,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
           sendTimeout: const Duration(seconds: 10),
           contentType: 'application/json',
         ),
       ) {
    dio.interceptors.add(authInterceptor);
  }
}
