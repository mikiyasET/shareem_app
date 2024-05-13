import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getX;
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/model/Comment.dart';
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
  final coreController = getX.Get.find<CoreController>();

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
    final homeController = getX.Get.find<HomeController>();
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
    final homeController = getX.Get.find<HomeController>();
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
    final homeController = getX.Get.find<HomeController>();
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

  Future<int> fetchCommented({nextPage = false}) async {
    final homeController = getX.Get.find<HomeController>();
    try {
      if (nextPage) {
        homeController.commentedPageIndex.value++;
      }

      final response = await client.get(getCommentedRoute, queryParameters: {
        'page': nextPage ? homeController.commentedPageIndex.value : 0,
        'limit': nextPage
            ? homeController.commentedLimit.value
            : homeController.commentedLimit.value *
                (homeController.commentedPageIndex.value + 1),
      });

      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.success) {
        homeController.commentedFetchedOnce.value = true;
        if (nextPage) {
          if (res.data.isEmpty) {
            return 0; // no more data
          }
          final List<Comment> commented =
              res.data.map<Comment>((s) => Comment.fromJson(s)).toList();
          for (var comment in commented) {
            if (!homeController.userCommented
                .map((x) => x.id)
                .contains(comment)) {
              homeController.userCommented.add(comment);
            }
          }
          return 1;
        } else {
          final List<Comment> commented =
              res.data.map<Comment>((s) => Comment.fromJson(s)).toList();
          homeController.userCommented.assignAll(commented);
          return 2;
        }
      }
      return 5;
    } on DioException catch (e) {
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        print("Error Fetching Comment");
        print(error.toJson());
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

  Future<void> uploadImage(BuildContext context) async {
    final tempController = getX.Get.find<TempController>();
    final file = await MultipartFile.fromFile(
      tempController.profileImage.value,
      filename: tempController.profileImage.value.split("/").last,
      contentType: MediaType('image', 'jpeg'),
    );
    final FormData formData = FormData.fromMap({
      'photo': file,
    });

    final response = await client.put(
      editPhotoRoute,
      data: formData,
      options: Options(headers: {
        'Content-Type': 'multipart/form-data',
      }),
    );

    final res = EMResponse.fromJson(response.toString());
    if (res.success) {
      final homeController = getX.Get.find<HomeController>();
      homeController.user.value = User.fromJson(res.data);
      getX.Get.back();
      tempController.profileImage.value = '';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Picture Updated", textAlign: TextAlign.center),
          backgroundColor: Color(0xff068181),
        ),
      );
    }
  }

  Future<void> updateProfile(String type) async {
    final tempController = getX.Get.find<TempController>();
    final homeController = getX.Get.find<HomeController>();
    try {
      tempController.isUpdateButtonLoading.value = true;
      tempController.isfNameError.value = false;
      tempController.islNameError.value = false;
      tempController.isUsernameError.value = false;
      tempController.isEmailError.value = false;
      tempController.isGenderError.value = false;
      final data;
      switch (type) {
        case 'name':
          if (tempController.fName.value.text.isEmpty) {
            tempController.isfNameError.value = true;
            tempController.fNameErrorText.value = 'First name is required';
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          if (tempController.lName.value.text.isEmpty) {
            tempController.islNameError.value = true;
            tempController.lNameErrorText.value = 'Last name is required';
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          if (tempController.fName.value.text ==
                  homeController.user.value?.fName &&
              tempController.lName.value.text ==
                  homeController.user.value?.lName) {
            if (tempController.fName.value.text ==
                homeController.user.value?.fName) {
              tempController.isfNameError.value = true;
              tempController.fNameErrorText.value = 'First name is the same';
            }
            if (tempController.lName.value.text ==
                homeController.user.value?.lName) {
              tempController.islNameError.value = true;
              tempController.lNameErrorText.value = 'Last name is the same';
            }
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          data = {
            'fName': tempController.fName.value.text,
            'lName': tempController.lName.value.text,
          };
          break;
        case 'username':
          if (tempController.username.value.text.isEmpty) {
            tempController.isUsernameError.value = true;
            tempController.usernameErrorText.value = 'Username is required';
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          if (tempController.username.value.text ==
              homeController.user.value?.username) {
            tempController.isUsernameError.value = true;
            tempController.usernameErrorText.value = 'Username is the same';
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          data = {
            'username': tempController.username.value.text,
          };
          break;
        case 'gender':
          if (tempController.gender.value ==
              homeController.user.value?.gender) {
            tempController.isGenderError.value = true;
            tempController.genderErrorText.value = 'Gender is the same';
            tempController.isUpdateButtonLoading.value = false;
          }
          data = {
            'gender': tempController.gender.value.toString().split('.').last[0],
          };
          break;
        case 'email':
          if (tempController.email.value.text.isEmpty) {
            tempController.isEmailError.value = true;
            tempController.emailErrorText.value = 'Email is required';
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          if (tempController.email.value.text ==
              homeController.user.value?.email) {
            tempController.isEmailError.value = true;
            tempController.emailErrorText.value = 'Email is the same';
            tempController.isUpdateButtonLoading.value = false;
            return;
          }
          data = {
            'email': tempController.email.value.text,
          };
          break;
        default:
          data = {};
      }
      final response = await client.put("$editUserRoute/$type", data: data);
      tempController.isUpdateButtonLoading.value = false;
      EMResponse res = EMResponse.fromJson(response.toString());
      if (res.success) {
        Fluttertoast.showToast(msg: 'Profile Updated');
        homeController.user.value = User.fromJson(res.data);
        getX.Get.back();
      }
    } on DioException catch (e) {
      tempController.isUpdateButtonLoading.value = false;
      if (e.response != null) {
        final error = EMResponse.fromJson(e.response.toString());
        if (error.message == 'USERNAME_ALREADY_EXISTS') {
          tempController.isUsernameError.value = true;
          tempController.usernameErrorText.value = 'Username already exists';
        } else if (error.message == 'USERNAME_NO_CHANGE') {
          tempController.isUsernameError.value = true;
          tempController.usernameErrorText.value = 'Username is the same';
        }
        print("Error updating profile");
        print(error.message);
      } else {
        print("Error updating profile (not response)");
        print(e);
      }
    } catch (e) {
      tempController.isUpdateButtonLoading.value = false;
      print("Error updating profile (unknown error)");
      print(e);
    }
  }
}
