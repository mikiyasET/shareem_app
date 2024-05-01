import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/pages/app/AddPost.dart';
import 'package:shareem_app/pages/app/Chats.dart';
import 'package:shareem_app/pages/app/Home.dart';
import 'package:shareem_app/pages/app/Notifications.dart';
import 'package:shareem_app/pages/app/Settings.dart';

import '../../controller/home.controller.dart';

class EMPageStack extends StatelessWidget {
  EMPageStack({super.key});

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      height: MediaQuery.of(context).size.height,
      child: Obx(
        () => IndexedStack(
          index: homeController.pageIndex.value,
          children: [
            Home(),
            Chats(),
            AddPost(),
            Notifications(),
            Settings(),
          ],
        ),
      ),
    );
  }
}
