import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme.controller.dart';

class AdvancedSettings extends StatelessWidget {
   AdvancedSettings({super.key});
  final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text('Account profile', style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
              ListTile(
                leading: const Icon(CupertinoIcons.lock),
                title: const Text('Privacy & Security', style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
              ListTile(
                leading: const Icon(CupertinoIcons.bell),
                title: const Text('Notifications', style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              ),
              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
              Obx(
                ()=> ListTile(
                  leading: const Icon(CupertinoIcons.moon_stars),
                  title: const Text('Dark Mode', style: TextStyle(fontSize: 18)),
                  trailing: Switch(
                    activeColor: Theme.of(context).colorScheme.onSurface,
                    activeTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                    thumbColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface.withOpacity(.8)),
                    value: themeController.isDarkMode.value,
                    onChanged: (value) => themeController.changeTheme(value)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
