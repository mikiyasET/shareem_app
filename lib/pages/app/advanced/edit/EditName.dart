import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class EditName extends StatelessWidget {
  EditName({super.key});

  final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        EMInput(
          controller: coreController.fName.value,
          label: 'First Name',
          isError: coreController.isfNameError.value,
          errorText: coreController.fNameErrorText.value,
          bigSize: true,
        ),
        const SizedBox(height: 15),
        EMInput(
          controller: coreController.lName.value,
          label: 'Last Name',
          isError: coreController.islNameError.value,
          errorText: coreController.lNameErrorText.value,
          bigSize: true,
        ),
        SizedBox(height: 30),
        EMButton(label: 'Update', onPressed: () => Get.back())

      ],
    );
  }
}
