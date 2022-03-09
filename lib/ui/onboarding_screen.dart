import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/onboarding_state.dart';
import 'package:meow_music/ui/onboarding_view_model.dart';

final onboardingViewModelProvider =
    StateNotifierProvider.autoDispose<OnboardingViewModel, OnboardingState>(
  (ref) => OnboardingViewModel(
    settingsUseCase: ref.watch(settingsUseCaseProvider),
  ),
);

class OnboardingScreen extends ConsumerStatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  static const name = 'OnboardingScreen';

  final viewModel = onboardingViewModelProvider;

  static MaterialPageRoute route() => MaterialPageRoute<OnboardingScreen>(
        builder: (_) => OnboardingScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<OnboardingScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'ネコちゃんが歌う\nオリジナル曲を作ろう',
          bodyWidget: Image.asset(
            'assets/images/singing_cat.png',
          ),
        ),
        PageViewModel(
          title: '3つ鳴き声を録音して\nBGMを選ぶだけ！',
          bodyWidget: Image.asset(
            'assets/images/generate_steps.png',
          ),
        ),
        PageViewModel(
          title: 'できた作品は\nみんなにシェアしよう',
          bodyWidget: Image.asset(
            'assets/images/share.png',
          ),
        ),
      ],
      showSkipButton: true,
      skip: const Text('スキップ'),
      next: const Text('次へ'),
      done: const Text('始める'),
      onDone: _onDone,
      controlsPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      isTopSafeArea: true,
      isBottomSafeArea: true,
    );
  }

  Future<void> _onDone() async {
    await ref.read(widget.viewModel.notifier).onDone();

    if (!mounted) {
      return;
    }

    await Navigator.pushReplacement<HomeScreen, void>(
      context,
      HomeScreen.route(shouldStartCreationAutomatically: true),
    );
  }
}
