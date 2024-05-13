import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/widgets/EMInput.dart';

import '../../widgets/EMButton.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: authController.dateOfBirthDate.value,
      firstDate: DateTime(DateTime.now().year - 50, 8),
      lastDate: DateTime(DateTime.now().year),
      barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.onSurface,
              onPrimary: Theme.of(context).colorScheme.surface,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
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
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
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
                    themeController.isDarkMode.value
                        ? 'images/ShareEm-White.png'
                        : 'images/ShareEm.png',
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
                        checkColor: Theme.of(context).colorScheme.surface,
                        activeColor: Theme.of(context).colorScheme.onSurface,
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
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.8),
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
                    Text(
                      'Already have an account ?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.8),
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
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
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
