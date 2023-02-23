import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      '作品のBGMを\n選択しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final description = Text(
      '好きなBGMを選んでね。選んだBGMに鳴き声が入るよ！',
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );

    final list = templates != null
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final playableTemplate = templates[index];
              final template = playableTemplate.template;
              final status = playableTemplate.status;

              final onTapLeading = status.map(
                stop: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .play(template: playableTemplate),
                playing: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .stop(template: playableTemplate),
              );

              final leading = InkWell(
                onTap: onTapLeading,
                child: Container(
                  color: Colors.white,
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: status.when(
                      stop: () => [
                        const Center(child: Icon(Icons.play_arrow)),
                      ],
                      playing: (position) => [
                        Center(
                          child: CircularProgressIndicator(
                            value: position,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        const Center(child: Icon(Icons.stop)),
                      ],
                    ),
                  ),
                ),
              );

              return ListTile(
                leading: leading,
                title: Text(template.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await ref.read(widget.viewModel.notifier).beforeHideScreen();

                  if (!mounted) {
                    return;
                  }

                  await Navigator.push<void>(
                    context,
                    SelectSoundsScreen.route(template: template),
                  );
                },
              );
            },
            itemCount: templates.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );

    final catImage = Image.asset('assets/images/speaking_cat_eye_opened.png');

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 203),
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
                  Positioned(
                    bottom: 0,
                    left: 16,
                    child: SafeArea(child: catImage),
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
