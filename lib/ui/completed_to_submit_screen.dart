import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/completed_to_submit_state.dart';
import 'package:meow_music/ui/completed_to_submit_view_model.dart';

final completedToSubmitViewModelProvider = StateNotifierProvider.autoDispose<
    CompletedToSubmitViewModel, CompletedToSubmitState>(
  (ref) => CompletedToSubmitViewModel(
    submissionUseCase: ref.watch(submissionUseCaseProvider),
  ),
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
      '提出されました',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          '完成までしばらくお待ちください。\n'
          '完成したらすぐに通知を受けとるために、通知を許可してください。',
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: Icon(
            Icons.notifications,
            size: 128,
          ),
        ),
      ],
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
                  onPressed: () {},
                  child: const Text('プッシュ通知を許可する'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('プッシュ通知を許可しない'),
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
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: title,
            ),
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 64, left: 32, right: 32),
                    child: body,
                  ),
                ),
              ),
            ),
            footer,
          ],
        ),
      ),
    );
  }
}
