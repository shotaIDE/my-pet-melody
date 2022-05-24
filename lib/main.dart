import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/firebase_options.dart';
import 'package:meow_music/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance
      .useAuthEmulator(const String.fromEnvironment('API_HOST'), 9099);

  runApp(
    ProviderScope(
      child: RootApp(),
    ),
  );
}
