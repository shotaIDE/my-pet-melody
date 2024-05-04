import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/ui/component/speaking_cat_image.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  static const name = 'UpdateAppScreen';

  static MaterialPageRoute<UpdateAppScreen> route() =>
      MaterialPageRoute<UpdateAppScreen>(
        builder: (_) => const UpdateAppScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(),
          Positioned(
            bottom: 0,
            right: 16,
            child: SpeakingCatImage(),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return PopScope(
          // Prevent the Android OS back button from dismissing dialog
          canPop: false,
          child: AlertDialog(
            content: Text(
              AppLocalizations.of(context)!.updateAppDescription,
            ),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.update),
                onPressed: () async {
                  await InAppReview.instance.openStoreListing(
                    appStoreId: appStoreId,
                  );
                },
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}
