import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/completed_to_submit_state.dart';
import 'package:meow_music/ui/completed_to_submit_view_model.dart';
import 'package:meow_music/ui/component/footer.dart';
import 'package:meow_music/ui/component/listening_music_cat_image.dart';
import 'package:meow_music/ui/component/primary_button.dart';
import 'package:meow_music/ui/definition/display_definition.dart';

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
      style: Theme.of(context).textTheme.headlineMedium,
    );

    const description = Text(
      '完成までしばらく待ってね！',
      textAlign: TextAlign.center,
    );

    final notificationButton = TextButton(
      onPressed: () {},
      child: const Text('いますぐ作品を完成させる'),
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            description,
            const SizedBox(height: 32),
            notificationButton,
            const SizedBox(height: 32),
            const ListeningMusicCatImage(),
          ],
        ),
      ),
    );

    final footerButton = PrimaryButton(
      text: 'ホームに戻る',
      onPressed: () => Navigator.pop(context),
    );
    final footerContent = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: DisplayDefinition.actionButtonMaxWidth,
      ),
      child: footerButton,
    );
    final footer = Footer(child: footerContent);

    return Scaffold(
      body: Column(
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
              child: body,
            ),
          ),
          footer,
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
