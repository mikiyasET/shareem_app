import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/ChatMessage.dart';
import 'package:shareem_app/model/ChatRoom.dart';
import 'package:shareem_app/model/ChatUser.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class EMWebSocket {
  EMWebSocket() {
    GetStorage box = GetStorage();
    final homeController = Get.find<HomeController>();

    if (accessToken_ == null || refreshToken_ == null) {
      return;
    }
    socket = IO.io(
      backendUrl,
      OptionBuilder().setTransports(['websocket']).setAuth({
        'access_token': box.read(accessToken_),
        'refresh_token': box.read(refreshToken_),
      }).build(),
    );

    socket.onConnect((_) => print('connect'));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('updateChatRoom', (data) {
      print('Chat room update');
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        print('Chat room update 1');
        if (response.message == 'IO_UPDATED_CHAT_ROOM') {
          print('Chat room update 2');
          final chatRoom = ChatRoom.fromJson(response.data);
          chatController.chatRooms[chatController.chatRooms
              .indexWhere((element) => element.id == chatRoom.id)] = chatRoom;

          if (chatController.chatRoom.value?.id == chatRoom.id) {
            print('Chat room update 3');
            chatController.chatRoom.value = ChatRoom.fromJson(response.data);
          }
        }
      } else {
        print('Chat room update error');
        print(response.message);
      }
    });
    socket.on('chatRooms', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        if (response.message == 'IO_CHAT_DATA') {
          chatController.chatRooms.assignAll(
              response.data.map<ChatRoom>((e) => ChatRoom.fromJson(e)));
        }
      } else {
        print(response.message);
      }
    });
    socket.on('chatMessage', (data) async {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        if (response.message == 'IO_CREATED_CHAT_MESSAGE') {
          chatController.chatMessages.value = chatController.chatMessages.map(
            (element) {
              if (element.id == response.data['key']) {
                element = ChatMessage.fromJson(response.data['chat']);
              }
              return element;
            },
          ).toList();
          chatController.chatQueue.value = chatController.chatQueue
              .where((element) => element['key'] != response.data['key'])
              .toList();

          final cc = ChatMessage.fromJson(response.data['chat']);
          chatController
              .chatRooms[chatController.chatRooms
                  .indexWhere((element) => element.id == cc.chatRoomId)]
              .lastMessage = cc;
          var x = chatController.chatRooms.value;
          chatController.chatRooms.value = [];
          chatController.chatRooms.value.addAll(x);
        }
      } else {
        print(response.message);
      }
    });
    socket.on('profile', (data) {
      final homeController = Get.find<HomeController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        if (response.message == 'IO_PROFILE_DATA') {
          homeController.profile.value = ChatUser.fromJson(response.data);
          homeController.isProfileLoading.value = false;
        }
      } else {
        homeController.isProfileLoading.value = false;
      }
    });
    socket.on('chatRoom', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        ChatRoom cRoom = ChatRoom.fromJson(response.data);
        if (response.message == 'IO_NEW_CHAT_ROOM') {
          chatController.chatRoom.value = cRoom;
          chatController.isLoading.value = false;
          chatController.isNewChatRoom.value = true;
        } else {
          chatController.chatRoom.value = cRoom;
          chatController.isLoading.value = false;
          chatController.isNewChatRoom.value = false;
          socket.emit('getChatMessages', {'id': cRoom.id});
        }
      } else {
        Fluttertoast.showToast(msg: "ChatRoom: ${response.message}");
      }
    });
    socket.on('chatMessages', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        if (response.data != null && response.data.length > 0) {
          final List newList = response.data
              .map<ChatMessage>((e) => ChatMessage.fromJson(e))
              .toList();
          chatController.chatMessages.value = [
            ...chatController.chatMessages,
            ...newList
          ];
        } else {
          if (chatController.chatMessages.isEmpty) {
            chatController.isNewChatRoom.value = true;
            chatController.chatMessages.value = [];
          }
        }
      } else {
        Fluttertoast.showToast(msg: "ChatMessages: ${response.message}");
      }
    });
    socket.onAny((event, data) {
      print('Event: $event .... ${homeController.user.value!.id}');
    });
    socket.on(homeController.user.value!.id, (data) {
      final chatController = Get.find<ChatController>();

      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        final chat = ChatMessage.fromJson(response.data['chat']);
        if (chatController.chatRoom.value?.id == chat.chatRoomId) {
          if (chatController.chatMessages
                  .firstWhereOrNull((element) => element.id == chat.id) !=
              null) {
            chatController.chatMessages[chatController.chatMessages
                .indexWhere((element) => element.id == chat.id)] = chat;
          } else {
            chatController.chatMessages
                .assignAll([chat, ...chatController.chatMessages]);
          }
        }
        chatController
            .chatRooms[chatController.chatRooms
                .indexWhere((element) => element.id == chat.chatRoomId)]
            .lastMessage = chat;
        var x = chatController.chatRooms.value;
        chatController.chatRooms.value = [];
        chatController.chatRooms.value.addAll(x);
      }
    });
  }

  late IO.Socket socket;
}
