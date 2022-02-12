import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/home_state.dart';
import 'package:meow_music/ui/home_view_model.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(
    pieceUseCase: ref.watch(pieceUseCaseProvider),
  ),
);

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const name = 'HomeScreen';

  final viewModel = homeViewModelProvider;

  static MaterialPageRoute route() => MaterialPageRoute<HomeScreen>(
        builder: (_) => HomeScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);
    final pieces = state.pieces;

    final body = pieces != null
        ? ListView.separated(
            itemBuilder: (_, index) {
              final piece = pieces[index];
              final status = piece.status;

              return ListTile(
                title: Text(piece.name),
                subtitle: status.when(
                  generating: (submitted) => Text('$submitted'),
                  generated: (generated) => Text('$generated'),
                ),
              );
            },
            itemCount: pieces.length,
            separatorBuilder: (_, __) => const Divider(),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meow Music'),
      ),
      body: body,
    );
  }
}
