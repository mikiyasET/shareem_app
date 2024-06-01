import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/utils/constants.dart';

class EMComment extends StatelessWidget {
  final String content;
  final String? authorID;
  final String author;
  final String? authorAvatar;
  final String date;
  final int upvotes;
  final int comments;
  final bool isDetailed;
  final bool identity;
  final bool showProfile;
  final Function()? onTap;

  EMComment({
    super.key,
    required this.content,
    required this.author,
    this.authorID,
    this.authorAvatar,
    required this.date,
    required this.upvotes,
    required this.comments,
    this.isDetailed = false,
    required this.identity,
    this.showProfile = true,
    this.onTap,
  });

  final homeController = Get.find<HomeController>();
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final shortName =
        author.split(' ').map((e) => e.trim().length > 0 ? e[0] : '').join();
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 10, bottom: 20, top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                  width: .5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if (showProfile && authorID != null) {
                            if (identity) {
                              if (authorID == homeController.user.value?.id) {
                                Get.toNamed('/account');
                              } else {
                                chatController.io.socket
                                    .emit('getProfile', authorID);
                                homeController.isProfileLoading.value = true;
                                Get.toNamed('/profile');
                              }
                            } else {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(msg: 'User is anonymous');
                            }
                          }
                        },
                        child: CircleAvatar(
                          radius: 13,
                          backgroundImage: authorAvatar == null
                              ? null
                              : NetworkImage("$profileUrl/${authorAvatar!}"),
                          child: authorAvatar == null
                              ? Text(
                                  shortName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          if (showProfile && authorID != null) {
                            if (identity) {
                              if (authorID == homeController.user.value?.id) {
                                Get.toNamed('/account');
                              } else {
                                chatController.io.socket
                                    .emit('getProfile', authorID);
                                homeController.isProfileLoading.value = true;
                                Get.toNamed('/profile');
                              }
                            } else {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(msg: 'User is anonymous');
                            }
                          }
                        },
                        child: Text(
                          author,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(' • ',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.5),
                              fontSize: 20)),
                      Text(
                        date,
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
                const SizedBox(height: 10),
                isDetailed
                    ? Text(
                        content,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.7),
                        ),
                      )
                    : Text(
                        content.length > 200
                            ? content.replaceAll("\n", " ").substring(0, 200)
                            : content.replaceAll("\n", " "),
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.7),
                        ),
                      ),
                const SizedBox(height: 5),
                content.length > 200 && !isDetailed
                    ? Text(
                        '...',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.7),
                          fontSize: 15,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
