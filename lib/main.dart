import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/root_app.dart';

void main() {
  runApp(
    ProviderScope(
      child: RootApp(),
    ),
  );
}
