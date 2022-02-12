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
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Icon(
            Icons.notifications,
            size: 128,
          ),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: title,
            ),
            Expanded(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: body,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
