import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home.controller.dart';

class EMBottomNav extends StatelessWidget {
  EMBottomNav({super.key});

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: homeController.pageIndex.value,
        onTap: homeController.changePageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(CupertinoIcons.house_alt),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble),
            label: 'Chats',
            activeIcon: Icon(CupertinoIcons.chat_bubble_2),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            activeIcon: Icon(Icons.notifications_on_outlined, size: 25,),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            activeIcon: Icon(CupertinoIcons.settings_solid),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
