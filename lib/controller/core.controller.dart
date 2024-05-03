import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/service/api/auth.api.dart';
import '../model/User.dart';
import 'package:shareem_app/utils/enums.dart';

class CoreController extends GetxController {
  final Rx<TextEditingController> username = TextEditingController().obs;
  final Rx<TextEditingController> fName = TextEditingController().obs;
  final Rx<TextEditingController> lName = TextEditingController().obs;
  final Rx<Gender> gender = Gender.none.obs;
  final Rx<User?> user =  Rx<User?>(null);

  final RxBool isUsernameError = false.obs;
  final RxBool isfNameError = false.obs;
  final RxBool islNameError = false.obs;
  final RxBool isGenderError = false.obs;

  final RxString usernameErrorText = 'Username is required'.obs;
  final RxString fNameErrorText = 'First name is required'.obs;
  final RxString lNameErrorText = 'Last name is required'.obs;
  final RxString genderErrorText = 'Gender is required'.obs;



  void clearValues() {
    username.value.clear();
    fName.value.clear();
    lName.value.clear();
    gender.value = Gender.none;
  }

  void setValues(User user) {
    username.value.text = user.username;
    fName.value.text = user.fName;
    lName.value.text = user.lName ?? '';
    gender.value = user.gender;
  }

  void completeProfile() async {
    if (checkStrLen(username.value.text, 4)) {
      if (checkStrLen(fName.value.text, 3)) {
        if (checkStrLen(lName.value.text, 3)) {
          AuthApi auth = AuthApi();
          await auth.completeProfile();
        }
      }
    }
  }
}
