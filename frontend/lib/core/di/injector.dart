import 'package:get_it/get_it.dart';
import 'package:task_management/core/services/api_service.dart';
import 'package:task_management/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_management/features/auth/data/datasource/auth_remote_data_source_impl.dart';
import 'package:task_management/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task_management/features/auth/domain/repository/auth_repository.dart';
import 'package:task_management/features/task/data/datasource/task_remote_data_source.dart';
import 'package:task_management/features/task/data/datasource/task_remote_data_source_impl.dart';
import 'package:task_management/features/task/data/repository/task_repository_impl.dart';
import 'package:task_management/features/task/domain/repository/task_repository.dart';

class Injector {
  Injector._();

  static final GetIt instance = GetIt.instance;

  static void setup() {
    // Services
    instance.registerLazySingleton<ApiService>(() => ApiService());

    // Auth
    instance.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(instance<ApiService>()),
    );
    instance.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        instance<AuthRemoteDataSource>(),
        instance<ApiService>(),
      ),
    );

    // Task
    instance.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(instance<ApiService>()),
    );
    instance.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(instance<TaskRemoteDataSource>()),
    );
  }

  static void reset() {
    instance.reset();
  }
}
