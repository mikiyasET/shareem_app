import 'package:shareem_app/model/Vent.dart';

class Saved {
  final String id;
  final String userId;
  final String ventId;
  final Vent? vent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Saved({
    required this.id,
    required this.userId,
    required this.ventId,
    this.vent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Saved.fromJson(Map<String, dynamic> json) {
    print(json['vent']);
    return Saved(
      id: json['id'],
      userId: json['userId'],
      ventId: json['ventId'],
      vent: json['vent'] == null ? null : Vent.fromJson(json['vent']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'ventId': ventId,
        'vent': vent?.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
