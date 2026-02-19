import 'package:dio/dio.dart' show Response;
import 'package:task_management/core/constants/endpoints.dart';
import 'package:task_management/core/services/api_service.dart';
import 'package:task_management/features/auth/data/entity/auth_result_entity.dart';
import 'package:task_management/features/auth/data/entity/user_entity.dart';
import 'package:task_management/features/auth/data/model/login_response_model.dart';
import 'package:task_management/features/auth/data/model/register_response_model.dart';
import 'package:task_management/features/auth/data/model/user_model.dart';
import 'package:task_management/features/auth/data/datasource/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._api);

  final ApiService _api;

  @override
  Future<AuthResultEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
        requiresAuth: false,
      );
      _validateStatus(response);
      final model = LoginResponseModel.fromJson(
        _responseData(response),
      );
      if (!model.status || model.data.accessToken.isEmpty) {
        throw Exception(model.message.isNotEmpty ? model.message : 'Login failed');
      }
      return AuthResultEntity(
        user: model.data.user,
        accessToken: model.data.accessToken,
        refreshToken: model.data.refreshToken,
      );
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        Endpoints.register,
        data: {
          'fullName': fullName,
          'mobileNumber': mobileNumber,
          'email': email,
          'password': password,
        },
        requiresAuth: false,
      );
      _validateStatus(response);
      final model = RegisterResponseModel.fromJson(
        _responseData(response),
      );
      if (!model.status) {
        throw Exception(model.message.isNotEmpty ? model.message : 'Registration failed');
      }
      return model.data;
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<UserEntity> getProfile() async {
    try {
      final response = await _api.get(Endpoints.authProfile);
      _validateStatus(response);
      final data = _responseData(response);
      final dataObj = data['data'];
      if (dataObj is! Map<String, dynamic>) {
        throw Exception('Invalid profile response');
      }
      return UserModel.fromJson(dataObj);
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  Map<String, dynamic> _responseData(Response response) {
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }
    return data;
  }

  void _validateStatus(Response response) {
    final code = response.statusCode ?? 0;
    if (code >= 200 && code < 300) return;
    final data = response.data;
    String? message;
    if (data is Map<String, dynamic>) {
      message = data['message'] as String?;
    }
    throw Exception(message ?? 'Request failed with status $code');
  }

  String _messageFromError(dynamic e) {
    if (e is String && e.isNotEmpty) return e;
    if (e is Exception) return e.toString().replaceFirst('Exception: ', '');
    return 'Something went wrong. Please try again.';
  }
}
