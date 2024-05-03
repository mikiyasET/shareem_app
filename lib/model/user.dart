import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/utils/enums.dart';

class User {
  final String id;
  final String fName;
  final String? lName;
  final String username;
  final String email;
  final String birthDate;
  final Gender gender; // gender
  final String? image;
  final Feeling feeling; // feeling
  final Status status; // status
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fName,
    this.lName,
    required this.username,
    required this.email,
    required this.birthDate,
    required this.gender,
    this.image,
    required this.feeling,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        fName: json['fName'],
        lName: json['lName'],
        username: json['username'],
        email: json['email'],
        birthDate: json['birthDate'],
        gender: strToGender(json['gender']),
        image: json['image'],
        feeling: strToFeeling(json['feeling']),
        status: strToStatus(json['status']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fName': fName,
      'lName': lName,
      'username': username,
      'email': email,
      'birthDate': birthDate,
      'gender': gender,
      'image': image,
      'feeling': feeling,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}