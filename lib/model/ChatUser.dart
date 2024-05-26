import 'package:shareem_app/helpers/format.helper.dart';

class ChatUser {
  final String id;
  final String fName;
  final String? lName;
  final String fullName;
  final String? image;
  final String username;
  final bool? isOnline;

  ChatUser({
    required this.id,
    required this.fName,
    this.lName,
    this.image,
    this.fullName = '',
    required this.username,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      fName: json['fName'],
      lName: json['lName'],
      image: json['image'],
      fullName: makeFullName(json['fName'], json['lName']),
      username: json['username'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fName': fName,
        'lName': lName,
        'image': image,
        'fullName': fullName,
        'username': username,
        'isOnline': isOnline,
      };
}
