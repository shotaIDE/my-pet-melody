import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/onboarding_state.dart';
import 'package:meow_music/ui/onboarding_view_model.dart';

final onboardingViewModelProvider =
    StateNotifierProvider.autoDispose<OnboardingViewModel, OnboardingState>(
  (ref) => OnboardingViewModel(
    ref: ref,
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
          titleWidget: Text(
            'あなたのねこが歌う\nオリジナル曲を作ろう',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          bodyWidget: Image.asset(
            'assets/images/singing_cat.png',
          ),
        ),
        PageViewModel(
          titleWidget: Text(
            'ねこが鳴いてる動画を\n選ぶだけで完成',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          bodyWidget: Image.asset(
            'assets/images/generate_steps.png',
          ),
        ),
        PageViewModel(
          titleWidget: Text(
            'できた作品は\nみんなにシェアしよう',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
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
