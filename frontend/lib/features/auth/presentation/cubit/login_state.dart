import 'package:equatable/equatable.dart';
import 'package:task_management/features/auth/data/entity/auth_result_entity.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.result);

  final AuthResultEntity result;

  @override
  List<Object?> get props => [result];
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
