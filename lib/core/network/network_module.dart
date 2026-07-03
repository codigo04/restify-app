import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/auth_interceptor.dart';

@module
abstract class NetworkModule {
  @Named('BaseUrl') // Entorno desarrollo
  String get baseUrl => 'http://192.168.18.45:8080';


  @lazySingleton
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  @lazySingleton
  Interceptor authInterceptor(FlutterSecureStorage storage) =>
      AuthInterceptor(storage);
  // @lazySingleton
  // ApiClient apiClient(@Named('BaseUrl') String baseUrl) =>
  //     ApiClient(authInterceptor: authInterceptor, baseUrl: baseUrl);
}
