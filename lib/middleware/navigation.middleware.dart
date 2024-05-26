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
        case '/resetPassword':
          authController.isResetPassword.value = false;
          break;
        case '/addTags':
          Fluttertoast.showToast(msg: "Tag updated.");
          break;
        case '/addFeelings':
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
        default:
          break;
      }
    } else {
      routeController.next(routing?.current ?? '/');
      switch (routeController.currentRoute.value) {
        case '/':
          authController.clearValues();
          break;
        case '/signUp':
          break;
        case '/resetPassword':
          authController.isResetPassword.value = false;
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

// final authController = Get.find<AuthController>();
// authController.isLoading.value = false;
// authController.code.value.clear();
// print("Pre: ${routing?.previous ?? 'Unknown'}");
// print("Route: ${routing?.current ?? 'Unknown'}");
// print("Is back: ${routing?.isBack ?? 'Unknown'}");
// if (routing != null) {
//   if (routing.current == '/signIn' ||
//       routing.current == '/resetPassword' ||
//       (routing.current == '/' && routing.isBack == true)) {
//     authController.isResetPassword.value = false;
//     authController.clearValues();
//   }
// }
}
