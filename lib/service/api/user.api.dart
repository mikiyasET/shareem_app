import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/Saved.dart';
import 'package:shareem_app/model/User.dart';
import 'package:shareem_app/utils/constants.dart';
import '../api.dart';

class UserApi {
  static API api = API();
  Dio client = api.client;
  final coreController = Get.find<CoreController>();

  Future<void> getMe() async {
    try {
      final box = GetStorage();
      if (coreController.user.value == null && box.hasData(accessToken_)) {
        final response = await client.get(meRoute);
        EMResponse res = EMResponse.fromJson(response.toString());
        if (response.statusCode == 200 && res.message == 'USER_DATA') {
          coreController.user.value = User.fromJson(res.data);
        }
      }
    } on DioException catch (e) {
      // if (e.response != null) {
      //   final error = EMResponse.fromJson(e.response.toString());
      //   Fluttertoast.showToast(msg: error.message);
      // } else {
      //   Fluttertoast.showToast(msg: "Unknown Error");
      //   print(e);
      // }
    }
  }
  Future<EMResponse?> fetchSaved() async {
    final homeController = Get.find<HomeController>();
    try {
      final response = await client.get(getSavedRoute);
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        for (var s in res.data) {
          homeController.userSaved.value = List<Saved>.from(res.data.map((i) => Saved.fromJson(i)));
        }
      }
      return res;
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print("Error Fetching Saved");
        print(error.message);
      } else {
        print("Error 2");
        print(e);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
