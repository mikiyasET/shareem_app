import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class EditUsername extends StatelessWidget {
  EditUsername({super.key});

  final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        EMInput(
          controller: coreController.fName.value,
          label: 'Username',
          isError: coreController.isUsernameError.value,
          errorText: coreController.usernameErrorText.value,
          bigSize: true,
        ),
        SizedBox(height: 20),
        EMButton(label: 'Update', onPressed: () => Get.back())
      ],
    );
  }
}
