import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/widgets/EMPButton.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Obx(
              () => Row(
                children: [
                  homeController.user.value?.image == null
                      ? Icon(Icons.person, size: 45)
                      : CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                              '${profileUrl}/${homeController.user.value?.image}'),
                        ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Wrap(children: [
                            Text(
                              makeFullName(homeController.user.value?.fName,
                                  homeController.user.value?.lName),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                        ),
                        InkWell(
                          onTap: () => Get.toNamed('/account'),
                          child: const Text(
                            'View profile',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Column(
                    children: [
                      Text(homeController.ventCount.toString(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('Vent',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${homeController.dayCount}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text(homeController.dayCount > 1 ? 'Days' : 'Day',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ))
                          ],
                        ),
                        Opacity(
                          opacity: .2,
                          child: Image.asset(
                            'images/icons/mvp_ribbon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Column(
                    children: [
                      Text(homeController.draftCount.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Text('Drafts',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 15),
          EMPButton(
            label: 'Vents',
            icon: CupertinoIcons.bubble_left_bubble_right_fill,
            iconBgColor: Colors.indigo,
            onTap: () {
              Get.toNamed('/vented');
            },
          ),
          EMPButton(
            label: 'Liked',
            icon: CupertinoIcons.heart_fill,
            iconBgColor: Colors.red,
            onTap: () {
              Get.toNamed('/liked');
            },
          ),
          EMPButton(
            label: 'Saved',
            icon: CupertinoIcons.bookmark_fill,
            iconBgColor: Colors.teal,
            onTap: () {
              Get.toNamed('/saved');
            },
          ),
          // draft
          EMPButton(
            label: 'Drafts',
            icon: CupertinoIcons.collections,
            iconBgColor: Colors.blueGrey,
            onTap: () {
              Get.toNamed('/draft');
            },
          ),
          EMPButton(
            label: 'My Comments',
            icon: CupertinoIcons.chat_bubble_2_fill,
            iconBgColor: Colors.deepOrange,
            onTap: () {
              Get.toNamed('/commented');
            },
          ),
          EMPButton(
            label: 'Developers',
            icon: Icons.developer_mode,
            iconBgColor: Colors.lightGreen,
            onTap: () {
              Get.toNamed('/developers');
            },
          ),
          EMPButton(
            label: 'Advanced Settings',
            icon: Icons.more_horiz_rounded,
            iconBgColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.surface,
            onTap: () {
              Get.toNamed('/advancedSettings');
            },
          )
        ],
      ),
    );
  }
}
