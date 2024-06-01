import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/widgets/EMAlertDialog.dart';

import '../../../../controller/theme.controller.dart';

class AdvancedSettings extends StatelessWidget {
  AdvancedSettings({super.key});

  final themeController = Get.find<ThemeController>();
  final authController = Get.find<AuthController>();

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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text('Account profile',
                    style: TextStyle(fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () => Get.toNamed('/account'),
              ),
              Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
              ListTile(
                leading: Icon(CupertinoIcons.lock),
                title:
                    Text('Privacy & Security', style: TextStyle(fontSize: 18)),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () => Get.toNamed('/security'),
              ),
              Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
              Obx(
                () => ListTile(
                  onTap: () => themeController.toggleDarkMode(),
                  leading: const Icon(CupertinoIcons.moon_stars),
                  title:
                      const Text('Dark Mode', style: TextStyle(fontSize: 18)),
                  trailing: Switch(
                    activeColor: Theme.of(context).colorScheme.onSurface,
                    activeTrackColor:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                    thumbColor: MaterialStateProperty.all(Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.8)),
                    value: themeController.isDarkMode.value,
                    onChanged: (value) => themeController.changeTheme(value),
                  ),
                ),
              ),
              Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
              ListTile(
                onTap: () async {
                  EMAlertDialog(
                    title: 'Sign out',
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () async {
                          await authController.logoutUser();
                          Get.offAllNamed('/login');
                        },
                        child: const Text('Sign out'),
                      ),
                    ],
                    context: context,
                  );
                },
                leading: Icon(
                  CupertinoIcons.power,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Sign out', style: TextStyle(fontSize: 18)),
              ),
              Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
            ],
          ),
        ),
      ),
    );
  }
}
