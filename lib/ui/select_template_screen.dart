import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/select_sounds_screen.dart';
import 'package:meow_music/ui/select_template_state.dart';
import 'package:meow_music/ui/select_template_view_model.dart';

final selectTemplateViewModelProvider = StateNotifierProvider.autoDispose<
    SelectTemplateViewModel, SelectTemplateState>(
  (ref) => SelectTemplateViewModel(
    submissionUseCase: ref.watch(submissionUseCaseProvider),
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
      'テンプレート曲を\n設定しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final body = templates != null
        ? ListView.separated(
            shrinkWrap: true,
            itemBuilder: (_, index) {
              final template = templates[index];

              return ListTile(
                leading: Container(
                  color: Colors.blue,
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                  ),
                ),
                title: Text(template.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push<void>(
                  context,
                  SelectSoundsScreen.route(template: template),
                ),
              );
            },
            itemCount: templates.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('STEP 1/2'),
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
