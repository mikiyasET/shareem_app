import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';

class NavigationMiddleWare {
  static observer(Routing? routing) {
    final authController = Get.find<AuthController>();
    authController.isLoading.value = false;
    authController.code.value.clear();
    print("Pre: ${routing?.previous ?? 'Unknown'}");
    print("Route: ${routing?.current ?? 'Unknown'}");
    print("Is back: ${routing?.isBack ?? 'Unknown'}");
    if (routing != null) {
      if (routing.current == '/signIn' ||
          routing.current == '/resetPassword' ||
          (routing.current == '/' && routing.isBack == true)) {
        authController.isResetPassword.value = false;
        authController.clearValues();
      }
    }
  }
}
