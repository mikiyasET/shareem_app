import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedPage extends StatefulWidget {
  SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  UserApi userApi = UserApi();

  @override
  void initState() {
    if (homeController.saveFetchedOnce.isFalse) {
      userApi.fetchSaved();
      print("Shoowwwww");
    }
    super.initState();
  }

  void _onRefresh() async {
    final int result = await userApi.fetchSaved();
    switch (result) {
      case 2:
        homeController.savedRefreshController.value.refreshCompleted();
        break;
      case 4:
        homeController.savedRefreshController.value.refreshFailed();
        break;
    }
  }

  void _onLoading() async {
    final int result = await userApi.fetchSaved(nextPage: true);
    switch (result) {
      case 0:
        homeController.savedRefreshController.value.loadNoData();
        break;
      case 1:
        homeController.savedRefreshController.value.loadComplete();
        break;
      case 3:
        homeController.savedRefreshController.value.loadFailed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: homeController.savedRefreshController.value,
          enablePullDown: true,
          enablePullUp: true,
          header: CustomHeader(
            builder: (BuildContext context, RefreshStatus? mode) {
              Widget body;
              if (mode == RefreshStatus.idle) {
                body = const Text("Pull down to refresh");
              } else if (mode == RefreshStatus.refreshing) {
                body = Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator();
              } else if (mode == RefreshStatus.failed) {
                body = const Text("Refresh Failed!Click retry!");
              } else if (mode == RefreshStatus.canRefresh) {
                body = const Text("Release to refresh");
              } else {
                body = Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator();
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text("Scroll up to load more");
              } else if (mode == LoadStatus.loading) {
                body = Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator();
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
          child: homeController.userSaved.length > 0
              ? ListView.builder(
                  itemCount: homeController.userSaved.length,
                  itemBuilder: (context, index) {
                    final saved = homeController.userSaved[index].vent!;
                    return EMPost(
                      id: saved.id,
                      title: saved.title,
                      content: saved.content,
                      feeling: saved.feeling,
                      author: saved.author.fullName,
                      date: timeago.format(saved.createdAt),
                      upvotes: saved.likes,
                      comments: saved.comments,
                      tools: false,
                      onTap: () {
                        print(saved.saved[0].toJson());
                        ventController.selectedVent.value = saved;
                        Get.toNamed('/post');
                      },
                    );
                  },
                )
              : const Center(
                  child: Text('No saved vents'),
                ),
        ),
      ),
    );
  }
}
