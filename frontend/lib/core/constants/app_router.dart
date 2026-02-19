import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/core/di/injector.dart';
import 'package:task_management/features/auth/domain/repository/auth_repository.dart';
import 'package:task_management/features/auth/presentation/cubit/login_cubit.dart';
import 'package:task_management/features/auth/presentation/cubit/register_cubit.dart';
import 'package:task_management/features/auth/presentation/view/login_page.dart';
import 'package:task_management/features/auth/presentation/view/sign_up_page.dart';
import 'package:task_management/features/task/domain/repository/task_repository.dart';
import 'package:task_management/features/task/presentation/cubit/task_cubit.dart';
import 'package:task_management/features/task/presentation/view/task_dashboard_page.dart';
import 'package:task_management/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';

  static const String home = '/home';

  static const String login = '/login';

  static const String signUp = '/sign-up';

  static const String initialRoute = splash;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings: settings);
      case home:
        return _buildRoute(
          BlocProvider(
            create: (_) => TaskCubit(Injector.instance<TaskRepository>())..loadTasks(),
            child: const TaskDashboardPage(),
          ),
          settings: settings,
        );
      case login:
        return _buildRoute(
          BlocProvider(
            create: (_) => LoginCubit(Injector.instance<AuthRepository>()),
            child: const LoginPage(),
          ),
          settings: settings,
        );
      case signUp:
        return _buildRoute(
          BlocProvider(
            create: (_) => RegisterCubit(Injector.instance<AuthRepository>()),
            child: const SignUpPage(),
          ),
          settings: settings,
        );
      default:
        return _buildRoute(const NotFoundPage(), settings: settings);
    }
  }

  static MaterialPageRoute _buildRoute(
    Widget page, {
    required RouteSettings settings,
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, void>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static void goBack(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Page Not Found'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => AppRouter.goBack(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

