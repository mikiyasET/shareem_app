import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/helpers/image.helper.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/utils/enums.dart';

class Account extends StatelessWidget {
  Account({super.key});

  final themeController = Get.find<ThemeController>();
  final homeController = Get.find<HomeController>();
  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                homeController.user.value?.image == null
                    ? Icon(Icons.account_circle, size: 105, color: Colors.grey)
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FadeInImage.assetNetwork(
                          placeholder: 'images/loading/img_load.gif',
                          image:
                              '$profileUrl/${homeController.user.value?.image}',
                          fit: BoxFit.cover,
                          height: 250,
                          width: 250,
                        ).image,
                      ),
                const SizedBox(height: 5),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () async {
                    await editPhoto(context);
                  },
                  child: const Text('Edit Photo'),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () {
                    tempController.fName.value.text =
                        homeController.user.value?.fName ?? '';
                    tempController.lName.value.text =
                        homeController.user.value?.lName ?? '';
                    Get.toNamed('/editAccount', parameters: {'type': 'name'});
                  },
                  title: const Text('Name',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                          makeFullName(homeController.user.value?.fName,
                              homeController.user.value?.lName, isShort: true),
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.5))),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () {
                    tempController.username.value.text =
                        homeController.user.value?.username ?? '';
                    Get.toNamed(
                      '/editAccount',
                      parameters: {'type': 'username'},
                    );
                  },
                  title: const Text('Username',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(homeController.user.value?.username ?? '',
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.5))),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () {
                    tempController.gender.value =
                        homeController.user.value?.gender ?? Gender.male;
                    Get.toNamed('/editAccount', parameters: {'type': 'gender'});
                  },
                  title: const Text('Gender',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                          homeController.user.value?.gender == Gender.male
                              ? Icons.male
                              : homeController.user.value?.gender ==
                                      Gender.female
                                  ? Icons.female
                                  : Icons.block,
                          size: 20,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5)),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                    onTap: () {
                      tempController.email.value.text =
                          homeController.user.value?.email ?? '';
                      Get.toNamed('/editAccount',
                          parameters: {'type': 'email'});
                    },
                    title: const Text('Email',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    trailing: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                              showPartialEmail(
                                  homeController.user.value?.email),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.5))),
                          const SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.5)),
                        ])),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('BirthDate',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        homeController.user.value?.birthDate ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
