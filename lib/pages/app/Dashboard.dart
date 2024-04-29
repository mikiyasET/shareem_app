import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/widgets/main/EMBottomNav.dart';

import '../../controller/home.controller.dart';
import '../../widgets/main/EMPageStack.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final homeController = Get.put(HomeController());
  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(homeController.title.value)),
        centerTitle: true,
        titleTextStyle:  TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          IconButton(
            onPressed: () => themeController.toggleDarkMode(),
            icon: const Icon(
              Icons.dark_mode_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async => await authController.logoutUser(),
              icon: const Icon(Icons.power_settings_new),
            ),
          )
        ],
      ),
      body: EMPageStack(),
      bottomNavigationBar: EMBottomNav(),
    );
  }
}
