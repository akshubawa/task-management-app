import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<void> setAccessToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_keyAccessToken);
    } else {
      await prefs.setString(_keyAccessToken, token);
    }
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  static Future<void> setRefreshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_keyRefreshToken);
    } else {
      await prefs.setString(_keyRefreshToken, token);
    }
  }

  static Future<void> clearAuthData() async {
    await setAccessToken(null);
    await setRefreshToken(null);
  }
}
