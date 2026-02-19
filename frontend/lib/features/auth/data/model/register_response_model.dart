import 'package:task_management/features/auth/data/model/user_model.dart';

class RegisterResponseModel {
  RegisterResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final UserModel data;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: UserModel.fromJson(
        (json['data'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}
