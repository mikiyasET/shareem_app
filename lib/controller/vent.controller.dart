import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/model/Draft.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/utils/constants.dart';

class VentController extends GetxController {
  final RxList<Tag> tags = <Tag>[].obs;
  final RxList<Vent> vents = <Vent>[].obs;
  final RxList<int> selectedTags = <int>[].obs;
  final Rx<Vent?> selectedVent = Rx<Vent?>(null);

  final RxBool isPostDetailScrolling = true.obs;
  final Rx<ScrollController> scrollController = ScrollController().obs;

  final RxInt page = 0.obs;
  final RxInt limit = 10.obs;
  final Rx<RefreshController> refreshController =
      RefreshController(initialRefresh: false).obs;

  final RxList<Draft> drafts = <Draft>[].obs;

  void addDraft(Draft draft) {
    if (draft.id == 0) {
      draft.id = drafts.isEmpty ? 0 : drafts.first.id + 1;
    }
    drafts.add(draft);
    final box = GetStorage();
    box.write(draft_, drafts.map((e) => e.toJson()).toList());
    final homeController = Get.find<HomeController>();
    homeController.draftCount.value = drafts.length;
  }

  void fetchDrafts() async {
    final box = GetStorage();
    final List<dynamic> data = await box.read(draft_);
    data.sort((a, b) => b['id'].compareTo(a['id']));
    drafts.assignAll(data.map((e) => Draft.fromJson(e)).toList());
  }

  void removeDraft(int id) {
    drafts.removeWhere((element) => element.id == id);
    final box = GetStorage();
    box.write(draft_, drafts.map((e) => e.toJson()).toList());
    final homeController = Get.find<HomeController>();
    homeController.draftCount.value = drafts.length;
  }
}
