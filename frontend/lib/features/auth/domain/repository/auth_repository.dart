import 'package:task_management/features/auth/data/entity/auth_result_entity.dart';
import 'package:task_management/features/auth/data/entity/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResultEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> register({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String password,
  });

  Future<UserEntity> getProfile();

  Future<void> logout();
}
