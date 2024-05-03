import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/service/api/vent.api.dart';
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
    return homeController.pageIndex.value == 0 ? Obx(
      () => SmartRefresher(
        controller: ventController.refreshController.value,
        enablePullDown: true,
        enablePullUp: true,
        header: const ClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Scroll up to load more");
            } else if (mode == LoadStatus.loading) {
              body = Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Release to load more");
            } else {
              body = Text("No more vents.");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemCount: ventController.vents.length,
          itemBuilder: (context, index) {
            final Vent vent = ventController.vents[index];
            print(vent);
            return EMPost(
              id: vent.id,
              title: vent.title,
              content: vent.content,
              feeling: vent.feeling,
              author: vent.author.fullName,
              date: timeago.format(vent.createdAt),
              upvotes: vent.likes,
              comments: vent.comments,
              tags: vent.tags,
              isLiked: vent.isLiked,
              isDisliked: vent.isDisliked,
              onTap: () {
                ventController.selectedVent.value = vent;
                Get.toNamed('/post');
              },
            );
          },
        ),
      ),
    ) : Container();
  }
}
