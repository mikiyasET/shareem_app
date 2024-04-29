import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shareem_app/controller/auth.controller.dart';

import '../../widgets/EMButton.dart';
import '../../widgets/EMInput.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 150, left: 30, right: 30, bottom: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Image.asset(
                    'images/ShareEm.png',
                  ),
                ),
                const SizedBox(height: 70),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Having an issue ?',
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
                      onPressed: () => Get.toNamed('/resetPassword'),
                      child: Text(
                        'Reset password now',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => EMButton(
                      label: 'Sign In',
                      onPressed: authController.signIn,
                      isLoading: authController.isLoading.value),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account ?',
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
                      onPressed: () => {
                        authController.clearValues(),
                        Get.toNamed('/signUp'),
                      },
                      child: Text(
                        'Create Now',
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
