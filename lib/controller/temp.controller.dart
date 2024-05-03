import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shareem_app/model/User.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/utils/enums.dart';

class TempController extends GetxController {
  final Rx<TextEditingController> postTitle = TextEditingController().obs;
  final Rx<TextEditingController> postContent = TextEditingController().obs;
  final Rx<TextEditingController> commentContent = TextEditingController().obs;
  final RxString postTitleText = ''.obs;
  final RxString postContentText = ''.obs;
  final Rx<Gender> gender = Gender.none.obs;
  final Rx<String> feeling = ''.obs;

  @override
  void onInit() {
    VentApi ventApi = VentApi();
    ventApi.fetchVents();
    super.onInit();
  }

  void clearVentValues() {
    postTitle.value.clear();
    postContent.value.clear();
    postTitleText.value = '';
    postContentText.value = '';
    feeling.value = '';
  }
}
