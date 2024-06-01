import 'package:shareem_app/model/ChatMessage.dart';
import 'package:shareem_app/model/ChatUser.dart';

class ChatRoom {
  final String id;
  final String user1Id;
  final ChatUser me;
  final String user2Id;
  late ChatUser user;
  late ChatMessage? lastMessage;
  late int unseen;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatRoom({
    required this.id,
    required this.user1Id,
    required this.me,
    required this.user2Id,
    required this.user,
    this.lastMessage,
    this.unseen = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      user1Id: json['user1Id'],
      me: ChatUser.fromJson(json['user1']),
      user2Id: json['user2Id'],
      user: ChatUser.fromJson(json['user2']),
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
      unseen: json['unseen'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'me': me.toJson(),
      'user2Id': user2Id,
      'user': user.toJson(),
      'lastMessage': lastMessage?.toJson(),
      'unseen': unseen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
