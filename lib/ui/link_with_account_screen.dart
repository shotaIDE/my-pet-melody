import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/link_with_account_state.dart';
import 'package:meow_music/ui/link_with_account_view_model.dart';

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

    final loginWithTwitterButton = OutlinedButton(
      onPressed: _loginWithTwitter,
      child: const Text('Twitterでログイン'),
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            description,
            const SizedBox(height: 32),
            loginWithTwitterButton,
          ],
        ),
      ),
    );

    final catImage = Image.asset('assets/images/speaking_cat_eye_closed.png');

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('アカウント作成'),
      ),
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: body,
                  ),
                  Positioned(bottom: 0, right: 16, child: catImage),
                ],
              ),
            ),
          ],
        ),
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
}
