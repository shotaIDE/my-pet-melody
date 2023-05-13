import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/component/social_login_button.dart';
import 'package:meow_music/ui/component/speaking_cat_image.dart';
import 'package:meow_music/ui/home_screen.dart';
import 'package:meow_music/ui/login_state.dart';
import 'package:meow_music/ui/login_view_model.dart';

final _loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(
    ref: ref,
  ),
);

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({
    Key? key,
  }) : super(key: key);

  static const name = 'LoginScreen';

  final viewModel = _loginViewModelProvider;

  static MaterialPageRoute<LoginScreen> route() =>
      MaterialPageRoute<LoginScreen>(
        builder: (_) => LoginScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<LoginScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final title = Text(
      'アカウントを\n作成しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    const description = Text(
      '大切な作品をバックアップするために、アカウントを作成してね！',
      textAlign: TextAlign.center,
    );

    final socialLoginButtonTheme = Theme.of(context).copyWith(
      // Specify a default text theme to apply the system font to
      //　"Continue with Apple" button according to Apple's design guidelines.
      textTheme: const TextTheme(),
    );
    final loginWithTwitterButton = ContinueWithTwitterButton(
      onPressed: _loginWithTwitter,
    );
    final loginWithFacebookButton = ContinueWithFacebookButton(
      onPressed: () {},
    );
    final loginWithAppleButton = ContinueWithAppleButton(
      onPressed: () {},
    );

    final continueWithoutLoginButton = TextButton(
      onPressed: _continueWithoutLoginButton,
      child: const Text('アカウントを作成せずに続ける'),
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: SpeakingCatImage.height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            description,
            const SizedBox(height: 32),
            Theme(
              data: socialLoginButtonTheme,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    loginWithTwitterButton,
                    const SizedBox(height: 16),
                    loginWithFacebookButton,
                    const SizedBox(height: 16),
                    loginWithAppleButton,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            continueWithoutLoginButton,
          ],
        ),
      ),
    );

    final scaffold = Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: title,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 0,
            right: 16,
            child: SpeakingCatImage(),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );

    return state.isProcessing
        ? Stack(
            children: [
              scaffold,
              ColoredBox(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          )
        : scaffold;
  }

  Future<void> _loginWithTwitter() async {
    final result = await ref.read(widget.viewModel.notifier).loginWithTwitter();

    await result.when(
      success: (_) async {
        await Navigator.pushReplacement<HomeScreen, void>(
          context,
          HomeScreen.route(),
        );
      },
      failure: (error) => error.mapOrNull(
        alreadyInUse: (_) async {
          const snackBar = SnackBar(
            content: Text('このTwitterアカウントはすでに利用されています。他のアカウントでお試しください'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        unrecoverable: (_) async {
          const snackBar = SnackBar(
            content: Text('エラーが発生しました。しばらくしてから再度お試しください'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }

  Future<void> _continueWithoutLoginButton() async {
    await ref.read(widget.viewModel.notifier).continueWithoutLoginButton();

    if (!mounted) {
      return;
    }

    await Navigator.pushReplacement<HomeScreen, void>(
      context,
      HomeScreen.route(),
    );
  }
}
