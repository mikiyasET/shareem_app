import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class EditUsername extends StatelessWidget {
  EditUsername({super.key});

  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        EMInput(
          controller: tempController.username.value,
          label: 'Username',
          isError: tempController.isUsernameError.value,
          errorText: tempController.usernameErrorText.value,
          bigSize: true,
        ),
        SizedBox(height: 20),
        EMButton(
          label: 'Update',
          isLoading: tempController.isUpdateButtonLoading.value,
          onPressed: () {
            UserApi userApi = UserApi();
            userApi.updateProfile('username');
          },
        )
      ],
    );
  }
}
