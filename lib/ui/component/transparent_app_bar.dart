import 'package:flutter/material.dart';

AppBar transparentAppBar({
  required BuildContext context,
  required String titleText,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(titleText),
    actions: actions,
    shadowColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    centerTitle: false,
  );
}
