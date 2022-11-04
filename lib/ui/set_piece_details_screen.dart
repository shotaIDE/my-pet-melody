import 'dart:io';

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

    final description = Text(
      'あなたのねこが鳴いてる動画を選んでね！自動で鳴き声を探すよ！',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1,
    );

    final thumbnail = Image.file(
      File(state.thumbnailLocalPath),
      fit: BoxFit.cover,
      width: 80 * 1.5,
      height: 80,
    );
    final thumbnailButton = InkWell(
      onTap: () {},
      child: thumbnail,
    );

    final displayNameInput = TextField(
      controller: state.displayNameController,
    );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 203, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          description,
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: thumbnailButton,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: displayNameInput,
          ),
        ],
      ),
    );

    final catImage = Image.asset('assets/images/speaking_cat_eye_opened.png');

    final footer = Container(
      alignment: Alignment.center,
      color: Theme.of(context).secondaryHeaderColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: footerContent,
        ),
      ),
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('STEP 3/3'),
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
          footer,
        ],
      ),
    );

    return state.isProcessing
        ? Stack(
            children: [
              scaffold,
              Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '提出しています',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              )
            ],
          )
        : scaffold;
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
