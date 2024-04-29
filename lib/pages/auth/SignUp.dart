import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/widgets/EMInput.dart';

import '../../widgets/EMButton.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final authController = Get.find<AuthController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: authController.dateOfBirthDate.value,
      firstDate: DateTime(DateTime.now().year - 50, 8),
      lastDate: DateTime(DateTime.now().year),
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != authController.dateOfBirthDate.value) {
      authController.dateOfBirthDate.value = picked;
      authController.dateOfBirth.value.text =
          picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Image.asset(
                    height: (authController.isEmailError.value ||
                            authController.isPasswordError.value ||
                            authController.isConfirmPasswordError.value ||
                            authController.isDateOfBirthError.value)
                        ? 70
                        : 140,
                    width: double.infinity,
                    'images/ShareEm.png',
                  ),
                ),
                const SizedBox(height: 30),
                EMInput(
                  label: 'Email',
                  controller: authController.email.value,
                  isError: authController.isEmailError.value,
                  errorText: authController.emailErrorText.value,
                  onTapped: () {
                    authController.isEmailError.value = false;
                  },
                ),
                const SizedBox(height: 20),
                EMInput(
                  label: 'Password',
                  obscureText: true,
                  controller: authController.password.value,
                  isError: authController.isPasswordError.value,
                  errorText: authController.passwordErrorText.value,
                  onTapped: () {
                    authController.isPasswordError.value = false;
                  },
                ),
                const SizedBox(height: 20),
                EMInput(
                  label: 'Confirm Password',
                  obscureText: true,
                  controller: authController.confirmPassword.value,
                  isError: authController.isConfirmPasswordError.value,
                  errorText: authController.confirmPasswordErrorText.value,
                  onTapped: () {
                    authController.isConfirmPasswordError.value = false;
                  },
                ),
                const SizedBox(height: 20),
                EMInput(
                  onTapped: () {
                    authController.isDateOfBirthError.value = false;
                    _selectDate(context);
                  },
                  controller: authController.dateOfBirth.value,
                  label: 'Date of Birth',
                  readOnly: true,
                  isError: authController.isDateOfBirthError.value,
                  errorText: authController.dateOfBirthErrorText.value,
                ),
                const SizedBox(height: 20),
                // check box with anonymous label
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                        value: authController.isAnonymous.value,
                        onChanged: authController.changeAnonymous,
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () => authController
                          .changeAnonymous(!authController.isAnonymous.value),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'I want to be anonymous',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => EMButton(
                      label: 'Sign Up',
                      onPressed: authController.confirmEmail,
                      isLoading: authController.isLoading.value),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account ?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
