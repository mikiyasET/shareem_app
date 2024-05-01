import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shareem_app/model/user.dart';

class TempController extends GetxController {
  final Rx<TextEditingController> postTitle = TextEditingController().obs;
  final Rx<TextEditingController> postBody = TextEditingController().obs;
  final RxString postTitleText = ''.obs;
  final RxString postBodyText = ''.obs;
  final Rx<Gender> gender = Gender.none.obs;
}
