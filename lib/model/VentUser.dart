import 'package:shareem_app/helpers/format.helper.dart';

class VentUser {
  final String fName;
  final String? lName;
  final String fullName;
  final String? image;
  final String username;

  VentUser({
    required this.fName,
    this.lName,
    this.image,
    this.fullName = '',
    required this.username,
  });

  factory VentUser.fromJson(Map<String, dynamic> json) {
    return VentUser(
      fName: json['fName'],
      lName: json['lName'],
      image: json['image'],
      fullName: makeFullName(json['fName'], json['lName']),
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() => {
    'fName': fName,
    'lName': lName,
    'image': image,
    'fullName': fullName,
    'username': username,
  };
}