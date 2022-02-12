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

    final body = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow_rounded),
            title: Text(template.name),
            onTap: () {},
          ),
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
