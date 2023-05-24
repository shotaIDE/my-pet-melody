import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/component/speaking_cat_image.dart';
import 'package:meow_music/ui/definition/display_definition.dart';
import 'package:meow_music/ui/select_template_state.dart';
import 'package:meow_music/ui/select_template_view_model.dart';

final selectTemplateViewModelProvider = StateNotifierProvider.autoDispose<
    SelectTemplateViewModel, SelectTemplateState>(
  (ref) => SelectTemplateViewModel(
    listener: ref.listen,
  ),
);

class SelectTemplateScreen extends ConsumerStatefulWidget {
  SelectTemplateScreen({Key? key}) : super(key: key);

  static const name = 'SelectTemplateScreen';

  final viewModel = selectTemplateViewModelProvider;

  static MaterialPageRoute route() => MaterialPageRoute<SelectTemplateScreen>(
        builder: (_) => SelectTemplateScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<SelectTemplateScreen> createState() => _SelectTemplateState();
}

class _SelectTemplateState extends ConsumerState<SelectTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);
    final templates = state.templates;

    final title = Text(
      '作品のBGMを選ぼう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final description = Text(
      '選んだBGMに鳴き声が入るよ！',
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );

    final list = templates != null
        ? ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              left: DisplayDefinition.screenPaddingSmall,
              right: DisplayDefinition.screenPaddingSmall,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final playableTemplate = templates[index];
              final template = playableTemplate.template;
              final status = playableTemplate.status;

              final onTap = status.map(
                stop: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .play(template: playableTemplate),
                playing: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .stop(template: playableTemplate),
              );

              final icon = status.when(
                stop: () => const Icon(Icons.play_arrow),
                playing: (position) => const Icon(Icons.stop),
              );
              final button = Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: IconButton(
                  icon: icon,
                  onPressed: onTap,
                ),
              );

              final title = Text(
                template.name,
                style: Theme.of(context).textTheme.bodyMedium,
              );

              const thumbnailHeight = 74.0;

              return InkWell(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      DisplayDefinition.cornerRadiusSizeSmall,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: thumbnailHeight * DisplayDefinition.aspectRatio,
                        height: thumbnailHeight,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: title,
                      ),
                      const SizedBox(width: 16),
                      button,
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              );
            },
            itemCount: templates.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: SpeakingCatImage.height),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: description,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: list,
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        await ref.read(widget.viewModel.notifier).beforeHideScreen();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('STEP 1/3'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
              child: title,
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: body,
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 16,
                    child: SpeakingCatImage(
                      flipHorizontally: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
