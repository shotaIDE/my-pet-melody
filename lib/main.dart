import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/data/di/api_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/service/storage_service_local_flask.dart';
import 'package:meow_music/firebase_options_dev.dart' as dev;
import 'package:meow_music/firebase_options_emulator.dart' as emulator;
import 'package:meow_music/flavor.dart';
import 'package:meow_music/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseOptions options;
  switch (F.flavor) {
    case Flavor.emulator:
      options = emulator.DefaultFirebaseOptions.currentPlatform;
      break;
    case Flavor.dev:
      options = dev.DefaultFirebaseOptions.currentPlatform;
      break;
  }
  await Firebase.initializeApp(options: options);

  final List<Override> overrides;

  if (F.flavor == Flavor.emulator) {
    const serverHost = AppDefinitions.serverHost;
    await FirebaseAuth.instance.useAuthEmulator(serverHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(serverHost, 8080);
    await FirebaseStorage.instance.useStorageEmulator(serverHost, 9199);

    overrides = [
      // Use Flask endpoint in Emulator flavor,
      // because the Python lib for Firebase Emulator is
      // not able to use Firebase Storage.
      storageServiceProvider.overrideWith(
        (ref) => StorageServiceLocalFlask(
          api: ref.watch(storageApiProvider),
        ),
      ),
    ];
  } else {
    overrides = [];
  }

  runApp(
    ProviderScope(
      overrides: overrides,
      child: RootApp(),
    ),
  );
}
