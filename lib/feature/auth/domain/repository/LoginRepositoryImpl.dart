import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/auth/data/datasource/login_datasource.dart';
import 'package:restifyapp/feature/auth/domain/model/user.dart';
import 'package:restifyapp/feature/auth/data/repository/test3.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImpl({required this.dataSource});

  @override
  Future<User> login(String username, String password) async {
    try {
      final loginResponse = await dataSource.login(username, password);
      final authorities = _extractAuthorities(loginResponse.data.token);

      return User(
        id: loginResponse.data.idUsuario,
        email: username,
        idEmpresa: loginResponse.data.empresa.idEmpresa,
        nombreEmpresa: loginResponse.data.empresa.nombreComercial,
        razonSocial: loginResponse.data.empresa.razonSocial,
        ruc: loginResponse.data.empresa.ruc,
        rolId: 0,
        rolNombre: authorities,
        token: loginResponse.data.token,
        verificado: loginResponse.data.verificado,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Decodes the JWT payload and returns the `authorities` claim.
  /// Returns empty string if the token is malformed or the claim is absent.
  String _extractAuthorities(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return '';

      // JWT payload is Base64Url — pad to a multiple of 4
      String payload = parts[1];
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      final remainder = payload.length % 4;
      if (remainder != 0) payload += '=' * (4 - remainder);

      final decoded = utf8.decode(base64Decode(payload));
      final claims = jsonDecode(decoded) as Map<String, dynamic>;
      return (claims['authorities'] as String?) ?? '';
    } catch (_) {
      return '';
    }
  }
}
