import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/select_trimmed_sound_state.dart';

class SelectTrimmedSoundViewModel
    extends StateNotifier<SelectTrimmedSoundState> {
  SelectTrimmedSoundViewModel({
    required SelectTrimmedSoundArgs args,
  })  : _args = args,
        super(const SelectTrimmedSoundState());

  final SelectTrimmedSoundArgs _args;
}
