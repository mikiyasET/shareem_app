import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> EMAlertDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required List<Widget> actions,
  isDismissible = false,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismissible, // user must tap button!
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      } else {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          title: Text(title),
          content: content,
          actions: actions,
        );
      }
    },
  );
}
