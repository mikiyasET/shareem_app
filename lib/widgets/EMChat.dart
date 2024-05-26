import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/ChatMessage.dart';
import 'package:shareem_app/model/ChatUser.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/utils/enums.dart';

class EMChat extends StatelessWidget {
  final String? image;
  final String name;
  final ChatMessage? message;
  final String time;
  final int unseen;
  final ChatStatus? status;
  final ChatUser user;

  EMChat({
    super.key,
    this.image,
    required this.name,
    required this.message,
    required this.time,
    this.unseen = 0,
    this.status,
    required this.user,
  });

  final chatController = Get.find<ChatController>();
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final shortName = name.split(' ').map((e) => e[0]).join();
    return InkWell(
      onTap: () {
        chatController.selectedUser.value = user;
        chatController.initializeChatRoom();
        Get.toNamed('/chat');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
              width: .3,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: CircleAvatar(
            radius: 28,
            backgroundImage:
                image == null ? null : NetworkImage("$profileUrl/${image!}"),
            child: image == null
                ? Text(
                    shortName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  )
                : null,
          ),
          title:
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(message?.message ?? ''),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                unseen > 0 ? MainAxisAlignment.center : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 95,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    message?.userId != homeController.user.value?.id
                        ? const SizedBox()
                        : Icon(
                            status == ChatStatus.seen
                                ? Icons.done_all
                                : status == ChatStatus.delivered
                                    ? Icons.done
                                    : Icons.access_time,
                            size: 20,
                            color: status == ChatStatus.seen
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5),
                          ),
                    const SizedBox(width: 10),
                    Text(time),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              unseen > 0
                  ? CircleAvatar(
                      radius: 13,
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      child: Text(
                        unseen.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
