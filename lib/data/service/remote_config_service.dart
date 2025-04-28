// ignore_for_file: prefer-match-file-name

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<Future<bool> Function()>
    ensureActivateFetchedRemoteConfigsActionProvider = Provider((_) {
  return FirebaseRemoteConfig.instance.activate;
});

final StreamProvider<Set<String>> updatedRemoteConfigKeysProvider =
    StreamProvider((_) {
  return FirebaseRemoteConfig.instance.onConfigUpdated.map(
    (event) => event.updatedKeys,
  );
});

final FutureProvider<int> minimumBuildNumberProvider = FutureProvider((_) {
  final key =
      Platform.isIOS ? 'iosMinimumBuildNumber' : 'androidMinimumBuildNumber';
  return FirebaseRemoteConfig.instance.getInt(key);
});
