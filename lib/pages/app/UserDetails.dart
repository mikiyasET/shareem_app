import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/model/user.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/widgets/EMButton.dart';

import '../../widgets/EMInput.dart';

class UserDetails extends StatelessWidget {
  UserDetails({super.key});

  final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) {
    String? selectedItem;
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'We recommend completing your profile to get the best experience'),
              const SizedBox(height: 20),
              EMButton(
                label: 'Complete',
                onPressed: () => coreController.completeProfile(),
              ),
              const SizedBox(height: 20),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'By clicking "Complete" you agree to our Terms of Service and Privacy Policy',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
          child: Obx(
            () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Complete your profile',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You are almost there! Just a few more steps to complete your profile.',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 30),
                  EMInput(
                    controller: coreController.username.value,
                    label: 'Username',
                    isError: coreController.isUsernameError.value,
                    errorText: coreController.usernameErrorText.value,
                  ),
                  const SizedBox(height: 20),
                  EMInput(
                    controller: coreController.fName.value,
                    label: 'First Name',
                    isError: coreController.isfNameError.value,
                    errorText: coreController.fNameErrorText.value,
                  ),
                  const SizedBox(height: 20),
                  EMInput(
                    controller: coreController.lName.value,
                    label: 'Last Name',
                    isError: coreController.islNameError.value,
                    errorText: coreController.lNameErrorText.value,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                      genderList.length,
                      (index) => TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          coreController.gender.value =
                              genderList[index]['preset'];
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              genderList[index]['iconData'],
                              color: coreController.gender.value ==
                                      genderList[index]['preset']
                                  ? Colors.black
                                  : Colors.black54,
                              size: 23,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              genderList[index]['title'],
                              style: TextStyle(
                                  color: coreController.gender.value ==
                                          genderList[index]['preset']
                                      ? Colors.black
                                      : Colors.black54,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  coreController.isGenderError.value
                      ? Text(
                          coreController.genderErrorText.value,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        )
                      : Container()
                ]),
          ),
        ),
      ),
    );
  }
}
