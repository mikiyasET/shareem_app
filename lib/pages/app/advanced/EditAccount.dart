import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/helpers/editAccount.helper.dart';
import 'package:shareem_app/pages/app/advanced/edit/EditEmail.dart';
import 'package:shareem_app/pages/app/advanced/edit/EditGender.dart';
import 'package:shareem_app/pages/app/advanced/edit/EditName.dart';
import 'package:shareem_app/pages/app/advanced/edit/EditUsername.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class EditAccount extends StatelessWidget {
  EditAccount({super.key});

  final EditAccountData type = getEditAccountType(Get.parameters['type']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Info'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: IndexedStack(
          index: type.index,
          children: [
            EditName(),
            EditUsername(),
            EditGender(),
            EditEmail()
          ],
        ),
      ),
    );
  }
}
