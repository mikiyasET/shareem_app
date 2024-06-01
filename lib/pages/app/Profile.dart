import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/widgets/EMAlertDialog.dart';
import 'package:shareem_app/widgets/EMLoading.dart';
import 'package:shareem_app/widgets/EMPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class Profile extends StatelessWidget {
  Profile({super.key});

  final homeController = Get.find<HomeController>();
  final chatController = Get.find<ChatController>();
  final ventController = Get.find<VentController>();

  void _onLoading() async {
    chatController.io.socket.emit('getUserVents', {
      'id': homeController.profile.value!.id,
      'page': homeController.profilePageIndex.value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shortName = homeController.profile.value?.fullName
          .split(' ')
          .map((e) => e.trim().length > 0 ? e[0] : '')
          .join();
      if (!homeController.isProfileLoading.value &&
          homeController.profile.value == null) {
        Get.back();
      }
      if (homeController.isProfileLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: const Center(
            child: EMLoading(),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.chat_bubble),
                  onPressed: () {
                    if (homeController.user.value?.identity == true) {
                      chatController.selectedUser.value =
                          homeController.profile.value;
                      chatController.initializeChatRoom();
                      Get.toNamed('/chat');
                    } else {
                      EMAlertDialog(
                        context: context,
                        title: "Confirm",
                        content: const Text(
                            "You are currently anonymous. But if you start chatting with a user they will able to see you identity,\n\nAre you sure you want to continue?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              chatController.selectedUser.value =
                                  homeController.profile.value;
                              chatController.initializeChatRoom();
                              Get.toNamed('/chat');
                            },
                            child: const Text("Continue"),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          homeController.profile.value?.image == null
                              ? null
                              : NetworkImage(
                                  '${profileUrl}/${homeController.profile.value?.image}',
                                ),
                      child: homeController.profile.value?.image == null
                          ? Text(
                              shortName ?? '?',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      makeFullName(homeController.profile.value?.fName,
                              homeController.profile.value?.lName,
                              len: 20) ??
                          '',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Expanded(
                child: Obx(() => SmartRefresher(
                    onLoading: _onLoading,
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: homeController.profileRefreshController.value,
                    child: homeController.isProfileVentLoading.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10.0,
                            ),
                            child: SizedBox(
                              width: 100,
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : homeController.otherVented.length > 0
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: homeController.otherVented
                                    .map((vent) => EMPost(
                                          id: vent.id,
                                          title: vent.title,
                                          content: vent.content,
                                          feeling: vent.feeling,
                                          author: vent.author,
                                          date: timeago.format(vent.createdAt),
                                          upvotes: vent.likes,
                                          comments: vent.comments,
                                          tags: vent.tags,
                                          isLiked: vent.isLiked,
                                          isSaved: vent.saved
                                              .where((element) =>
                                                  element.userId ==
                                                  homeController.user.value!.id)
                                              .isNotEmpty,
                                          identity: vent.identity,
                                          showProfile: false,
                                          onTap: () {
                                            ventController.selectedVent.value =
                                                vent;
                                            Get.toNamed('/post');
                                          },
                                        ))
                                    .toList(),
                              )
                            : const Center(
                                // show list of vents
                                child: Text("No vents yet!"),
                              ))),
              )
            ],
          ),
        );
      }
    });
  }
}
