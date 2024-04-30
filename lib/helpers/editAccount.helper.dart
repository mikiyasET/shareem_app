enum EditAccountType { name, username, gender, email }

EditAccountData getEditAccountType(String? type) {
  switch (type) {
    case 'name':
      return EditAccountData(
        index: 0,
        title: 'Change name',
      );
    case 'username':
      return EditAccountData(
        index: 1,
        title: 'Change username',
      );
    case 'gender':
      return EditAccountData(
        index: 2,
        title: 'Change gender',
      );
    case 'email':
      return EditAccountData(
        index: 3,
        title: 'Change email',
      );
    default:
      return EditAccountData(
        index: 0,
        title: 'Change name',
      );
  }
}

class EditAccountData {
  final int index;
  final String title;

  EditAccountData({
    required this.title,
    required this.index,
  });
}
