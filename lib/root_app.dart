import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/root_state.dart';
import 'package:meow_music/root_view_model.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/onboarding_screen.dart';

final rootViewModelProvider =
    StateNotifierProvider.autoDispose<RootViewModel, RootState>(
  (ref) => RootViewModel(
    settingsUseCase: ref.watch(settingsUseCaseProvider),
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

    final home = shouldLaunchOnboarding ? OnboardingScreen() : HomeScreen();

    return MaterialApp(
      title: 'Meow Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
