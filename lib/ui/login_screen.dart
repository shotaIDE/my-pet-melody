import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/component/social_login_button.dart';
import 'package:my_pet_melody/ui/component/speaking_cat_image.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/home_screen.dart';
import 'package:my_pet_melody/ui/login_state.dart';
import 'package:my_pet_melody/ui/login_view_model.dart';

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

    final isCreateMode = state.isCreateMode;

    final title = isCreateMode ? 'アカウントを\n作成しよう' : '作成済みアカウントに\nログインしよう';
    final titleText = Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final description = isCreateMode
        ? '大切な作品をバックアップするために、アカウントを作成してね！'
        : '大切な作品をバックアップするために、ログインしてね！';
    final descriptionText = Text(
      description,
      textAlign: TextAlign.center,
    );

    final continueWithGoogleButton = ContinueWithGoogleButton(
      onPressed: _continueWithGoogle,
    );
    final continueWithTwitterButton = ContinueWithTwitterButton(
      onPressed: _continueWithTwitter,
    );
    final continueWithFacebookButton = ContinueWithFacebookButton(
      onPressed: _continueWithFacebook,
    );
    final continueWithAppleButton = ContinueWithAppleButton(
      onPressed: _continueWithApple,
    );
    final buttonsPanel = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: DisplayDefinition.actionButtonMaxWidth,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          continueWithGoogleButton,
          const SizedBox(height: 16),
          continueWithTwitterButton,
          const SizedBox(height: 16),
          continueWithFacebookButton,
          const SizedBox(height: 16),
          continueWithAppleButton,
        ],
      ),
    );

    final toggleModeLabel = isCreateMode ? 'アカウントをお持ちの方はログインへ' : 'アカウントを作成する';
    final toggleModelButton = TextButton(
      onPressed: () => ref.read(widget.viewModel.notifier).toggleMode(),
      child: Text(toggleModeLabel),
    );

    final continueWithoutLoginLabel =
        isCreateMode ? 'アカウントを作成せずに続ける' : 'ログインせずに続ける';
    final continueWithoutLoginButton = TextButton(
      onPressed: _continueWithoutLoginButton,
      child: Text(continueWithoutLoginLabel),
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
            descriptionText,
            const SizedBox(height: 32),
            buttonsPanel,
            const SizedBox(height: 32),
            toggleModelButton,
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
                  child: titleText,
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

  Future<void> _continueWithGoogle() async {
    final result =
        await ref.read(widget.viewModel.notifier).continueWithGoogle();

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
            content: Text('このGoogleアカウントはすでに利用されています。他のアカウントでお試しください'),
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

  Future<void> _continueWithTwitter() async {
    final result =
        await ref.read(widget.viewModel.notifier).continueWithTwitter();

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

  Future<void> _continueWithFacebook() async {
    final result =
        await ref.read(widget.viewModel.notifier).continueWithFacebook();

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
            content: Text('このFacebookアカウントはすでに利用されています。他のアカウントでお試しください'),
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

  Future<void> _continueWithApple() async {
    final result =
        await ref.read(widget.viewModel.notifier).continueWithApple();

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
            content: Text('このAppleアカウントはすでに利用されています。他のアカウントでお試しください'),
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
