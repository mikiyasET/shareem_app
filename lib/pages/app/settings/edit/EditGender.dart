import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/utils/enums.dart';
import 'package:shareem_app/widgets/EMButton.dart';

class EditGender extends StatelessWidget {
  EditGender({super.key});

  final tempController = Get.find<TempController>();

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
              isSelected: tempController.gender.value == Gender.male,
              onTap: () => tempController.gender.value = Gender.male,
            ),
            EMGenderButton(
              icon: Icons.female,
              tooltip: 'Female',
              context: context,
              isSelected: tempController.gender.value == Gender.female,
              onTap: () => tempController.gender.value = Gender.female,
            ),
            EMGenderButton(
              icon: Icons.block,
              tooltip: 'None',
              context: context,
              isSelected: tempController.gender.value == Gender.none,
              onTap: () => tempController.gender.value = Gender.none,
            ),
            const SizedBox(height: 20),
            EMButton(
              label: 'Update',
              isLoading: tempController.isUpdateButtonLoading.value,
              onPressed: () {
                UserApi userApi = UserApi();
                userApi.updateProfile('gender');
              },
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
              const SizedBox(height: 10),
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
