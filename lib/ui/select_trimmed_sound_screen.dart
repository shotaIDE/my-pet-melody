import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';
import 'package:meow_music/ui/select_trimmed_sound_view_model.dart';

final selectTrimmedSoundViewModelProvider = StateNotifierProvider.autoDispose
    .family<SelectTrimmedSoundViewModel, SelectTrimmedSoundState,
        SelectTrimmedSoundArgs>(
  (ref, args) => SelectTrimmedSoundViewModel(
    args: args,
  ),
);

class SelectTrimmedSoundScreen extends ConsumerStatefulWidget {
  SelectTrimmedSoundScreen({
    required SelectTrimmedSoundArgs args,
    Key? key,
  })  : viewModel = selectTrimmedSoundViewModelProvider(args),
        super(key: key);

  static const name = 'SelectTrimmedSoundScreen';

  final AutoDisposeStateNotifierProvider<SelectTrimmedSoundViewModel,
      SelectTrimmedSoundState> viewModel;

  static MaterialPageRoute route({
    required SelectTrimmedSoundArgs args,
  }) =>
      MaterialPageRoute<SelectTrimmedSoundScreen>(
        builder: (_) => SelectTrimmedSoundScreen(args: args),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<SelectTrimmedSoundScreen> createState() =>
      _SelectTrimmedSoundState();
}

class _SelectTrimmedSoundState extends ConsumerState<SelectTrimmedSoundScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Placeholder(),
    );
  }
}
