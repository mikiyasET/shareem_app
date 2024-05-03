import 'package:get/get.dart';

class RouteController extends GetxController {
  final RxString currentRoute = '/'.obs;
  final RxString previousRoute = '/'.obs;
  final RxBool isBack = false.obs;

  void next(String route) {
    previousRoute.value = currentRoute.value;
    currentRoute.value = route;
    isBack.value = false;
  }

  void back(String route) {
    previousRoute.value = currentRoute.value;
    currentRoute.value = route;
    isBack.value = true;
  }
}