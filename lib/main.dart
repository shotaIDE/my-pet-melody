import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/di/api_providers.dart';
import 'package:my_pet_melody/data/di/service_providers.dart';
import 'package:my_pet_melody/data/service/storage_service_local_flask.dart';
import 'package:my_pet_melody/firebase_options_dev.dart' as dev;
import 'package:my_pet_melody/firebase_options_emulator.dart' as emulator;
import 'package:my_pet_melody/flavor.dart';
import 'package:my_pet_melody/root_app.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final FirebaseOptions options;
      switch (F.flavor) {
        case Flavor.emulator:
          options = emulator.DefaultFirebaseOptions.currentPlatform;
          break;
        case Flavor.dev:
          options = dev.DefaultFirebaseOptions.currentPlatform;
          break;
        case Flavor.prod:
          // TODO(ide): FIX
          options = dev.DefaultFirebaseOptions.currentPlatform;
          break;
      }
      await Firebase.initializeApp(options: options);

      final List<Override> overrides;

      if (F.flavor == Flavor.emulator) {
        const serverHost = AppDefinitions.serverHostForEmulatorConfiguration;
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

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      runApp(
        ProviderScope(
          overrides: overrides,
          child: RootApp(),
        ),
      );
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}
