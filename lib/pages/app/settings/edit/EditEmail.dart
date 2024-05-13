import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class EditEmail extends StatelessWidget {
  EditEmail({super.key});

  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        EMInput(
          controller: tempController.email.value,
          label: 'Email',
          isError: tempController.isfNameError.value,
          errorText: tempController.fNameErrorText.value,
          bigSize: true,
        ),
        const SizedBox(height: 30),
        EMButton(
          label: 'Update',
          isLoading: tempController.isUpdateButtonLoading.value,
          onPressed: () {
            UserApi userApi = UserApi();
            userApi.updateProfile('email');
          },
        )
      ],
    );
  }
}
