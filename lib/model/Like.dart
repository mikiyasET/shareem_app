import 'package:shareem_app/model/Vent.dart';

class Liked {
  final String id;
  final String userId;
  final String ventId;
  final bool type;
  final Vent? vent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Liked({
    required this.id,
    required this.userId,
    required this.ventId,
    required this.type,
    this.vent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Liked.fromJson(Map<String, dynamic> json) {
    return Liked(
      id: json['id'],
      userId: json['userId'],
      ventId: json['ventId'],
      type: json['type'] == 'upvote' ? true : false,
      vent: json['vent'] == null ? null : Vent.fromJson(json['vent']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'ventId': ventId,
        'type': type ? 'upvote' : 'downvote',
        'vent': vent?.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
