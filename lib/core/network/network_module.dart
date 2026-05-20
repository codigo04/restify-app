import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/auth_interceptor.dart';

@module
abstract class NetworkModule {
  @Named('BaseUrl') // Entorno desarrollo
  String get baseUrl => 'http://10.216.49.120:8083';

  // @Named('BaseUrl') // Entorno produccion
  // String get baseUrl => 'https://night-pass-go-api-fcigf.us-east-1.migetapp.com';
  //String get baseUrl => 'https://night-pass-go-api.onrender.com';

  @lazySingleton
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  @lazySingleton
  Interceptor authInterceptor(FlutterSecureStorage storage) =>
      AuthInterceptor(storage);
  // @lazySingleton
  // ApiClient apiClient(@Named('BaseUrl') String baseUrl) =>
  //     ApiClient(authInterceptor: authInterceptor, baseUrl: baseUrl);
}
