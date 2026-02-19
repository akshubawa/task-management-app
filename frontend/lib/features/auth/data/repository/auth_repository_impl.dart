import 'package:task_management/core/services/api_service.dart';
import 'package:task_management/core/services/local_storage.dart';
import 'package:task_management/features/auth/data/entity/auth_result_entity.dart';
import 'package:task_management/features/auth/data/entity/user_entity.dart';
import 'package:task_management/features/auth/domain/repository/auth_repository.dart';
import 'package:task_management/features/auth/data/datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._api);

  final AuthRemoteDataSource _remote;
  final ApiService _api;

  @override
  Future<AuthResultEntity> login({
    required String email,
    required String password,
  }) async {
    final result = await _remote.login(email: email, password: password);
    await LocalStorage.setAccessToken(result.accessToken);
    await LocalStorage.setRefreshToken(result.refreshToken);
    _api.setAuthToken(result.accessToken);
    return result;
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String password,
  }) async {
    return _remote.register(
      fullName: fullName,
      mobileNumber: mobileNumber,
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> getProfile() async {
    return _remote.getProfile();
  }

  @override
  Future<void> logout() async {
    await LocalStorage.clearAuthData();
    _api.clearAuthToken();
  }
}
