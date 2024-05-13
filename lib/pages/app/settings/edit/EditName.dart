import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class EditName extends StatelessWidget {
  EditName({super.key});

  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          EMInput(
            controller: tempController.fName.value,
            label: 'First Name',
            isError: tempController.isfNameError.value,
            errorText: tempController.fNameErrorText.value,
            bigSize: true,
          ),
          const SizedBox(height: 15),
          EMInput(
            controller: tempController.lName.value,
            label: 'Last Name',
            isError: tempController.islNameError.value,
            errorText: tempController.lNameErrorText.value,
            bigSize: true,
          ),
          SizedBox(height: 30),
          EMButton(
            label: 'Update',
            isLoading: tempController.isUpdateButtonLoading.value,
            onPressed: () {
              UserApi userApi = UserApi();
              userApi.updateProfile('name');
            },
          )
        ],
      ),
    );
  }
}
