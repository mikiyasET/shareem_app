import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EMInput(
                  label: 'New Password',
                  controller: authController.password.value,
                  isError: authController.isPasswordError.value,
                  errorText: authController.passwordErrorText.value,
                ),
                const SizedBox(height: 20),
                EMInput(
                  label: 'Confirm Password',
                  controller: authController.confirmPassword.value,
                  isError: authController.isConfirmPasswordError.value,
                  errorText: authController.confirmPasswordErrorText.value,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.ads_click),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Please keep your password secure and do not share it with anyone.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                EMButton(
                  label: 'Change Password',
                  onPressed: () => authController.changePassword(),
                  isLoading: authController.isLoading.value,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'Remembered your password ?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.8),
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
