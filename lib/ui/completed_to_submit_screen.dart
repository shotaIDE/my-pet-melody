import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/completed_to_submit_state.dart';
import 'package:meow_music/ui/completed_to_submit_view_model.dart';

final completedToSubmitViewModelProvider = StateNotifierProvider.autoDispose<
    CompletedToSubmitViewModel, CompletedToSubmitState>(
  (_) => CompletedToSubmitViewModel(),
);

class CompletedToSubmitScreen extends ConsumerStatefulWidget {
  CompletedToSubmitScreen({Key? key}) : super(key: key);

  static const name = 'CompletedToSubmitScreen';

  final viewModel = completedToSubmitViewModelProvider;

  static MaterialPageRoute<CompletedToSubmitScreen> route() =>
      MaterialPageRoute<CompletedToSubmitScreen>(
        builder: (_) => CompletedToSubmitScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<CompletedToSubmitScreen> createState() =>
      _SelectTemplateState();
}

class _SelectTemplateState extends ConsumerState<CompletedToSubmitScreen> {
  @override
  Widget build(BuildContext context) {
    final title = Text(
      '作品の製作が\n開始されました',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4,
    );

    const description = Text(
      '完成までしばらく待ってね！\n'
      '完成したときは通知で知らせるから、通知の設定を許可しておいてね！',
      textAlign: TextAlign.center,
    );

    final notificationButton = TextButton(
      onPressed: () {},
      child: const Text('通知の設定を確認する'),
    );

    final catImage = Image.asset('assets/images/full_cat.png');

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            description,
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: notificationButton,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: catImage,
            ),
          ],
        ),
      ),
    );

    final footer = Container(
      alignment: Alignment.center,
      color: Theme.of(context).secondaryHeaderColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ホームに戻る'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: title,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: body,
              ),
            ),
            footer,
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
