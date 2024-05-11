import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/model/Comment.dart';
import 'package:shareem_app/model/Draft.dart';
import 'package:shareem_app/model/Like.dart';
import 'package:shareem_app/model/Saved.dart';
import 'package:shareem_app/model/User.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/service/api/tag.api.dart';
import 'package:shareem_app/widgets/EMAlertDialog.dart';

class HomeController extends GetxController {
  final RxInt pageIndex = 0.obs;
  final RxString title = 'Home'.obs;
  final Rx<User?> user = Rx<User?>(null);
  final coreController = Get.find<CoreController>();

  final RxList<Vent> userVented = <Vent>[].obs;
  final RxInt myPageIndex = 0.obs;
  final RxInt myLimit = 10.obs;
  final RxBool myFetchedOnce = false.obs;
  final Rx<RefreshController> myRefreshController =
      RefreshController(initialRefresh: false).obs;

  final RxList<Saved> userSaved = <Saved>[].obs;
  final RxInt savedPageIndex = 0.obs;
  final RxInt savedLimit = 10.obs;
  final RxBool saveFetchedOnce = false.obs;
  final Rx<RefreshController> savedRefreshController =
      RefreshController(initialRefresh: false).obs;

  final RxList<Liked> userLiked = <Liked>[].obs;
  final RxInt likedPageIndex = 0.obs;
  final RxInt likedLimit = 10.obs;
  final RxBool likedFetchedOnce = false.obs;
  final Rx<RefreshController> likedRefreshController =
      RefreshController(initialRefresh: false).obs;

  final RxList<Comment> userCommented = <Comment>[].obs;
  final RxInt commentedPageIndex = 0.obs;
  final RxInt commentedLimit = 10.obs;
  final RxBool commentedFetchedOnce = false.obs;
  final Rx<RefreshController> commentedRefreshController =
      RefreshController(initialRefresh: false).obs;

  @override
  void onInit() {
    TagApi tagApi = TagApi();
    tagApi.fetchTags();
    user.value = coreController.user.value;
    super.onInit();
  }

  void changePageIndex(BuildContext context, int index) {
    if (pageIndex.value != index) {
      final ventController = Get.find<VentController>();
      final tempController = Get.find<TempController>();

      if (ventController.selectedTags.length > 0 ||
          tempController.feeling.value.isNotEmpty ||
          tempController.postTitle.value.text.isNotEmpty ||
          tempController.postContent.value.text.isNotEmpty) {
        EMAlertDialog(
          context: context,
          title: "Save Draft",
          content: const Text(
              "Save your changes and come back to finish your post later"),
          actions: [
            TextButton(
              onPressed: () {
                tempController.clearVentValues();
                ventController.selectedTags.clear();
                ScaffoldMessenger.of(context).clearSnackBars();
                Get.back();
                changePage(index);
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                if (tempController.postTitleText.value.isEmpty) {
                  Get.back();
                  // show default snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'To save your draft, you need to add a title.',
                      ),
                    ),
                  );
                  return;
                } else {
                  final draft = Draft.fromJson({
                    'title': tempController.postTitle.value.text,
                    'content': tempController.postContent.value.text,
                    'tags': ventController.selectedTags.isEmpty
                        ? []
                        : ventController.selectedTags
                            .map((element) => {'id': element}),
                    'feeling': tempController.feeling.value,
                  });
                  ventController.addDraft(draft);
                }
                tempController.clearVentValues();
                ventController.selectedTags.clear();
                ScaffoldMessenger.of(context).clearSnackBars();
                Get.back();
                changePage(index);
              },
              child: const Text('Save'),
            ),
          ],
          isDismissible: true,
        );
      } else {
        changePage(index);
      }
    }
  }

  void changePage(int index) {
    if (pageIndex.value != index) {
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
}
