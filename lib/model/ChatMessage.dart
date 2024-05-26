import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/model/ChatUser.dart';
import 'package:shareem_app/utils/enums.dart';

class ChatMessage {
  final String id;
  final String chatRoomId;
  final String userId;
  final ChatUser user;
  final String message;
  final ChatType type;
  final ChatStatus? status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.user,
    required this.message,
    required this.type,
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatRoomId: json['chatRoomId'],
      userId: json['userId'],
      user: ChatUser.fromJson(json['user']),
      message: json['message'],
      type: strToChatType(json['type']),
      status: strToChatStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'userId': userId,
      'user': user.toJson(),
      'message': message,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
