import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class Password extends StatelessWidget {
  Password({super.key});
  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              EMInput(
                label: 'Current Password',
                obscureText: true,
                controller: tempController.currentPassword.value,
                isError: tempController.isCurrentPasswordError.value,
                errorText: tempController.currentPasswordErrorText.value,
              ),
              const SizedBox(height: 20),
              EMInput(
                label: 'New Password',
                obscureText: true,
                controller: tempController.newPassword.value,
                isError: tempController.isNewPasswordError.value,
                errorText: tempController.newPasswordErrorText.value,
              ),
              const SizedBox(height: 20),
              EMInput(
                label: 'Confirm Password',
                obscureText: true,
                controller: tempController.confirmPassword.value,
                isError: tempController.isConfirmPasswordError.value,
                errorText: tempController.confirmPasswordErrorText.value,
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
                onPressed: () {
                  tempController.isUpdateButtonLoading.value = true;
                  UserApi userApi = UserApi();
                  userApi.updatePassword();
                },
                isLoading: tempController.isUpdateButtonLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
