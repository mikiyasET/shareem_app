import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/widgets/EMChatText.dart';

class Chat extends StatelessWidget {
  Chat({super.key});

  final homeController = Get.find<HomeController>();
  final themeController = Get.find<ThemeController>();
  final chatController = Get.find<ChatController>();

  void _onLoading() async {}

  @override
  Widget build(BuildContext context) {
    final shortName = chatController.selectedUser.value?.fullName
        .split(' ')
        .map((e) => e[0])
        .join();
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => Get.back(),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: chatController.selectedUser.value?.image !=
                        null
                    ? NetworkImage(
                        "$profileUrl/${chatController.selectedUser.value?.image!}")
                    : null,
                child: chatController.selectedUser.value?.image == null
                    ? Text(
                        shortName ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    makeFullName(chatController.selectedUser.value?.fName,
                        chatController.selectedUser.value?.lName,
                        len: 25),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(CupertinoIcons.info),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Obx(
        () => chatController.chatMessages.value.length == 0
            ? const Center(child: Text('Start a conversation'))
            : SmartRefresher(
                controller: chatController.chatRefreshController.value,
                enablePullDown: false,
                enablePullUp: true,
                header: const ClassicHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = const Text("Scroll up to load more");
                    } else if (mode == LoadStatus.loading) {
                      body = Platform.isIOS
                          ? const CupertinoActivityIndicator()
                          : const CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = const Text("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const Text("Release to load more");
                    } else {
                      body = Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          // glassy look
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.1),
                          ),
                          child: const Text("Chat started",
                              style:
                                  TextStyle(fontSize: 12, letterSpacing: .3)));
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                onRefresh: () =>
                    chatController.chatRefreshController.value.refreshToIdle(),
                onLoading: () => chatController.nextPage('chat'),
                child: ListView(
                  reverse: true,
                  children: chatController.chatMessages.value
                      .map(
                        (element) => EMChatText(
                          message: element.message,
                          date: DateFormat('hh:mm a').format(element.createdAt),
                          type: element.type,
                          status: element.status,
                          isMe: element.userId == homeController.user.value?.id,
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
      bottomNavigationBar: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: chatController.messageController.value,
                maxLines: 2,
                minLines: 2,
                autofocus: false,
                autocorrect: false,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  isDense: true,
                  // filled: true,
                  hintText: 'Type a message',
                  fillColor: themeController.isDarkMode.value
                      ? const Color(0xFF1f1f1f)
                      : const Color(0xFFEAEAEA),
                  errorStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () {
                  chatController.sendMessage();
                },
                icon: Icon(CupertinoIcons.paperplane),
                iconSize: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
