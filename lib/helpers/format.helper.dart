import '../model/user.dart';

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

String makeFullName(String? fName, String? lName) {
  late String name = "${ucWords(fName ?? '')} ${ucWords(lName ?? '')}".trim();
  if (name.isEmpty) {
    return "Anonymous";
  } else if (name.length > 15) {
    return name.substring(0, 12) + "...";
  }
  return name;
}
