import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shareem_app/widgets/EMNButton.dart';

import '../../helpers/notification.helper.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 10),
              child: Text('Today'),
            ),
            EMNButton(names: 'm_miko', date: '6 hour ago', type: NotificationType.like),
            EMNButton(names: 'm_miko', date: '6 hour ago', type: NotificationType.comment),
            EMNButton(names: 'm_miko', date: '6 hour ago', type: NotificationType.follow),
            EMNButton(names: 'm_miko', date: '6 hour ago', type: NotificationType.view)
          ],
        ),
      ),
    );
  }
}
