import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/user.dart';
import 'package:shareem_app/utils/constants.dart';
import '../../controller/auth.controller.dart';
import '../api.dart';

class UserApi {
  static API api = API();
  Dio client = api.client;
  final coreController = Get.find<CoreController>();

  Future<void> getMe() async {
    try {
      final box = GetStorage();
      if (coreController.user.value == null && box.read(accessToken_) != null) {
        final response = await client.get(meRoute);
        EMResponse res = EMResponse.fromJson(response.toString());
        if (response.statusCode == 200 && res.message == 'USER_DATA') {
          coreController.user.value = User.fromJson(res.data);
        }
      }
    } on DioException catch (e) {
      print("Get Me Error");
      print(e);
      final error = EMResponse.fromJson(e.response.toString());
      Fluttertoast.showToast(msg: error.message);
    }
  }
}
