import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/model/VentUser.dart';

class Comment {
  final String id;
  final String userId;
  final String ventId;
  final int likes;
  final int comments;
  final String content;
  final VentUser? user;
  final Vent? vent;
  final bool identity;
  final String? replyTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.ventId,
    required this.likes,
    required this.comments,
    required this.content,
    required this.user,
    this.vent,
    required this.identity,
    this.replyTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      ventId: json['ventId'],
      likes: json['likes'],
      comments: json['comments'],
      content: json['content'],
      user: json['user'] == null ? null : VentUser.fromJson(json['user']),
      vent: json['vent'] == null ? null : Vent.fromJson(json['vent']),
      identity: json['identity'],
      replyTo: json['replyTo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'ventId': ventId,
        'likes': likes,
        'comments': comments,
        'content': content,
        'user': user?.toJson(),
        'vent': vent?.toJson(),
        'identity': identity,
        'replyTo': replyTo,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
