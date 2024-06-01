import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';

import '../../controller/home.controller.dart';

class EMBottomNav extends StatelessWidget {
  EMBottomNav({super.key});

  final homeController = Get.find<HomeController>();
  final chatController = Get.find<ChatController>();
  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final unseenChats = chatController.chatRooms.length > 0
            ? chatController.chatRooms
                .map((element) => element.unseen)
                .reduce((value, element) => value + element)
            : 0;
        return BottomNavigationBar(
          currentIndex: homeController.pageIndex.value,
          onTap: (index) => homeController.changePageIndex(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.onSurface,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              activeIcon: Icon(CupertinoIcons.house_alt),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.green,
              icon: Stack(
                children: [
                  Icon(CupertinoIcons.chat_bubble),
                  if (unseenChats > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${unseenChats}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Chats',
              activeIcon: Stack(
                children: [
                  Icon(CupertinoIcons.chat_bubble_2),
                  if (unseenChats > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${unseenChats}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add),
              label: 'Create',
              activeIcon: Icon(CupertinoIcons.add),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              activeIcon: Icon(CupertinoIcons.settings_solid),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
