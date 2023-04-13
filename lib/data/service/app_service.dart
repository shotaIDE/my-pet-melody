// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final fullVersionNameProvider = FutureProvider((_) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final versionName = packageInfo.version;
  final buildNumber = packageInfo.buildNumber;
  return '$versionName ($buildNumber)';
});
