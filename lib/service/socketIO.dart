import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/route.controller.dart';
import 'package:shareem_app/model/ChatMessage.dart';
import 'package:shareem_app/model/ChatRoom.dart';
import 'package:shareem_app/model/ChatUser.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class EMWebSocket {
  final box = GetStorage();
  late IO.Socket socket = IO.io(
      backendUrl,
      IO.OptionBuilder().setTransports(['websocket']).setAuth({
        'access_token': box.read(accessToken_),
        'refresh_token': box.read(refreshToken_),
      }).build());

  void onInit() {
    final homeController = Get.find<HomeController>();
    socket.connect();
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
          var cRooms = chatController.chatRooms;
          var chatRoomIndex = cRooms.indexWhere((e) => e.id == chatRoom.id);
          if (chatRoomIndex != -1) {
            chatController.chatRooms[chatRoomIndex] = chatRoom;
            var x = chatController.chatRooms.value;
            chatController.chatRooms.value = [];
            chatController.chatRooms.assignAll(x);
          } else {
            chatController.chatRooms.value = [
              chatRoom,
              ...chatController.chatRooms
            ];
            var x = chatController.chatRooms.value;
            chatController.chatRooms.value = [];
            chatController.chatRooms.assignAll(x);
          }
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
        if (response.data.length > 0) {
          final data = response.data;
          final rooms = data.map<ChatRoom>((e) => ChatRoom.fromJson(e));
          List<ChatRoom> updatedRooms = [];
          for (var room in rooms) {
            final chatRooms = chatController.chatRooms;
            final index = chatRooms.indexWhere((e) => e.id == room.id);
            if (index == -1) {
              updatedRooms = [room, ...updatedRooms];
            }
          }
          chatController.chatRooms.value = [
            ...chatController.chatRooms,
            ...updatedRooms
          ];
          chatController.chatRoomPage.value += 1;
          chatController.chatRoomRefreshController.value.loadComplete();
        } else {
          chatController.chatRoomRefreshController.value.loadNoData();
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
            (e) {
              if (e.id == response.data['key']) {
                e = ChatMessage.fromJson(response.data['chat']);
              }
              return e;
            },
          ).toList();
          chatController.chatQueue.value = chatController.chatQueue
              .where((e) => e['key'] != response.data['key'])
              .toList();

          final cc = ChatMessage.fromJson(response.data['chat']);
          final chatRooms = chatController.chatRooms;
          final chatIndex = chatRooms.indexWhere((e) => e.id == cc.chatRoomId);
          if (chatIndex != -1) {
            chatController.chatRooms[chatIndex].lastMessage = cc;
            var x = chatController.chatRooms.value;
            chatController.chatRooms.value = [];
            chatController.chatRooms.value.addAll(x);
          }
        }
      } else {
        print(response.message);
      }
    });
    socket.on('profile', (data) {
      final homeController = Get.find<HomeController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        homeController.profile.value = ChatUser.fromJson(response.data);
        socket.emit('getUserVents', {'id': homeController.profile.value!.id});
        homeController.isProfileLoading.value = false;
        homeController.isProfileVentLoading.value = true;
      } else {
        homeController.isProfileLoading.value = false;
      }
    });
    socket.on('chatRoom', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        ChatRoom cRoom = ChatRoom.fromJson(response.data);
        final chatRooms = chatController.chatRooms;
        final index = chatRooms.indexWhere((e) => e.id == cRoom.id);
        if (response.message == 'IO_NEW_CHAT_ROOM') {
          chatController.isLoading.value = false;
          chatController.chatRoom.value = cRoom;
          chatController.isNewChatRoom.value = true;
          if (index == -1) {
            chatController.chatRooms.add(cRoom);
          }
        } else {
          chatController.chatRoom.value = cRoom;
          chatController.isNewChatRoom.value = false;
          socket.emit('getChatMessages', {'id': cRoom.id});
          if (index == -1) {
            chatController.chatRooms.add(cRoom);
          }
        }
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: "ChatRoom: ${response.message}");
      }
    });
    socket.on('chatMessages', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        chatController.isLoading.value = false;
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
        chatController.isLoading.value = false;
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: "ChatMessages: ${response.message}");
      }
    });
    socket.on(homeController.user.value!.id, (data) {
      final chatController = Get.find<ChatController>();
      final routeController = Get.find<RouteController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        var chat = ChatMessage.fromJson(response.data['chat']);
        final messages = chatController.chatMessages;
        final rooms = chatController.chatRooms;
        final msgIndex = messages.indexWhere((e) => e.id == chat.id);
        final roomIndex = rooms.indexWhere((e) => e.id == chat.chatRoomId);
        if (chatController.chatRoom.value?.id == chat.chatRoomId) {
          if (messages.firstWhereOrNull((e) => e.id == chat.id) != null) {
            chatController.chatMessages[msgIndex] = chat;
            chatController.chatRooms[roomIndex].lastMessage = chat;
            var x = chatController.chatRooms.value;
            chatController.chatRooms.value = [];
            chatController.chatRooms.value.addAll(x);
          } else {
            chatController.chatMessages
                .assignAll([chat, ...chatController.chatMessages]);
          }
        }
        if (routeController.currentRoute.value == '/chat' &&
            chatController.chatRoom.value?.id == chat.chatRoomId) {
          socket.emit('readChat', chat.id);
        }
      }
    });
    socket.on('updateChat', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        final data = response.data;
        var chats = data.map<ChatMessage>((c) => ChatMessage.fromJson(c));
        for (var chat in chats) {
          final messages = chatController.chatMessages;
          final index = messages.indexWhere((e) => e.id == chat.id);
          final rooms = chatController.chatRooms;
          final roomIndex = rooms.indexWhere((e) => e.id == chat.chatRoomId);
          if (index != -1) {
            chatController.chatMessages[index] = chat;
            if (chatController.chatRooms[roomIndex].lastMessage?.id ==
                chat.id) {
              chatController.chatRooms[roomIndex].lastMessage = chat;
              var x = chatController.chatRooms.value;
              chatController.chatRooms.value = [];
              chatController.chatRooms.assignAll(x);
            }
          }
        }
      } else {
        print(response.message);
      }
    });
    socket.on('userStatus', (data) {
      final chatController = Get.find<ChatController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        final rooms = chatController.chatRooms;
        final user = ChatUser.fromJson(response.data);
        print("${response.message} ${user.fullName} is ${user.isOnline}");

        for (var room in rooms) {
          if (room.user.id == user.id) {
            final index = rooms.indexWhere((e) => e.id == room.id);
            chatController.chatRooms[index].user = user;
            var x = chatController.chatRooms.value;
            chatController.chatRooms.value = [];
            chatController.chatRooms.assignAll(x);
            if (chatController.chatRoom.value?.id == room.id) {
              chatController.chatRoom.value?.user = user;
            }
          }
        }
      }
    });
    socket.on('userVents', (data) {
      final homeController = Get.find<HomeController>();
      EMResponse response = EMResponse.fromJson(data, needDecode: false);
      if (response.success) {
        if (response.data.length > 0) {
          homeController.otherVented.value = [];
          final vents = response.data.map<Vent>((e) => Vent.fromJson(e));
          List<Vent> updatedVents = [];
          for (var vent in vents) {
            final index =
                homeController.otherVented.indexWhere((v) => v.id == vent.id);
            print(index);
            if (index == -1) {
              updatedVents = [vent, ...updatedVents];
            }
          }
          homeController.otherVented.value = [
            ...homeController.otherVented.value,
            ...updatedVents
          ];
          homeController.isProfileVentLoading.value = false;
          homeController.profileRefreshController.value.loadComplete();
          homeController.profilePageIndex.value += 1;
        } else {
          print(response.data);
          homeController.isProfileVentLoading.value = false;
          homeController.profileRefreshController.value.loadNoData();
        }
      } else {
        print(response.message);
        homeController.isProfileVentLoading.value = false;
        homeController.profileRefreshController.value.loadComplete();
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Failed loading user vents');
      }
    });
    socket.onError((data) {
      print("Socket Error");
      print(data);
    });
  }

  void dispose() {
    print("Socket Disposed");
    socket.dispose();
    IO.cache.clear();
  }
}
