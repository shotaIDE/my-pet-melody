import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/onboarding_state.dart';
import 'package:meow_music/ui/onboarding_view_model.dart';
import 'package:meow_music/ui/select_template_screen.dart';

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
          title: 'あなたのわんちゃんのオリジナル曲を作ろう',
          bodyWidget: const Icon(
            Icons.abc,
            size: 128,
          ),
        ),
        PageViewModel(
          title: '３つ鳴き声を録音してかんたん完成！',
          bodyWidget: const Icon(
            Icons.abc,
            size: 128,
          ),
        ),
        PageViewModel(
          title: 'できた作品はみんなにシェアしよう',
          bodyWidget: const Icon(
            Icons.abc,
            size: 128,
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

    await Navigator.pushReplacement<HomeScreen, void>(
      context,
      HomeScreen.route(),
    );
    await Navigator.push<void>(context, SelectTemplateScreen.route());
  }
}
