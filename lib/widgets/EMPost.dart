import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/model/VentUser.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/utils/enums.dart';

class EMPost extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final Feeling feeling;
  final VentUser author;
  final bool identity;
  final String date;
  final int upvotes;
  final int comments;
  final bool isLiked;
  final bool isDisliked;
  final bool isSaved;
  final List<Tag> tags;
  final bool isDetailed;
  final bool bottomBorder;
  final bool tools;
  final bool showProfile;
  final Function()? onTap;

  EMPost({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.feeling,
    required this.author,
    required this.identity,
    required this.date,
    required this.upvotes,
    required this.comments,
    this.isLiked = false,
    this.isDisliked = false,
    this.isSaved = false,
    this.tags = const [],
    this.isDetailed = false,
    this.bottomBorder = true,
    this.tools = true,
    this.onTap,
    this.showProfile = true,
  });

  final homeController = Get.find<HomeController>();
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final shortName = (identity ? author.fullName : author.shortHiddenName)
        .split(' ')
        .map((e) => e.trim().length > 0 ? e[0] : '')
        .join();
    final VentApi ventApi = VentApi();
    final iconSize = 20.0;
    final prColor = Theme.of(context).colorScheme.primary;
    final onsColor = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: onsColor.withOpacity(.2),
              width: bottomBorder ? .5 : 0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (showProfile) {
                  if (identity) {
                    if (author.id == homeController.user.value?.id) {
                      Get.toNamed('/account');
                    } else {
                      chatController.io.socket.emit('getProfile', author.id);
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
                radius: 23,
                backgroundImage: author.image == null || !identity
                    ? null
                    : NetworkImage("${profileUrl}/${author.image}"),
                child: author.image == null || !identity
                    ? Text(
                        shortName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (showProfile) {
                              if (identity) {
                                if (author.id ==
                                    homeController.user.value?.id) {
                                  Get.toNamed('/account');
                                } else {
                                  chatController.io.socket
                                      .emit('getProfile', author.id);
                                  homeController.isProfileLoading.value = true;
                                  Get.toNamed('/profile');
                                }
                              } else {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(
                                    msg: 'User is anonymous');
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                (identity
                                    ? author.fullName
                                    : author.shortHiddenName),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: onsColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        feeling.toString().split('.').last == 'none'
                            ? SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: onsColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  feeling.toString().split('.').last,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                        const Spacer(),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 15,
                            color: onsColor.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: onsColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  isDetailed
                      ? Text(
                          content,
                          style: TextStyle(
                            fontSize: 15,
                            color: onsColor.withOpacity(.7),
                          ),
                        )
                      : Text(
                          content.length > 200
                              ? content.replaceAll("\n", " ").substring(0, 200)
                              : content.replaceAll("\n", " "),
                          style: TextStyle(
                            fontSize: 15,
                            color: onsColor.withOpacity(.7),
                          ),
                        ),
                  const SizedBox(height: 5),
                  content.length > 200 && !isDetailed
                      ? Text(
                          '...',
                          style: TextStyle(
                            color: onsColor.withOpacity(.7),
                            fontSize: 15,
                          ),
                        )
                      : const SizedBox(),
                  tags.length > 0 ? const SizedBox(height: 5) : SizedBox(),
                  tags.length > 0
                      ? Wrap(
                          children: tags
                              .map((tag) => Container(
                                    margin: const EdgeInsets.only(
                                      right: 5,
                                      top: 5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: prColor.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '#${tag.name}',
                                      style: TextStyle(
                                        color: prColor,
                                        fontSize: 12,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : const SizedBox(),
                  tools
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        ventApi.reactVent(id, true);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.up_arrow,
                                            color: isLiked ? prColor : onsColor,
                                            size: iconSize,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            upvotes.toString(),
                                            style: TextStyle(
                                              color: onsColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    InkWell(
                                      onTap: () {
                                        ventApi.reactVent(id, false);
                                      },
                                      child: Icon(
                                        CupertinoIcons.down_arrow,
                                        color: isDisliked ? prColor : onsColor,
                                        size: iconSize,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.messenger_outline_sharp,
                                    color: onsColor,
                                    size: iconSize,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    comments.toString(),
                                    style: TextStyle(
                                      color: onsColor,
                                    ),
                                  ),
                                ]),
                                InkWell(
                                  onTap: () {
                                    ventApi.saveVent(id);
                                  },
                                  child: Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                    color: isSaved ? prColor : onsColor,
                                    size: iconSize,
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.share,
                                  color: onsColor,
                                  size: iconSize,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
