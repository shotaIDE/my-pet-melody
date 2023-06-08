import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/root_view_model.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/home_screen.dart';
import 'package:my_pet_melody/ui/login_screen.dart';

class RootApp extends ConsumerStatefulWidget {
  RootApp({Key? key}) : super(key: key);

  final viewModel = rootViewModelProvider;

  @override
  ConsumerState<RootApp> createState() => _RootAppState();
}

class _RootAppState extends ConsumerState<RootApp> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);
    final showHomeScreen = state.showHomeScreen;

    if (showHomeScreen == null) {
      return Container();
    }

    final home = showHomeScreen ? HomeScreen() : LoginScreen();

    return MaterialApp(
      title: 'うちのコメロディー',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'uzura',
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 18),
          titleSmall: TextStyle(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
          bodySmall: TextStyle(fontSize: 16),
          labelLarge: TextStyle(fontSize: 18),
          labelMedium: TextStyle(fontSize: 16),
          labelSmall: TextStyle(fontSize: 14),
        ),
        scaffoldBackgroundColor: Colors.brown[50],
        secondaryHeaderColor: Colors.brown[100],
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                DisplayDefinition.cornerRadiusSizeLarge,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
      home: home,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
    );
  }
}
