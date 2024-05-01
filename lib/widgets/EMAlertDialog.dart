import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

Future<void> EMAlertDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required List<Widget> actions,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      } else {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      }
    },
  );
}
