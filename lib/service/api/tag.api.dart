import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/service/api.dart';
import 'package:shareem_app/utils/constants.dart';

class TagApi {
  static API api = API();
  Dio client = api.client;

  Future<dynamic> fetchTags() async {
    try {
      final tags = await client.get(getTagsRoute);
      final EMResponse res = EMResponse.fromJson(tags);
      if (tags.statusCode == 200 &&
          res.success &&
          res.message == 'FETCH_TAG_SUCCESS') {
        final ventController = Get.find<VentController>();
        final homeController = Get.find<HomeController>();
        homeController.fetchedTags.value = true;
        ventController.tags.value =
            res.data.map<Tag>((tag) => Tag.fromJson(tag)).toList();
      }
      return tags;
    } on DioException catch (e) {
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response);
        print(error.message);
      } else {
        print("There was an error");
      }
    } catch (e) {
      print(e);
    }
  }
}
