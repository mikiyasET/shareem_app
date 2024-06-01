import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';

class Security extends StatelessWidget {
  Security({super.key});

  final themeController = Get.find<ThemeController>();
  final homeController = Get.find<HomeController>();
  final tempController = Get.find<TempController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
              title:
                  const Text('Change Password', style: TextStyle(fontSize: 18)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => Get.toNamed('/password'),
            ),
            Divider(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
            Obx(
              () => ListTile(
                leading: const Icon(Icons.disabled_visible_outlined),
                title: const Text('Anonymous', style: TextStyle(fontSize: 18)),
                trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.onSurface,
                  activeTrackColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onSurface.withOpacity(.8)),
                  value: !(homeController.user.value?.identity ?? false),
                  onChanged: tempController.isUpdateButtonLoading.value
                      ? null
                      : (value) {
                          tempController.userIdentity.value = !value;
                          UserApi userApi = UserApi();
                          userApi.updateProfile('identity');
                        },
                ),
              ),
            ),
            Divider(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
            // ListTile(
            //   leading: Icon(CupertinoIcons.delete, color: Colors.red),
            //   title: Text(
            //     'Delete your account',
            //     style: TextStyle(fontSize: 18, color: Colors.red),
            //   ),
            //   onTap: () => EMAlertDialog(
            //     context: context,
            //     title: 'Delete your account?',
            //     content: const Text(
            //         "Choose an action to perform on your account, remember that this action is irreversible."),
            //     actions: [
            //       TextButton(
            //         onPressed: () {},
            //         child: Text("Delete"),
            //         style: ButtonStyle(
            //           foregroundColor: MaterialStateProperty.all(Colors.red),
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {},
            //         child: Text("Deactivate"),
            //         style: ButtonStyle(
            //           foregroundColor: MaterialStateProperty.all(
            //               Theme.of(context)
            //                   .colorScheme
            //                   .onSurface
            //                   .withOpacity(.8)),
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () => Get.back(),
            //         child: Text("Cancel"),
            //         style: ButtonStyle(
            //           foregroundColor: MaterialStateProperty.all(
            //               Theme.of(context)
            //                   .colorScheme
            //                   .onSurface
            //                   .withOpacity(.8)),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //     color:
            //         Theme.of(context).colorScheme.onSurface.withOpacity(.04)),
          ],
        ),
      ),
    );
  }
}
