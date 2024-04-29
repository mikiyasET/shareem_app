import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationTypeData {
  final Color bgColor;
  final Color color;
  final IconData icon;
  final String text;

  NotificationTypeData(
      {required this.bgColor,
      required this.color,
      required this.icon,
      required this.text});
}

NotificationTypeData notificationColorIcon(NotificationType type) {
  switch (type) {
    case NotificationType.like:
      return NotificationTypeData(
          bgColor: Colors.red.shade100,
          color: Colors.red.shade400,
          icon: CupertinoIcons.heart_fill,
          text: 'liked your post');
    case NotificationType.comment:
      return NotificationTypeData(
          bgColor: Colors.green.shade100,
          color: Colors.green.shade400,
          icon: CupertinoIcons.chat_bubble_2_fill,
          text: 'commented on your post');
    case NotificationType.follow:
      return NotificationTypeData(
          bgColor: Colors.blue.shade100,
          color: Colors.blue.shade400,
          icon: CupertinoIcons.person_solid,
          text: 'followed you');
    case NotificationType.view:
      return NotificationTypeData(
          bgColor: Colors.purple.shade100,
          color: Colors.purple.shade400,
          icon: CupertinoIcons.eye_solid,
          text: 'viewed your profile');
  }
}

enum NotificationType { like, comment, follow, view }
