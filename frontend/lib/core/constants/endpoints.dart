class Endpoints {
  Endpoints._();

  // Auth Endpoints
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String refresh = 'auth/refresh';
  static const String authProfile = 'auth/profile';

  // Task Endpoints
  static const String tasks = 'tasks';
  static String taskById(String id) => 'tasks/$id';
  static String taskToggle(String id) => 'tasks/$id/toggle';
}
