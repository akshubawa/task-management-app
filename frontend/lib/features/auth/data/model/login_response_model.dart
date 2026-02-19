import 'package:task_management/features/auth/data/model/user_model.dart';

class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final LoginDataModel data;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: LoginDataModel.fromJson(
        (json['data'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}

class LoginDataModel {
  LoginDataModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      user: UserModel.fromJson(
        (json['user'] as Map<String, dynamic>? ?? {}),
      ),
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }
}
