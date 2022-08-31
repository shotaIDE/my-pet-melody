import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/completed_to_submit_screen.dart';
import 'package:meow_music/ui/request_push_notification_permission_screen.dart';
import 'package:meow_music/ui/select_template_screen.dart';
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
      : viewModelProvider = setPieceDetailsViewModelProvider(args),
        super(key: key);

  static const name = 'SetPieceDetailsScreen';

  final AutoDisposeStateNotifierProvider<SetPieceDetailsViewModel,
      SetPieceDetailsState> viewModelProvider;

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
    final state = ref.watch(widget.viewModelProvider);

    final title = Text(
      '作品の詳細を\n設定しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4,
    );

    final isRequestStepExists = state.isRequestStepExists;
    final Widget footerContent;
    if (isRequestStepExists == null) {
      footerContent = const CircularProgressIndicator();
    } else {
      final ButtonStyleButton footerButton;
      if (isRequestStepExists) {
        footerButton = ElevatedButton(
          onPressed: _showRequestScreen,
          child: const Text('作品をつくる準備に進む'),
        );
      } else {
        footerButton = ElevatedButton(
          onPressed: _submit,
          child: const Text('作品をつくる'),
        );
      }

      footerContent = SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: footerButton,
      );
    }

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

  Future<void> _showRequestScreen() async {
    final args =
        ref.read(widget.viewModelProvider.notifier).getRequestPermissionArgs();

    await Navigator.push<void>(
      context,
      RequestPushNotificationPermissionScreen.route(args: args),
    );
  }

  Future<void> _submit() async {
    await ref.read(widget.viewModelProvider.notifier).submit();

    if (!mounted) {
      return;
    }

    Navigator.popUntil(
      context,
      (route) => route.settings.name == SelectTemplateScreen.name,
    );
    await Navigator.pushReplacement<CompletedToSubmitScreen, void>(
      context,
      CompletedToSubmitScreen.route(),
    );
  }
}
