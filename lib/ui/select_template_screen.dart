import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/ui/definition/display_definition.dart';
import 'package:meow_music/ui/select_sounds_screen.dart';
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

              final icon = status.when(
                stop: () => const Icon(Icons.play_arrow),
                playing: (position) => const Icon(Icons.stop),
              );
              final onTapButton = status.map(
                stop: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .play(template: playableTemplate),
                playing: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .stop(template: playableTemplate),
              );
              final button = Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: onTapButton,
                  icon: icon,
                ),
              );

              final title = Text(
                template.name,
                style: Theme.of(context).textTheme.bodyMedium,
              );

              final thumbnail = Container(
                width: DisplayDefinition.thumbnailWidth,
                height: DisplayDefinition.thumbnailHeight,
                color: Colors.blueGrey,
              );

              final progressIndicator = status.maybeWhen(
                playing: (position) => LinearProgressIndicator(value: position),
                orElse: SizedBox.shrink,
              );

              return ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    DisplayDefinition.cornerRadiusSizeSmall,
                  ),
                ),
                child: Material(
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DisplayDefinition.cornerRadiusSizeSmall,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _onSelect(template),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            thumbnail,
                            const SizedBox(width: 16),
                            Expanded(
                              child: title,
                            ),
                            const SizedBox(width: 16),
                            button,
                            const SizedBox(width: 16),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: progressIndicator,
                        ),
                      ],
                    ),
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
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: description,
          ),
          const SizedBox(height: 32),
          list,
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
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: title,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: body,
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<void> _onSelect(Template template) async {
    await ref.read(widget.viewModel.notifier).beforeHideScreen();

    if (!mounted) {
      return;
    }

    await Navigator.push<void>(
      context,
      SelectSoundsScreen.route(template: template),
    );
  }
}
