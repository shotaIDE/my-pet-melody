import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/ui/select_sounds_state.dart';
import 'package:meow_music/ui/select_sounds_view_model.dart';

final selectSoundsViewModelProvider = StateNotifierProvider.autoDispose
    .family<SelectSoundsViewModel, SelectSoundsState, Template>(
  (ref, template) => SelectSoundsViewModel(
    selectedTemplate: template,
    submissionUseCase: ref.watch(submissionUseCaseProvider),
  ),
);

class SelectSoundsScreen extends ConsumerStatefulWidget {
  SelectSoundsScreen({required Template template, Key? key})
      : viewModel = selectSoundsViewModelProvider(template),
        super(key: key);

  static const name = 'SelectSoundsScreen';

  final AutoDisposeStateNotifierProvider<SelectSoundsViewModel,
      SelectSoundsState> viewModel;

  static MaterialPageRoute route({
    required Template template,
  }) =>
      MaterialPageRoute<SelectSoundsScreen>(
        builder: (_) => SelectSoundsScreen(template: template),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<SelectSoundsScreen> createState() => _SelectTemplateState();
}

class _SelectTemplateState extends ConsumerState<SelectSoundsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);
    final template = state.template;

    final title = Text(
      '鳴き声を3つ\n設定しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final templateTile = ListTile(
      leading: const Icon(Icons.play_arrow_rounded),
      title: Text(template.name),
      onTap: () {},
    );
    final description = Text(
      'お手元でトリミングした鳴き声をアップロードしてください',
      style: Theme.of(context).textTheme.bodyText1,
    );
    final trimmingButton =
        TextButton(onPressed: () {}, child: const Text('トリミングの方法を見る'));

    final soundsList = ReorderableListView(
      shrinkWrap: true,
      children: List.generate(
        3,
        (index) => ListTile(
          key: Key('reorderable_list_$index'),
          leading: const Icon(Icons.drag_handle),
          title: const Text('鳴き声を選択する'),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
          onTap: () {},
        ),
      ),
      onReorder: (src, dst) {},
    );

    final body = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          templateTile,
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: description,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: trimmingButton,
          ),
          soundsList,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('STEP 2/2'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: title,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
