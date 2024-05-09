import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/model/Comment.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/Saved.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/service/api.dart';
import 'package:shareem_app/utils/constants.dart';

class VentApi {
  static API api = API();
  Dio client = api.client;

  Future<void> createVent() async {
    try {
      final homeController = Get.find<HomeController>();
      final tempController = Get.find<TempController>();
      final ventController = Get.find<VentController>();

      final response = await client.post(createVentRoute, data: {
        'title': tempController.postTitleText.value,
        'content': tempController.postContentText.value,
        'tags': ventController.selectedTags,
        'feeling': tempController.feeling.value
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 &&
          res.success &&
          res.message == 'CREATE_VENT_SUCCESS') {
        // tempController
        tempController.clearVentValues();
        ventController.selectedTags.clear();
        homeController.changePage(0);
        VentApi ventApi = VentApi();
        ventApi.fetchVents();
        Fluttertoast.showToast(msg: "Vent created successfully");
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        if (error.message == 'CREATE_VENT_ERROR') {
          Fluttertoast.showToast(msg: "Failed to create vent");
        }
      } else {
        Fluttertoast.showToast(msg: "There was an error");
      }
    }
  }

  Future<int> fetchVents({nextPage = false}) async {
    final ventController = Get.find<VentController>();
    try {
      if (nextPage) {
        ventController.page.value++;
      } else {
        ventController.page.value = 0;
      }
      final response = await client.get(getVentsRoute, queryParameters: {
        'page': ventController.page.value,
        'limit': ventController.limit.value,
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        if (nextPage) {
          if (res.data.isEmpty) {
            return 0; // no more data
          }
          final List<Vent> vents =
              res.data.map<Vent>((vent) => Vent.fromJson(vent)).toList();
          vents.forEach((vent) {
            if (!ventController.vents.map((x) => x.id).contains(vent.id)) {
              ventController.vents.add(vent);
            }
          });
          return 1; // load completed
        } else {
          final List<Vent> vents =
              res.data.map<Vent>((vent) => Vent.fromJson(vent)).toList();
          vents.forEach((vent) {
            if (!ventController.vents.map((x) => x.id).contains(vent.id)) {
              ventController.vents.add(vent);
            }
          });
          return 2; // refresh completed
        }
        // print(res.data);
      }
      return 5;
    } on DioException catch (e) {
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
      final error = EMResponse.fromJson(e.response.toString());
    }
  }

  Future<void> fetchComment() async {
    final ventController = Get.find<VentController>();
    try {
      final response = await client.get(getVentCommentsRoute, queryParameters: {
        'ventId': Get.find<VentController>().selectedVent.value!.id,
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        // print(res.data);
        ventController.vents.forEach((vent) {
          if (vent.id == ventController.selectedVent.value!.id) {
            print('1');
            res.data.forEach((comment) {
              if (!vent.commentList.map((x) => x.id).contains(comment['id'])) {
                vent.commentList.add(Comment.fromJson(comment));
              }
            });
            ventController.selectedVent.value = null;
            ventController.selectedVent.value = vent;
          }
        });
      }
    } on DioException catch (e) {
      print("OKK");
      final error = EMResponse.fromJson(e.response.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<void> createComment() async {
    final ventController = Get.find<VentController>();
    final tempController = Get.find<TempController>();
    try {
      final response = await client.post(createCommentsRoute, data: {
        'ventId': ventController.selectedVent.value!.id,
        'content': tempController.commentContent.value.text,
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        print("Creating comment");
        // add comment to vent list
        tempController.commentContent.value.clear();
        ventController.isPostDetailScrolling.value = true;
        for (int i = 0; i < ventController.vents.length; i++) {
          if (ventController.vents[i].id ==
              ventController.selectedVent.value!.id) {
            Comment vComment = Comment.fromJson(res.data);
            if (!ventController.vents[i].commentList
                .map((x) => x.id)
                .contains(vComment.id)) {
              ventController.vents[i].commentList.add(vComment);
              ventController.vents[i].comments++;
            }
            List<Vent> temp = ventController.vents.value;
            if (ventController.selectedVent.value != null) {
              ventController.selectedVent.value = null;
              ventController.selectedVent.value = temp[i];
            }
            ventController.vents.value = [];
            ventController.vents.value = temp;
          }
        }
        Fluttertoast.showToast(msg: "Comment added.");
      }
    } on DioException catch (e) {
      print("Creating comment");

      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print(error.message);
      } else {
        print(e);
      }
    } catch (e) {
      print("Creating comment");

      print(e);
    }
  }

  Future<void> reactVent(String ventId, bool likeType) async {
    final ventController = Get.find<VentController>();
    try {
      final response = await client.post(reactVentRoute, data: {
        'ventId': ventId,
        'type': likeType ? 'upvote' : 'downvote',
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        for (int i = 0; i < ventController.vents.length; i++) {
          if (ventController.vents[i].id == ventId) {
            print("Reacting vent ${ventController.vents[i].likes}");
            ventController.vents.value[i].likes =
                ventController.vents.value[i].isLiked
                    ? ventController.vents.value[i].likes - 1
                    : likeType
                        ? ventController.vents.value[i].likes + 1
                        : ventController.vents.value[i].likes;
            ventController.vents.value[i].isLiked = likeType
                ? ventController.vents.value[i].isLiked
                    ? false
                    : true
                : false;
            ventController.vents.value[i].isDisliked = likeType
                ? false
                : ventController.vents.value[i].isDisliked
                    ? false
                    : true;
            List<Vent> temp = ventController.vents.value;
            if (ventController.selectedVent.value != null) {
              ventController.selectedVent.value = null;
              ventController.selectedVent.value = temp[i];
            }
            ventController.vents.value = [];
            ventController.vents.value = temp;
            print("Reacting vent ${ventController.vents[i].likes}");
          }
        }
      }
    } on DioException catch (e) {
      print("Error 1 Reacting vent");
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print(error.message);
      } else {
        print(e);
      }
    } catch (e) {
      print("Error 2 Reacting vent");
      print(e);
    }
  }



  Future<void> saveVent(String ventId) async {
    final ventController = Get.find<VentController>();
    final homeController = Get.find<HomeController>();
    try {
      final response = await client.post(saveVentRoute, data: {
        'ventId': ventId,
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        for (int i = 0; i < ventController.vents.length; i++) {
          if (ventController.vents[i].id == ventId) {
            if (ventController.vents.value[i].saved
                .where((s) => s.userId == homeController.user.value!.id)
                .isEmpty) {
              ventController.vents.value[i].saved.add(Saved.fromJson(res.data));
            } else {
              ventController.vents.value[i].saved.removeWhere(
                  (s) => s.userId == homeController.user.value!.id);
            }
            List<Vent> temp = ventController.vents.value;
            if (ventController.selectedVent.value != null) {
              ventController.selectedVent.value = null;
              ventController.selectedVent.value = temp[i];
            }
            ventController.vents.value = [];
            ventController.vents.value = temp;
          }
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print(error.message);
      } else {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }
}
