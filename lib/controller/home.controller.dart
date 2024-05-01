import 'package:get/get.dart';
import 'package:shareem_app/model/user.dart';

class HomeController extends GetxController {
  final RxInt pageIndex = 0.obs;
  final RxString title = 'Home'.obs;
  final Rx<User?> user =  Rx<User?>(null);

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
        title.value = '';
        break;
      case 3:
        title.value = 'Notifications';
        break;
      case 4:
        title.value = 'Settings';
        break;
      default:
        title.value = 'Home';
    }
  }
}
