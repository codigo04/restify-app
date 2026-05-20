import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/auth/data/datasource/login_datasource.dart';
import 'package:restifyapp/feature/auth/domain/model/user.dart';
import 'package:restifyapp/feature/auth/data/repository/test3.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImpl({required this.dataSource});

  @override
  Future<User> login(String email, String password) async {
    try {
      final loginResponse = await dataSource.login(email, password);

      // Convertir LoginResponse a User (mapeo de DTO a Domain Model)
      return User(
        id: loginResponse.data.idUsuario,
        email: email,
        idEmpresa: loginResponse.data.empresa.idEmpresa,
        nombreEmpresa: loginResponse.data.empresa.nombreComercial,
        razonSocial: loginResponse.data.empresa.razonSocial,
        ruc: loginResponse.data.empresa.ruc,
        rolId: loginResponse.data.rolResponse.id,
        rolNombre: loginResponse.data.rolResponse.nombre,
        token: loginResponse.data.token,
        verificado: loginResponse.data.verificado,
      );
    } catch (e) {
      rethrow;
    }
  }
}
