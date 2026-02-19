import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

Future<String> getPlatformName() async {
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  return 'unknown';
}

Future<String> getAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  return info.version; // from pubspec.yaml
}
