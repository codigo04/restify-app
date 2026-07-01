import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/auth/data/dto/request/login_request.dart';
import 'package:restifyapp/feature/auth/data/dto/response/login_response.dart';

abstract class LoginDataSource {
  Future<LoginResponse> login(String username, String password);
}

@LazySingleton(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  final ApiClient _client;

  LoginDataSourceImpl(this._client);

  @override
  Future<LoginResponse> login(String username, String password) async {
    try {
      final request = LoginRequest(username: username, password: password);

      final response = await _client.dio.post(
        '/api/v1/auth-service/authentication/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception('Error en login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[LoginDataSource] DioException type: ${e.type}');
      debugPrint('[LoginDataSource] message: ${e.message}');
      debugPrint('[LoginDataSource] response: ${e.response}');
      throw Exception('Error de conexión: ${e.type} - ${e.message}');
    } catch (e) {
      debugPrint('[LoginDataSource] unexpected error: $e');
      throw Exception('Error inesperado: $e');
    }
  }
}
