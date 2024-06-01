import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/ChatMessage.dart';
import 'package:shareem_app/model/ChatRoom.dart';
import 'package:shareem_app/model/ChatUser.dart';
import 'package:shareem_app/service/socketIO.dart';
import 'package:shareem_app/utils/enums.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> chatMessages = RxList<ChatMessage>([]);
  final RxList<ChatRoom> chatRooms = RxList<ChatRoom>([]);
  final Rx<ChatRoom?> chatRoom = Rx<ChatRoom?>(null);
  final Rx<TextEditingController> messageController =
      TextEditingController().obs;
  final chatQueue = [].obs;
  final Rx<RefreshController> chatRefreshController =
      RefreshController(initialRefresh: false).obs;
  final chatPage = 0.obs;
  final chatLimit = 20.obs;

  final Rx<RefreshController> chatRoomRefreshController =
      RefreshController(initialRefresh: false).obs;
  final chatRoomPage = 0.obs;
  final chatRoomLimit = 20.obs;

  final RxBool isLoading = false.obs;
  final RxBool isNewChatRoom = false.obs;
  final Rx<ChatUser?> selectedUser = Rx<ChatUser?>(null);

  late EMWebSocket io;

  @override
  void onInit() {
    io = EMWebSocket();
    io.onInit();
    super.onInit();
  }

  @override
  void onClose() {
    io.dispose();
    super.onClose();
  }

  void initializeChatRoom() {
    print(selectedUser.value?.toJson());
    isLoading.value = true;
    io.socket.emit('joinRoom', selectedUser.value?.id);
  }

  void sendMessage() {
    final homeController = Get.find<HomeController>();
    if (messageController.value.text.isNotEmpty) {
      final chat = {
        'key': customAlphabet('1234567890abcdef', 10),
        'id': chatRoom.value?.id,
        'message': messageController.value.text,
      };
      chatQueue.add(chat);
      final chatN = ChatMessage(
        id: chat['key'] ?? '',
        chatRoomId: chat['id'] ?? '',
        userId: homeController.user.value?.id ?? '',
        user: ChatUser(
          id: homeController.user.value?.id ?? '',
          fName: homeController.user.value?.fName ?? '',
          lName: homeController.user.value?.lName ?? '',
          image: homeController.user.value?.image ?? '',
          username: homeController.user.value?.username ?? '',
        ),
        message: chat['message'] ?? '',
        type: ChatType.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      if (chatRooms.indexWhere((element) => element.id == chatRoom.value?.id) !=
          -1) {
        chatRooms[chatRooms
                .indexWhere((element) => element.id == chatRoom.value?.id)]
            .lastMessage = chatN;
        var x = chatRooms.value;
        chatRooms.value = [];
        chatRooms.value.addAll(x);
      }
      chatMessages.assignAll([chatN, ...chatMessages]);
      io.socket.emit('sendMessage', {
        'key': chat['key'],
        'id': chat['id'],
        'message': chat['message'],
      });
      messageController.value.clear();
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Message cannot be empty');
    }
  }

  void clear() {
    chatMessages.clear();
    chatRoom.value = null;
    messageController.value.clear();
    isLoading.value = false;
    isNewChatRoom.value = false;
    selectedUser.value = null;
    chatPage.value = 0;
    chatLimit.value = 20;
  }

  void nextPage(type) {
    if (type == 'chat') {
      chatPage.value++;
      io.socket.emitWithAck('getChatMessages', {
        'id': chatRoom.value?.id,
        'page': chatPage.value,
      }, ack: (data) {
        print("data: $data");
        if (data.length == 0) {
          chatRefreshController.value.loadNoData();
        } else {
          chatRefreshController.value.loadComplete();
        }
      });
    } else {
      io.socket.emit('getChatRooms', {
        'page': chatRoomPage.value,
      });
    }
  }
}
