import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/route.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';

class NavigationMiddleWare {
  static observer(Routing? routing) {
    final routeController = Get.find<RouteController>();
    final authController = Get.find<AuthController>();

    const authRoutes = [
      '/',
      '/signIn',
      '/signUp',
      '/resetPassword',
      '/changePassword',
      '/vCode'
    ];
    if (routing?.isBack == true) {
      routeController.back(routing?.current ?? '/');
      switch (routeController.previousRoute.value) {
        case '/':
          FocusManager.instance.primaryFocus?.unfocus();
          break;
        case '/resetPassword':
          authController.isResetPassword.value = false;
          authController.clearValues();
          break;
        case '/addTags':
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: "Tag updated.");
          break;
        case '/addFeelings':
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: "Feeling updated.");
          break;
        case '/password':
          final tempController = Get.find<TempController>();
          tempController.currentPassword.value.clear();
          tempController.newPassword.value.clear();
          tempController.confirmPassword.value.clear();
          break;
        case '/chat':
          final chatController = Get.find<ChatController>();
          chatController.clear();
          break;
        case '/signUp':
          authController.clearValues();
          break;
        default:
          break;
      }
    } else {
      routeController.next(routing?.current ?? '/');
      switch (routeController.currentRoute.value) {
        case '/':
          authController.clearValues();
          FocusManager.instance.primaryFocus?.unfocus();
          break;
        case '/resetPassword':
          authController.password.value.clear();
          authController.confirmPassword.value.clear();
          authController.isEmailError.value = false;
          authController.isPasswordError.value = false;
          authController.isConfirmPasswordError.value = false;
          authController.isResetPassword.value = true;
          break;
        default:
          break;
      }
    }
    if (authRoutes.contains(routeController.currentRoute.value)) {
      authController.isLoading.value = false;
      authController.code.value.clear();
    }
  }
}
