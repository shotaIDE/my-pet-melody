import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/root_state.dart';
import 'package:meow_music/root_view_model.dart';
import 'package:meow_music/ui/home_screen.dart';

final rootViewModelProvider =
    StateNotifierProvider.autoDispose<RootViewModel, RootState>(
  (ref) => RootViewModel(
    ref: ref,
    listener: ref.listen,
  ),
);

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
    final shouldLaunchOnboarding = state.shouldLaunchOnboarding;

    if (shouldLaunchOnboarding == null) {
      return Container();
    }

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
      home: HomeScreen(),
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
