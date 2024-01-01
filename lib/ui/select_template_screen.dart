import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pet_melody/data/model/template.dart';
import 'package:my_pet_melody/ui/component/choice_position_bar.dart';
import 'package:my_pet_melody/ui/component/circled_play_button.dart';
import 'package:my_pet_melody/ui/component/fetched_thumbnail.dart';
import 'package:my_pet_melody/ui/component/transparent_app_bar.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/select_sounds_screen.dart';
import 'package:my_pet_melody/ui/select_template_state.dart';
import 'package:my_pet_melody/ui/select_template_view_model.dart';

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

  static MaterialPageRoute<SelectTemplateScreen> route() => MaterialPageRoute(
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

    final current = DateTime.now();

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

              final publishedAt = template.publishedAt;
              final thumbnail = SizedBox(
                width: DisplayDefinition.thumbnailWidthLarge,
                height: DisplayDefinition.thumbnailHeightLarge,
                child: FetchedThumbnail(
                  url: template.thumbnailUrl,
                ),
              );
              final showNewChip = current.difference(publishedAt).inDays < 7;

              final title = Text(
                template.name,
                style: Theme.of(context).textTheme.bodyMedium,
              );

              final dateFormatter = DateFormat.yMd('ja');
              final publishedAtText = dateFormatter.format(publishedAt);
              final subtitle = Text(
                publishedAtText,
                style: Theme.of(context).textTheme.bodySmall,
              );

              final button = CircledPlayButton(
                status: status,
                onPressedWhenStop: () => ref
                    .read(widget.viewModel.notifier)
                    .play(template: playableTemplate),
                onPressedWhenPlaying: () => ref
                    .read(widget.viewModel.notifier)
                    .stop(template: playableTemplate),
              );

              final positionBar = ChoicePositionBar(status: status);

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
                            Stack(
                              children: [
                                thumbnail,
                                if (showNewChip)
                                  const Positioned(
                                    bottom: 0,
                                    right: 8,
                                    child: _NewChip(),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title,
                                  const SizedBox(height: 4),
                                  subtitle,
                                ],
                              ),
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
                          child: positionBar,
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
        bottom: MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: description,
          ),
          const SizedBox(height: 32),
          list,
        ],
      ),
    );

    return PopScope(
      onPopInvoked: (_) async {
        await ref.read(widget.viewModel.notifier).beforeHideScreen();
      },
      child: Scaffold(
        appBar: transparentAppBar(
          context: context,
          titleText: 'STEP 1/5',
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

class _NewChip extends StatelessWidget {
  const _NewChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text('New'),
      labelStyle: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          DisplayDefinition.cornerRadiusSizeLarge,
        ),
      ),
    );
  }
}
