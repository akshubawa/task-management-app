import 'package:equatable/equatable.dart';
import 'package:task_management/features/auth/data/entity/user_entity.dart';

class AuthResultEntity extends Equatable {
  const AuthResultEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
