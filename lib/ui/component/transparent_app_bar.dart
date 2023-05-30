import 'package:flutter/material.dart';

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
  );
}
