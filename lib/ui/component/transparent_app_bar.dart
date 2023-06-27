import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar transparentAppBar({
  required BuildContext context,
  required String titleText,
}) {
  return AppBar(
    title: Text(titleText),
    shadowColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    centerTitle: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}
