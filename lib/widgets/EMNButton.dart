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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
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
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: ' ${data.text}',
                style: const TextStyle(
                  color: Colors.black,
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
