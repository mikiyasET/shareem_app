import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/vent.api.dart';

void postVent(BuildContext context) {
  final tempController = Get.find<TempController>();
  final ventController = Get.find<VentController>();

  // Post vent
  print('Posting vent');
  if (tempController.postTitle.value.text.isNotEmpty) {
    if (tempController.postContent.value.text.isNotEmpty) {
      if (ventController.selectedTags.isNotEmpty) {
        if (tempController.feeling != '') {
          VentApi ventApi = VentApi();
          ventApi.createVent();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a feeling'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one tag'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vent body is required'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vent title is required'),
      ),
    );
  }
}
