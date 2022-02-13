import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:meow_music/ui/home_view_model.dart';
import 'package:meow_music/ui/select_template_screen.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(
    pieceUseCase: ref.watch(pieceUseCaseProvider),
  ),
);

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({
    required this.shouldStartCreationAutomatically,
    Key? key,
  }) : super(key: key);

  static const name = 'HomeScreen';

  final bool shouldStartCreationAutomatically;
  final viewModel = homeViewModelProvider;

  static MaterialPageRoute<HomeScreen> route({
    required bool shouldStartCreationAutomatically,
  }) =>
      MaterialPageRoute<HomeScreen>(
        builder: (_) => HomeScreen(
          shouldStartCreationAutomatically: shouldStartCreationAutomatically,
        ),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    if (!widget.shouldStartCreationAutomatically) {
      return;
    }

    Navigator.push<void>(context, SelectTemplateScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);
    final pieces = state.pieces;

    final Widget body;
    if (pieces == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (pieces.isNotEmpty) {
        body = ListView.separated(
          itemBuilder: (_, index) {
            final playablePiece = pieces[index];
            final playStatus = playablePiece.playStatus;
            final leading = playStatus.when(
              stop: () => const Icon(Icons.play_arrow),
              playing: (_) => const Icon(Icons.stop),
            );

            final piece = playablePiece.piece;
            final status = piece.status;
            final dateFormatter = DateFormat.yMd('ja');
            final timeFormatter = DateFormat.Hm('ja');
            final subtitleLabel = status.when(
              generating: (submitted) => '${dateFormatter.format(submitted)} '
                  '${timeFormatter.format(submitted)}   '
                  '製作中',
              generated: (generated) => '${dateFormatter.format(generated)} '
                  '${timeFormatter.format(generated)}',
            );

            final void Function()? onTap;
            onTap = status.when(
              generating: (_) => null,
              generated: (_) => playStatus.when(
                stop: () => () => ref
                    .read(widget.viewModel.notifier)
                    .play(piece: playablePiece),
                playing: (_) => () => ref
                    .read(widget.viewModel.notifier)
                    .stop(piece: playablePiece),
              ),
            );

            final tile = ListTile(
              leading: leading,
              title: Text(piece.name),
              subtitle: Text(subtitleLabel),
              trailing: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () =>
                    ref.read(widget.viewModel.notifier).share(piece: piece),
              ),
              tileColor: status.when(
                generating: (_) => Colors.grey[300],
                generated: (_) => null,
              ),
              onTap: onTap,
            );

            return playStatus.when(
              stop: () => tile,
              playing: (position) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tile,
                  LinearProgressIndicator(value: position),
                ],
              ),
            );
          },
          itemCount: pieces.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
        );
      } else {
        body = Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'まだ作品を製作していません。\n右下の “+” ボタンから作品を製作しましょう。',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).disabledColor),
            ),
          ),
        );
      }
    }

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('Meow Music'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.push<void>(context, SelectTemplateScreen.route()),
      ),
    );

    return state.isProcessing
        ? Stack(
            children: [
              scaffold,
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          )
        : scaffold;
  }
}
