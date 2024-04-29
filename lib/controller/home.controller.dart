import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt pageIndex = 0.obs;
  final RxString title = 'Home'.obs;

  void changePageIndex(int index) {
    pageIndex.value = index;
    switch (index) {
      case 0:
        title.value = 'Home';
        break;
      case 1:
        title.value = 'Chats';
        break;
      case 2:
        title.value = 'Notifications';
        break;
      case 3:
        title.value = 'Settings';
        break;
      default:
        title.value = 'Home';
    }
  }
}
