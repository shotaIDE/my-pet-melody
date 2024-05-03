import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/root_state.dart';
import 'package:my_pet_melody/root_view_model.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/home_screen.dart';
import 'package:my_pet_melody/ui/login_screen.dart';
import 'package:my_pet_melody/update_app_screen.dart';

class RootApp extends ConsumerStatefulWidget {
  RootApp({super.key});

  final viewModel = rootViewModelProvider;

  @override
  ConsumerState<RootApp> createState() => _RootAppState();
}

class _RootAppState extends ConsumerState<RootApp> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);
    final startPage = state.startPage;

    if (startPage == null) {
      return Container();
    }

    final initialRoutes = _initialRoutes(startPage);

    final navigatorObservers = <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ];

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.myPetMelody,
      theme: ThemeData(
        useMaterial3: false,
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
      // `initialRoute` and `routes` are ineffective settings
      // that are set to avoid assertion errors.
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
      },
      onGenerateInitialRoutes: (_) => initialRoutes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: navigatorObservers,
    );
  }

  List<MaterialPageRoute<Widget>> _initialRoutes(
    StartPage startPage,
  ) {
    switch (startPage) {
      case StartPage.updateApp:
        return [
          UpdateAppScreen.route(),
        ];
      case StartPage.login:
        return [
          LoginScreen.route(),
        ];
      case StartPage.home:
        return [
          HomeScreen.route(),
        ];
    }
  }
}
