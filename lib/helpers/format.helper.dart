import 'package:shareem_app/utils/enums.dart';

bool checkStrLen(str, len) => str.length >= len;

Gender strToGender(String gender) {
  switch (gender) {
    case 'male':
    case 'm':
      return Gender.male;
    case 'female':
    case 'f':
      return Gender.female;
    default:
      return Gender.none;
  }
}

Feeling strToFeeling(String feeling) {
  switch (feeling) {
    case 'happy':
      return Feeling.happy;
    case 'sad':
      return Feeling.sad;
    case 'angry':
      return Feeling.angry;
    default:
      return Feeling.none;
  }
}

Status strToStatus(String status) {
  switch (status) {
    case 'suspended':
      return Status.suspended;
    case 'deactivated':
      return Status.deactivated;
    case 'active':
      return Status.active;
    case 'incomplete':
      return Status.incomplete;
    default:
      return Status.inactive;
  }
}

String ucWords(String str) {
  return str[0].toUpperCase() + str.substring(1);
}

String makeFullName(String? fName, String? lName, {bool isShort = false}) {
  final String name;
  if (isShort) {
    name = "${fName ?? ''} ${lName ?? ''}".trim();
  } else {
    name =
        "${fName != null && fName.length > 0 ? ucWords(fName) : ''} ${lName != null && lName.length > 0 ? ucWords(lName) : ''}"
            .trim();
  }
  if (name.isEmpty) {
    return "Anonymous";
  } else if (name.length > 15) {
    return name.substring(0, 12) + "...";
  }
  return name;
}

String showPartialEmail(String? email) {
  if (email == null) {
    return '';
  }
  final List<String> emailParts = email.split('@');
  final String firstPart = emailParts[0];
  final String secondPart = emailParts[1];
  final int len = firstPart.length;
  final String partialEmail = firstPart.substring(0, 2) +
      '...' +
      firstPart.substring(len - 2, len) +
      '@' +
      secondPart;
  return partialEmail;
}
