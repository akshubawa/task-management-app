import 'package:equatable/equatable.dart';
import 'package:task_management/features/auth/data/entity/user_entity.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

final class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class RegisterFailure extends RegisterState {
  const RegisterFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
