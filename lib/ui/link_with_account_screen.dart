import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/component/social_login_button.dart';
import 'package:my_pet_melody/ui/component/speaking_cat_image.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/link_with_account_state.dart';
import 'package:my_pet_melody/ui/link_with_account_view_model.dart';

final _linkWithAccountViewModelProvider = StateNotifierProvider.autoDispose<
    LinkWithAccountViewModel, LinkWithAccountState>(
  (ref) => LinkWithAccountViewModel(
    ref: ref,
  ),
);

class LinkWithAccountScreen extends ConsumerStatefulWidget {
  LinkWithAccountScreen({
    Key? key,
  }) : super(key: key);

  static const name = 'LinkWithAccountScreen';

  final viewModel = _linkWithAccountViewModelProvider;

  static MaterialPageRoute<LinkWithAccountScreen> route() =>
      MaterialPageRoute<LinkWithAccountScreen>(
        builder: (_) => LinkWithAccountScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<LinkWithAccountScreen> createState() =>
      _LinkWithAccountScreenState();
}

class _LinkWithAccountScreenState extends ConsumerState<LinkWithAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    const description = Text(
      '大切な作品をバックアップするために、アカウントを作成してね！',
      textAlign: TextAlign.center,
    );

    final continueWithTwitterButton = ContinueWithTwitterButton(
      onPressed: _continueWithTwitter,
    );
    final continueWithFacebookButton = ContinueWithFacebookButton(
      onPressed: _continueWithFacebook,
    );
    final loginWithAppleButton = ContinueWithAppleButton(
      onPressed: () {},
    );
    final buttonsPanel = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: DisplayDefinition.actionButtonMaxWidth,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          continueWithTwitterButton,
          const SizedBox(height: 16),
          continueWithFacebookButton,
          const SizedBox(height: 16),
          loginWithAppleButton,
        ],
      ),
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 32,
          bottom: SpeakingCatImage.height,
          left: 32,
          right: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            description,
            const SizedBox(height: 32),
            buttonsPanel,
          ],
        ),
      ),
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('アカウント作成'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: body,
                ),
                const Positioned(
                  bottom: 0,
                  right: 16,
                  child: SpeakingCatImage(),
                ),
              ],
            ),
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

  Future<void> _continueWithTwitter() async {
    final result = await ref.read(widget.viewModel.notifier).loginWithTwitter();

    await result.when(
      success: (_) async {
        Navigator.pop(context);
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
        Navigator.pop(context);
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
}
