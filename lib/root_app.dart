import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/root_view_model.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/login_screen.dart';

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

    final home = showHomeScreen ? HomeScreen.route() : LoginScreen.route();

    return MaterialApp(
      title: 'Meow Music',
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
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
      },
      onGenerateInitialRoutes: (_) => [home],
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
