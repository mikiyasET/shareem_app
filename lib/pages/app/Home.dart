import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/widgets/EMLoading.dart';
import 'package:shareem_app/widgets/EMPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class Home extends StatelessWidget {
  Home({super.key});

  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();

  final VentApi ventApi = VentApi();

  void _onRefresh() async {
    final int result = await ventApi.fetchVents();
    switch (result) {
      case 2:
        ventController.refreshController.value.refreshCompleted();
        break;
      case 4:
        ventController.refreshController.value.refreshFailed();
        break;
    }
  }

  void _onLoading() async {
    final int result = await ventApi.fetchVents(nextPage: true);
    switch (result) {
      case 0:
        ventController.refreshController.value.loadNoData();
        break;
      case 1:
        ventController.refreshController.value.loadComplete();
        break;
      case 3:
        ventController.refreshController.value.loadFailed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.isVentedLoading.value
          ? Center(child: const EMLoading())
          : homeController.pageIndex.value == 0
              ? SmartRefresher(
                  controller: ventController.refreshController.value,
                  enablePullDown: true,
                  enablePullUp: true,
                  header: const ClassicHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text("Scroll up to load more");
                      } else if (mode == LoadStatus.loading) {
                        body = const EMLoading();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text("Release to load more");
                      } else {
                        body = const Text("No more vents.");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ventController.vents.isNotEmpty
                      ? ListView.builder(
                          itemCount: ventController.vents.length,
                          itemBuilder: (context, index) {
                            final Vent vent = ventController.vents[index];
                            final userId = homeController.user.value!.id;
                            return EMPost(
                              id: vent.id,
                              title: vent.title,
                              content: vent.content,
                              feeling: vent.feeling,
                              author: vent.author,
                              identity: vent.identity,
                              date: timeago.format(vent.createdAt),
                              upvotes: vent.likes,
                              comments: vent.comments,
                              tags: vent.tags,
                              isLiked: vent.isLiked,
                              isDisliked: vent.isDisliked,
                              isSaved: vent.saved
                                  .where((e) => e.userId == userId)
                                  .isNotEmpty,
                              onTap: () {
                                ventController.selectedVent.value = vent;
                                Get.toNamed('/post');
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text('No vents found'),
                        ),
                )
              : const SizedBox(),
    );
  }
}
