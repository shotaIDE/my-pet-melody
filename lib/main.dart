import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/api/storage_api.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/logger/error_reporter.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service_mock.dart';
import 'package:my_pet_melody/data/service/storage_service_firebase.dart';
import 'package:my_pet_melody/data/service/storage_service_local_flask.dart';
import 'package:my_pet_melody/firebase_options_dev.dart' as dev;
import 'package:my_pet_melody/firebase_options_emulator.dart' as emulator;
import 'package:my_pet_melody/firebase_options_prod.dart' as prod;
import 'package:my_pet_melody/flavor.dart';
import 'package:my_pet_melody/root_app.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final FirebaseOptions options;
      switch (flavor) {
        case Flavor.emulator:
          options = emulator.DefaultFirebaseOptions.currentPlatform;
          break;
        case Flavor.dev:
          options = dev.DefaultFirebaseOptions.currentPlatform;
          break;
        case Flavor.prod:
          options = prod.DefaultFirebaseOptions.currentPlatform;
          break;
      }
      await Firebase.initializeApp(options: options);

      final overrides = <Override>[];

      if (flavor == Flavor.emulator) {
        await FirebaseAuth.instance.useAuthEmulator(serverHost, 9099);
        FirebaseFirestore.instance.useFirestoreEmulator(serverHost, 8080);
        await FirebaseStorage.instance.useStorageEmulator(serverHost, 9199);

        overrides.addAll([
          // Use Flask endpoint in Emulator flavor,
          // because the Python lib for Firebase Emulator is
          // not able to use Firebase Storage.
          storageServiceProvider.overrideWith(
            (ref) => StorageServiceLocalFlask(
              api: ref.watch(storageApiProvider),
            ),
          ),
        ]);
      }

      if (flavor != Flavor.prod) {
        overrides.addAll([
          isPremiumPlanProvider.overrideWith((ref) {
            final isPremiumPlan = ref.watch(isPremiumPlanStateProviderMock);
            return isPremiumPlan;
          }),
          purchaseActionsProvider.overrideWith((ref) {
            final errorReporter = ref.watch(errorReporterProvider);
            return PurchaseActionsMock(errorReporter: errorReporter);
          }),
        ]);
      }

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      if (flavor == Flavor.prod) {
        await Purchases.setLogLevel(LogLevel.debug);

        final PurchasesConfiguration configuration;
        if (Platform.isIOS) {
          configuration = PurchasesConfiguration(
            revenueCatPublicAppleApiKey,
          );
        } else {
          configuration = PurchasesConfiguration(
            revenueCatPublicGoogleApiKey,
          );
        }
        await Purchases.configure(configuration);
      }

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

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
