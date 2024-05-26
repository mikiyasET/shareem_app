import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/service/api/auth.api.dart';

import '../utils/constants.dart';

class AuthController extends GetxController {
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> password = TextEditingController().obs;
  final Rx<TextEditingController> confirmPassword = TextEditingController().obs;
  final Rx<DateTime> dateOfBirthDate = DateTime(DateTime.now().year - 18).obs;
  final Rx<TextEditingController> dateOfBirth = TextEditingController().obs;
  final Rx<TextEditingController> code = TextEditingController().obs;
  final RxBool isResetPassword = false.obs;
  final RxString resetAccessToken = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool resendLoading = false.obs;

  final RxBool isAnonymous = true.obs;

  final RxBool isEmailError = false.obs;
  final RxBool isPasswordError = false.obs;
  final RxBool isConfirmPasswordError = false.obs;
  final RxBool isDateOfBirthError = false.obs;
  final RxBool isCodeError = false.obs;

  final RxString emailErrorText = 'Email is required'.obs;
  final RxString passwordErrorText = 'Password is required'.obs;
  final RxString confirmPasswordErrorText = 'Confirm password is required'.obs;
  final RxString dateOfBirthErrorText = 'Your age in below the minimum'.obs;
  final RxString codeErrorText = 'Code is required'.obs;

  void clearValues() {
    print("Clearing values");
    email.value.clear();
    password.value.clear();
    confirmPassword.value.clear();
    dateOfBirth.value.clear();
    dateOfBirthDate.value = DateTime(DateTime.now().year - 18);
    dateOfBirth.value.text =
        dateOfBirthDate.value.toIso8601String().split('T')[0].toString();

    isEmailError.value = false;
    isPasswordError.value = false;
    isConfirmPasswordError.value = false;
    isDateOfBirthError.value = false;
    isAnonymous.value = true;
  }

  Future signUp() async {
    checkEmpty();
    checkLength();
    checkMatch();
    checkEmail();
    checkDateOfBirth();
    if (!isEmailError.value &&
        !isPasswordError.value &&
        !isConfirmPasswordError.value &&
        !isDateOfBirthError.value) {
      AuthApi signUp = AuthApi();
      signUp.signUp(
          email.value.text,
          password.value.text,
          dateOfBirthDate.value.toIso8601String().split('T')[0],
          code.value.text,
          isAnonymous.value);
    } else {
      isLoading.value = false;
    }
  }

  Future confirmEmail() async {
    isLoading.value = true;
    AuthApi confirmEmail = AuthApi();
    confirmEmail.confirmEmail(email.value.text, password.value.text,
        dateOfBirthDate.value.toIso8601String().split('T')[0]);
  }

  Future signIn() async {
    isLoading.value = true;
    checkEmpty();
    checkLength();
    checkEmail();
    if (!isEmailError.value && !isPasswordError.value) {
      AuthApi signIn = AuthApi();
      await signIn.signIn(email.value.text, password.value.text);
    } else {
      isLoading.value = false;
    }
  }

  Future resetPassword() async {
    isLoading.value = true;
    isEmailError.value = email.value.text.isEmpty;
    if (isEmailError.value) {
      emailErrorText.value = 'Email is required';
      isLoading.value = false;
      return;
    }
    isEmailError.value = email.value.text.length < 6;
    if (isEmailError.value) {
      emailErrorText.value = 'Invalid email';
      isLoading.value = false;
      return;
    }
    if (isEmailError.value) {
      isEmailError.value = !GetUtils.isEmail(email.value.text);
      emailErrorText.value = 'Invalid email';
      isLoading.value = false;
      return;
    }
    if (!isEmailError.value) {
      AuthApi signIn = AuthApi();
      await signIn.forgotPassword(email.value.text);
    } else {
      isLoading.value = false;
    }
  }

  Future resetPasswordVerify() async {
    isLoading.value = true;
    if (!isCodeError.value) {
      isCodeError.value = code.value.text.length != 6;
      codeErrorText.value = 'Code length is invalid';
    }
    if (!isCodeError.value) {
      AuthApi signIn = AuthApi();
      await signIn.resetPasswordVerify(email.value.text, code.value.text);
    } else {
      isLoading.value = false;
    }
  }

  Future changePassword() async {
    isLoading.value = true;

    isPasswordError.value = password.value.text.isEmpty;
    if (isPasswordError.value) {
      passwordErrorText.value = 'Password is required';
      isLoading.value = false;
      return;
    }
    isConfirmPasswordError.value = confirmPassword.value.text.isEmpty;
    if (isConfirmPasswordError.value) {
      confirmPasswordErrorText.value = 'Confirm password is required';
      isLoading.value = false;
      return;
    }
    isConfirmPasswordError.value =
        password.value.text != confirmPassword.value.text;
    if (isConfirmPasswordError.value) {
      confirmPasswordErrorText.value = 'Password does not match';
      isLoading.value = false;
      return;
    }
    isPasswordError.value = password.value.text.length < 6;
    if (isPasswordError.value) {
      passwordErrorText.value = 'Password is too short';
      isLoading.value = false;
      return;
    }
    isConfirmPasswordError.value = confirmPassword.value.text.length < 6;
    if (isConfirmPasswordError.value) {
      confirmPasswordErrorText.value = 'Confirm password is too short';
      isLoading.value = false;
      return;
    }

    AuthApi changePassword = AuthApi();
    await changePassword.changePassword(
        password.value.text, confirmPassword.value.text);
  }

  void verifyCode() async {
    isLoading.value = true;
    isCodeError.value = false;
    if (isResetPassword.value) {
      await resetPasswordVerify();
    } else {
      await signUp();
    }
  }

  void changeAnonymous(bool? value) {
    isAnonymous.value = value ?? !isAnonymous.value;
  }

  void checkEmpty() {
    isEmailError.value = email.value.text.isEmpty;
    isPasswordError.value = password.value.text.isEmpty;
    isConfirmPasswordError.value = confirmPassword.value.text.isEmpty;
    const allowedYears = 18;
    isDateOfBirthError.value = dateOfBirthDate.value.isAfter(
        DateTime.fromMicrosecondsSinceEpoch(
            DateTime.now().microsecondsSinceEpoch -
                const Duration(days: 365 * allowedYears).inMicroseconds));
    isLoading.value = true;
  }

  void checkLength() {
    if (!isEmailError.value) {
      isEmailError.value = email.value.text.length < 6;
      emailErrorText.value = 'Invalid email';
    }
    if (!isPasswordError.value) {
      isPasswordError.value = password.value.text.length < 6;
      passwordErrorText.value = 'Password is too short';
    }
    if (!isConfirmPasswordError.value) {
      isConfirmPasswordError.value = confirmPassword.value.text.length < 6;
      confirmPasswordErrorText.value = 'Confirm password is too short';
    }
    isLoading.value = true;
  }

  void checkMatch() {
    if (!isConfirmPasswordError.value && !isPasswordError.value) {
      isConfirmPasswordError.value =
          password.value.text != confirmPassword.value.text;
      confirmPasswordErrorText.value = 'Password does not match';
    } else {
      isConfirmPasswordError.value = false;
    }
    isLoading.value = true;
  }

  void checkEmail() {
    if (!isEmailError.value) {
      isEmailError.value = !GetUtils.isEmail(email.value.text);
      emailErrorText.value = 'Invalid email';
    }
    isLoading.value = true;
  }

  void checkDateOfBirth() {
    const allowedYears = 18;
    isDateOfBirthError.value = dateOfBirthDate.value.isAfter(
        DateTime.fromMicrosecondsSinceEpoch(
            DateTime.now().microsecondsSinceEpoch -
                const Duration(days: 365 * allowedYears).inMicroseconds));
    isLoading.value = true;
  }

  Future logoutUser() async {
    clearValues();
    final box = GetStorage();
    final coreController = Get.find<CoreController>();
    box.remove(accessToken_);
    box.remove(refreshToken_);
    coreController.user.value = null;
  }
}
