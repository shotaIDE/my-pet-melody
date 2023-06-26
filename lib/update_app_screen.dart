import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({Key? key}) : super(key: key);

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

    // _showDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        content: const Text(
          '新しいバージョンがリリースされています。より良い作品を作るために、アップデートしてご利用ください',
        ),
        actions: [
          TextButton(
            child: const Text('アップデートする'),
            onPressed: () async {
              await InAppReview.instance.openStoreListing(
                appStoreId: AppDefinitions.appStoreId,
              );
            },
          ),
        ],
      ),
    );
  }
}
