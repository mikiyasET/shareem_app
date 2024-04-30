import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/editAccount.controller.dart';
import 'package:shareem_app/model/user.dart';
import 'package:shareem_app/widgets/EMButton.dart';

class EditGender extends StatelessWidget {
  EditGender({super.key});

  final editAccountController = Get.find<EditAccountController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Obx(
        () => Column(
          children: [
            EMGenderButton(
              icon: Icons.male,
              tooltip: 'Male',
              context: context,
              isSelected: editAccountController.gender.value == Gender.male,
              onTap: () => editAccountController.gender.value = Gender.male,
            ),
            EMGenderButton(
              icon: Icons.female,
              tooltip: 'Female',
              context: context,
              isSelected: editAccountController.gender.value == Gender.female,
              onTap: () => editAccountController.gender.value = Gender.female,
            ),
            EMGenderButton(
              icon: Icons.block,
              tooltip: 'None',
              context: context,
              isSelected: editAccountController.gender.value == Gender.none,
              onTap: () => editAccountController.gender.value = Gender.none,
            ),
            SizedBox(height: 20),
            EMButton(
              label: 'Update',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget EMGenderButton({
    required String tooltip,
    required IconData icon,
    void Function()? onTap,
    required BuildContext context,
    bool isSelected = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * .2,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(isSelected ? 1 : .06),
              width: isSelected ? 3 : 0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 100,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(isSelected ? 1 : .3),
              ),
              SizedBox(height: 10),
              Text(
                tooltip,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(isSelected ? 1 : .5),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
