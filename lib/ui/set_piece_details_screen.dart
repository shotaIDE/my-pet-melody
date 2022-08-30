import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/set_piece_details_state.dart';
import 'package:meow_music/ui/set_piece_details_view_model.dart';

final setPieceDetailsViewModelProvider = StateNotifierProvider.autoDispose
    .family<SetPieceDetailsViewModel, SetPieceDetailsState,
        SetPieceDetailsArgs>(
  (ref, args) => SetPieceDetailsViewModel(
    reader: ref.read,
    args: args,
  ),
);

class SetPieceDetailsScreen extends ConsumerStatefulWidget {
  SetPieceDetailsScreen({required SetPieceDetailsArgs args, Key? key})
      : viewModel = setPieceDetailsViewModelProvider(args),
        super(key: key);

  static const name = 'SetPieceDetailsScreen';

  final AutoDisposeStateNotifierProvider<SetPieceDetailsViewModel,
      SetPieceDetailsState> viewModel;

  static MaterialPageRoute route({
    required SetPieceDetailsArgs args,
  }) =>
      MaterialPageRoute<SetPieceDetailsScreen>(
        builder: (_) => SetPieceDetailsScreen(args: args),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<SetPieceDetailsScreen> createState() => _SetPieceDetailsState();
}

class _SetPieceDetailsState extends ConsumerState<SetPieceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final title = Text(
      '作品の詳細を\n設定しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('STEP 3/3'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: title,
          ),
        ],
      ),
    );
  }
}
