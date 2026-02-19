import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/features/auth/domain/repository/auth_repository.dart';
import 'package:task_management/features/auth/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository) : super(const LoginInitial());

  final AuthRepository _repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());
    try {
      final result = await _repository.login(
        email: email.trim(),
        password: password,
      );
      emit(LoginSuccess(result));
    } catch (e) {
      final message =
          e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Login failed';
      emit(LoginFailure(message));
    }
  }

  void reset() {
    emit(const LoginInitial());
  }
}
