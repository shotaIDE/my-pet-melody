// ignore_for_file: prefer-match-file-name

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final fullVersionNameProvider = FutureProvider((_) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final versionName = packageInfo.version;
  final buildNumber = packageInfo.buildNumber;
  return '$versionName ($buildNumber)';
});

final buildNumberProvider = FutureProvider((_) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final buildNumberString = packageInfo.buildNumber;
  return int.parse(buildNumberString);
});

final androidDeviceSdkIntProvider = FutureProvider((_) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
  return androidDeviceInfo.version.sdkInt;
});
