import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/features/auth/domain/repository/auth_repository.dart';
import 'package:task_management/features/auth/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository) : super(const RegisterInitial());

  final AuthRepository _repository;

  Future<void> register({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoading());
    try {
      final user = await _repository.register(
        fullName: fullName.trim(),
        mobileNumber: mobileNumber.trim(),
        email: email.trim(),
        password: password,
      );
      emit(RegisterSuccess(user));
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Registration failed';
      emit(RegisterFailure(message));
    }
  }

  void reset() {
    emit(const RegisterInitial());
  }
}
