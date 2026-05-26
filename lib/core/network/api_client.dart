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
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           sendTimeout: const Duration(seconds: 15),
           contentType: 'application/json',
         ),
       ) {
    dio.interceptors.add(authInterceptor);
  }
}
