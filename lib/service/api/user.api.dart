import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/Like.dart';
import 'package:shareem_app/model/Saved.dart';
import 'package:shareem_app/model/User.dart';
import 'package:shareem_app/model/Vent.dart';
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

  Future<int> fetchVented({nextPage = false}) async {
    final homeController = Get.find<HomeController>();
    try {
      if (nextPage) {
        homeController.myPageIndex.value++;
      }
      final response = await client.get(getVentedRoute, queryParameters: {
        'page': nextPage ? homeController.myPageIndex.value : 0,
        'limit': nextPage
            ? homeController.myLimit.value
            : homeController.myLimit.value *
                (homeController.myPageIndex.value + 1),
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        homeController.myFetchedOnce.value = true;
        if (nextPage) {
          if (res.data.isEmpty) {
            return 0; // no more data
          }
          final List<Vent> vents =
              res.data.map<Vent>((s) => Vent.fromJson(s)).toList();
          for (var vent in vents) {
            if (!homeController.userVented.map((x) => x.id).contains(vent.id)) {
              homeController.userVented.add(vent);
            }
          }
          return 1;
        } else {
          final List<Vent> vents =
              res.data.map<Vent>((s) => Vent.fromJson(s)).toList();
          homeController.userVented.assignAll(vents);
          return 2;
        }
      }
      return 5;
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print("Error Fetching Saved");
        print(error.message);
      } else {
        print("Error 2");
        print(e);
      }
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
    } catch (e) {
      print(e);
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
    }
  }

  Future<int> fetchSaved({nextPage = false}) async {
    final homeController = Get.find<HomeController>();
    try {
      if (nextPage) {
        homeController.savedPageIndex.value++;
      }
      final response = await client.get(getSavedRoute, queryParameters: {
        'page': nextPage ? homeController.savedPageIndex.value : 0,
        'limit': nextPage
            ? homeController.savedLimit.value
            : homeController.savedLimit.value *
                (homeController.savedPageIndex.value + 1),
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        homeController.saveFetchedOnce.value = true;
        if (nextPage) {
          if (res.data.isEmpty) {
            return 0; // no more data
          }
          final List<Saved> saved =
              res.data.map<Saved>((s) => Saved.fromJson(s)).toList();
          for (var save in saved) {
            if (!homeController.userSaved.map((x) => x.id).contains(save.id)) {
              homeController.userSaved.add(save);
            }
          }
          return 1;
        } else {
          final List<Saved> saved =
              res.data.map<Saved>((s) => Saved.fromJson(s)).toList();
          homeController.userSaved.assignAll(saved);

          return 2;
        }
      }
      return 5;
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print("Error Fetching Saved");
        print(error.message);
      } else {
        print("Error 2");
        print(e);
      }
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
    } catch (e) {
      print(e);
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
    }
  }

  Future<int> fetchLiked({nextPage = false}) async {
    final homeController = Get.find<HomeController>();
    try {
      if (nextPage) {
        homeController.likedPageIndex.value++;
      }

      final response = await client.get(getSavedRoute, queryParameters: {
        'page': nextPage ? homeController.likedPageIndex.value : 0,
        'limit': nextPage
            ? homeController.likedLimit.value
            : homeController.likedLimit.value *
                (homeController.likedPageIndex.value + 1),
      });

      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        homeController.likedFetchedOnce.value = true;
        if (nextPage) {
          if (res.data.isEmpty) {
            return 0; // no more data
          }
          final List<Liked> liked =
              res.data.map<Liked>((s) => Liked.fromJson(s)).toList();
          for (var like in liked) {
            if (!homeController.userLiked.map((x) => x.id).contains(like.id)) {
              homeController.userLiked.add(like);
            }
          }
          return 1;
        } else {
          final List<Liked> liked =
              res.data.map<Liked>((s) => Liked.fromJson(s)).toList();
          homeController.userLiked.assignAll(liked);

          return 2;
        }
      }
      return 5;
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print("Error Fetching Saved");
        print(error.message);
      } else {
        print("Error 2");
        print(e);
      }
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
    } catch (e) {
      print(e);
      if (nextPage) {
        return 3; // load failed
      } else {
        return 4; // refresh failed
      }
    }
  }
}
