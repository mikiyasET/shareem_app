import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/notification.helper.dart';

class EMNButton extends StatelessWidget {
  final String names;
  final String date;
  final NotificationType type;

  const EMNButton(
      {super.key, required this.names, required this.date, required this.type});

  @override
  Widget build(BuildContext context) {
    final NotificationTypeData data = notificationColorIcon(type);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background.withOpacity(.2),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: data.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            data.icon,
            color: data.color,
            size: 22,
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: names,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: ' ${data.text}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(date),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
