// ignore_for_file: prefer-match-file-name

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ensureActivateFetchedRemoteConfigsActionProvider = Provider((_) {
  return FirebaseRemoteConfig.instance.activate;
});

final updatedRemoteConfigKeysProvider = StreamProvider((_) {
  return FirebaseRemoteConfig.instance.onConfigUpdated.map(
    (event) => event.updatedKeys,
  );
});

final minimumBuildNumberProvider = FutureProvider((_) async {
  final key =
      Platform.isIOS ? 'iosMinimumBuildNumber' : 'androidMinimumBuildNumber';
  return FirebaseRemoteConfig.instance.getInt(key);
});
