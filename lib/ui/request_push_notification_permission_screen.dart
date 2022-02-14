import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
import 'package:meow_music/ui/completed_to_submit_screen.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:meow_music/ui/request_push_notification_permission_view_model.dart';
import 'package:meow_music/ui/select_template_screen.dart';

final requestPushNotificationPermissionViewModelProvider =
    StateNotifierProvider.autoDispose.family<
        RequestPushNotificationPermissionViewModel,
        RequestPushNotificationPermissionState,
        RequestPushNotificationPermissionArgs>(
  (ref, args) => RequestPushNotificationPermissionViewModel(
    submissionUseCase: ref.watch(submissionUseCaseProvider),
    args: args,
  ),
);

class RequestPushNotificationPermissionScreen extends ConsumerStatefulWidget {
  RequestPushNotificationPermissionScreen({
    required RequestPushNotificationPermissionArgs args,
    Key? key,
  })  : viewModel = requestPushNotificationPermissionViewModelProvider(args),
        super(key: key);

  static const name = 'RequestPushNotificationPermissionScreen';

  final AutoDisposeStateNotifierProvider<
      RequestPushNotificationPermissionViewModel,
      RequestPushNotificationPermissionState> viewModel;

  static MaterialPageRoute route({
    required RequestPushNotificationPermissionArgs args,
  }) =>
      MaterialPageRoute<RequestPushNotificationPermissionScreen>(
        builder: (_) => RequestPushNotificationPermissionScreen(args: args),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<RequestPushNotificationPermissionScreen> createState() =>
      _SelectTemplateState();
}

class _SelectTemplateState
    extends ConsumerState<RequestPushNotificationPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final title = Text(
      'プッシュ通知を\n許可しよう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final description = Text(
      '作品が完成したときに通知が受け取れます。通知を許可してください。',
      style: Theme.of(context).textTheme.bodyText1,
    );
    const icon = Icon(Icons.notifications, size: 128);

    final body = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          description,
          const Padding(
            padding: EdgeInsets.only(top: 32, left: 16, right: 16),
            child: icon,
          ),
        ],
      ),
    );

    final footerContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('プッシュ通知を許可する'),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextButton(
            onPressed: () {},
            child: const Text('プッシュ通知を許可しない'),
          ),
        ),
      ],
    );

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
        title: const Text('依頼前の準備'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: title,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: body,
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

  Future<void> _submit() async {
    await ref.read(widget.viewModel.notifier).submit();

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
