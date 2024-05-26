import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/utils/constants.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final homeController = Get.find<HomeController>();
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!homeController.isProfileLoading.value &&
          homeController.profile.value == null) {
        Get.back();
      }
      return homeController.isProfileLoading.value
          ? Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      icon: Icon(CupertinoIcons.chat_bubble),
                      onPressed: () {
                        chatController.selectedUser.value =
                            homeController.profile.value;
                        chatController.initializeChatRoom();
                        Get.toNamed('/chat');
                      },
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                '${profileUrl}/${homeController.profile.value?.image}'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            makeFullName(homeController.profile.value?.fName,
                                    homeController.profile.value?.lName,
                                    len: 20) ??
                                '',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                  ],
                ),
              ),
            );
    });
  }
}
