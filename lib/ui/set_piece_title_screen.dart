import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/ui/completed_to_submit_screen.dart';
import 'package:my_pet_melody/ui/component/footer.dart';
import 'package:my_pet_melody/ui/component/primary_button.dart';
import 'package:my_pet_melody/ui/component/speaking_cat_image.dart';
import 'package:my_pet_melody/ui/component/transparent_app_bar.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/request_push_notification_permission_screen.dart';
import 'package:my_pet_melody/ui/select_template_screen.dart';
import 'package:my_pet_melody/ui/set_piece_title_state.dart';
import 'package:my_pet_melody/ui/set_piece_title_view_model.dart';

final setPieceTitleViewModelProvider = StateNotifierProvider.autoDispose
    .family<SetPieceTitleViewModel, SetPieceTitleState, SetPieceTitleArgs>(
  (ref, args) => SetPieceTitleViewModel(
    ref: ref,
    args: args,
  ),
);

class SetPieceTitleScreen extends ConsumerStatefulWidget {
  SetPieceTitleScreen({required SetPieceTitleArgs args, Key? key})
      : viewModelProvider = setPieceTitleViewModelProvider(args),
        super(key: key);

  static const name = 'SetPieceTitleScreen';

  final AutoDisposeStateNotifierProvider<SetPieceTitleViewModel,
      SetPieceTitleState> viewModelProvider;

  static MaterialPageRoute route({
    required SetPieceTitleArgs args,
  }) =>
      MaterialPageRoute<SetPieceTitleScreen>(
        builder: (_) => SetPieceTitleScreen(args: args),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<SetPieceTitleScreen> createState() => _SetPieceTitleState();
}

class _SetPieceTitleState extends ConsumerState<SetPieceTitleScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModelProvider);

    final title = Text(
      '作品にタイトルを\nつけよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );

    final isRequestStepExists = state.isRequestStepExists;
    final Widget footerContent;
    if (isRequestStepExists == null) {
      footerContent = const CircularProgressIndicator();
    } else {
      final PrimaryButton footerButton;
      if (isRequestStepExists) {
        footerButton = PrimaryButton(
          text: '作品をつくる準備に進む',
          onPressed: _showRequestScreen,
        );
      } else {
        footerButton = PrimaryButton(
          text: '作品をつくる',
          onPressed: _submit,
        );
      }

      footerContent = ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: DisplayDefinition.actionButtonMaxWidth,
        ),
        child: footerButton,
      );
    }

    final thumbnail = Image.file(
      File(state.thumbnailLocalPath),
      fit: BoxFit.cover,
      width: 80 * 1.5,
      height: 80,
    );

    final displayNameInput = TextField(
      controller: state.displayNameController,
      focusNode: state.displayNameFocusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      autofocus: true,
      enabled: !state.isProcessing,
    );

    final body = SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16,
        bottom: max(203, MediaQuery.of(context).viewInsets.bottom),
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          thumbnail,
          const SizedBox(height: 32),
          displayNameInput,
        ],
      ),
    );

    final footer = Footer(child: footerContent);

    final scaffold = Scaffold(
      appBar: transparentAppBar(
        context: context,
        titleText: 'STEP 5/5',
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: title,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: body,
            ),
          ),
          Stack(
            children: [
              footer,
              Stack(
                clipBehavior: Clip.none,
                children: [
                  footer,
                  const Positioned(
                    top: -SpeakingCatImage.height + 18,
                    left: 16,
                    child: SpeakingCatImage(
                      flipHorizontally: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );

    final gestureDetectorWrappedScaffold = GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: scaffold,
    );

    return state.isProcessing
        ? Stack(
            children: [
              gestureDetectorWrappedScaffold,
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
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          )
        : gestureDetectorWrappedScaffold;
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
