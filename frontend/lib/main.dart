import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_router.dart';
import 'package:task_management/core/constants/app_theme.dart';
import 'package:task_management/core/di/injector.dart';
import 'package:task_management/core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.setLightStatusBar();
  Injector.setup();
  await Injector.instance<ApiService>().initializeToken();

  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
          title: 'Task Management',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: (settings) {
            return AppRouter.generateRoute(settings);
          },
        );
      },
    );
  }
}
