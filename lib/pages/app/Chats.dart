import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/widgets/EMChat.dart';
import 'package:shareem_app/widgets/EMLoading.dart';

class Chats extends StatelessWidget {
  Chats({super.key});

  final chatController = Get.find<ChatController>();

  void _onRefresh() async {
    chatController.io.socket.emit('getChatRooms', {
      'page': chatController.chatRoomPage.value,
    });

    // final int result = await ventApi.fetchVents();
    // switch (result) {
    //   case 2:
    //     ventController.refreshController.value.refreshCompleted();
    //     break;
    //   case 4:
    //     ventController.refreshController.value.refreshFailed();
    //     break;
    // }
  }

  void _onLoading() async {
    // final int result = await ventApi.fetchVents(nextPage: true);
    // switch (result) {
    //   case 0:
    //     ventController.refreshController.value.loadNoData();
    //     break;
    //   case 1:
    //     ventController.refreshController.value.loadComplete();
    //     break;
    //   case 3:
    //     ventController.refreshController.value.loadFailed();
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Obx(
        () => SmartRefresher(
          controller: chatController.chatRoomRefreshController.value,
          enablePullDown: false,
          enablePullUp: true,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text("Scroll up to load more");
              } else if (mode == LoadStatus.loading) {
                body = const EMLoading();
              } else if (mode == LoadStatus.failed) {
                body = const Text("Load Failed! Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("Release to load more");
              } else {
                body = const Text("No more chat.");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          onLoading: () => chatController.nextPage('chatRoom'),
          child: chatController.chatRooms.length > 0
              ? ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: chatController.chatRooms
                      .map(
                        (element) => EMChat(
                          name: element.user.fullName,
                          message: element.lastMessage,
                          time: DateFormat("hh:mm a").format(element.createdAt),
                          image: element.user.image,
                          unseen: element.unseen,
                          status: element.lastMessage?.status,
                          user: element.user,
                        ),
                      )
                      .toList())
              : const Center(
                  child: Text('No chats yet. Start a conversation!'),
                ),
        ),
      ),
    );
  }
}
