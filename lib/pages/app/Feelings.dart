import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/widgets/EMButton.dart';

class Feelings extends StatelessWidget {
  Feelings({super.key});
  final tempController = Get.find<TempController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Feeling'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                "Let us know how you're feeling about this vent.",
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.8),
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: feelingList.length,
                itemBuilder: (context, index) {
                  return Obx(
                    ()=> RadioListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                      title: Text(ucWords(feelingList[index]['name'].toString())),
                      value: feelingList[index]['preset'],
                      groupValue: tempController.feeling.value,
                      onChanged: (_) {
                        tempController.feeling.value = feelingList[index]['preset']!;
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: EMButton(
                label: 'Save', onPressed: () => Navigator.pop(context)),
          ),
        ));
  }
}
