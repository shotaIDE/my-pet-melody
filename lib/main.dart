import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/firebase_options.dart';
import 'package:meow_music/flavor.dart';
import 'package:meow_music/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (F.flavor == Flavor.emulator) {
    const serverHost = AppDefinitions.serverHost;
    await FirebaseAuth.instance.useAuthEmulator(serverHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(serverHost, 8080);
    await FirebaseStorage.instance.useStorageEmulator(serverHost, 9199);
  }

  runApp(
    ProviderScope(
      child: RootApp(),
    ),
  );
}
