import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/model/Tag.dart';
import 'package:shareem_app/model/Vent.dart';

class VentController extends GetxController {
  final RxList<Tag> tags = <Tag>[].obs;
  final RxList<int> selectedTags = <int>[].obs;
  final RxList<Vent> vents = <Vent>[].obs;
  final Rx<Vent?> selectedVent = Rx<Vent?>(null);
  final RxInt page = 0.obs;
  final RxInt limit = 10.obs;
  final Rx<ScrollController> scrollController = ScrollController().obs;
  final RxBool isPostDetailScrolling = true.obs;
  final Rx<RefreshController> refreshController = RefreshController(initialRefresh: false).obs;

  @override
  void onInit() {
    super.onInit();
  }
}
