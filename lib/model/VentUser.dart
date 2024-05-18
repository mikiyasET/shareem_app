import 'package:shareem_app/helpers/format.helper.dart';

class VentUser {
  final String fName;
  final String? lName;
  final String fullName;
  final String? image;
  final String username;
  final bool identity;
  final String hiddenName;
  final String shortHiddenName;

  VentUser({
    required this.fName,
    this.lName,
    this.image,
    this.fullName = '',
    required this.username,
    required this.identity,
    required this.hiddenName,
    this.shortHiddenName = '',
  });

  factory VentUser.fromJson(Map<String, dynamic> json) {
    return VentUser(
      fName: json['identity'] ? json['fName'] : '',
      lName: json['identity'] ? json['lName'] : null,
      image: json['identity'] ? json['image'] : null,
      fullName: json['identity']
          ? makeFullName(json['fName'], json['lName'])
          : json['hiddenName'],
      username: json['identity'] ? json['username'] : '',
      identity: json['identity'],
      hiddenName: json['hiddenName'],
      shortHiddenName: json['hiddenName'].length > 10
          ? json['hiddenName'].substring(0, 10) + "..."
          : json['hiddenName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'fName': fName,
        'lName': lName,
        'image': image,
        'fullName': fullName,
        'username': username,
        'identity': identity,
        'hiddenName': hiddenName,
        'shortHiddenName': shortHiddenName,
      };
}
