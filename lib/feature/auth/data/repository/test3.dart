import 'package:restifyapp/feature/auth/domain/model/user.dart';

abstract class LoginRepository {
  Future<User> login(String email, String password);
}
