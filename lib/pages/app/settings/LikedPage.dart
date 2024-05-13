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

class LikedPage extends StatefulWidget {
  const LikedPage({super.key});

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  UserApi userApi = UserApi();

  @override
  void initState() {
    if (homeController.likedFetchedOnce.isFalse) {
      userApi.fetchLiked();
    }
    super.initState();
  }

  void _onRefresh() async {
    final int result = await userApi.fetchLiked();
    switch (result) {
      case 2:
        homeController.likedRefreshController.value.refreshCompleted();
        break;
      case 4:
        homeController.likedRefreshController.value.refreshFailed();
        break;
    }
  }

  void _onLoading() async {
    final int result = await userApi.fetchLiked(nextPage: true);
    switch (result) {
      case 0:
        homeController.likedRefreshController.value.loadNoData();
        break;
      case 1:
        homeController.likedRefreshController.value.loadComplete();
        break;
      case 3:
        homeController.likedRefreshController.value.loadFailed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked'),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: homeController.likedRefreshController.value,
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
              return SizedBox(
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
              return SizedBox(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: homeController.userLiked.length > 0
              ? ListView.builder(
                  itemCount: homeController.userLiked.length,
                  itemBuilder: (context, index) {
                    final liked = homeController.userLiked[index].vent!;
                    return EMPost(
                      id: liked.id,
                      title: liked.title,
                      content: liked.content,
                      feeling: liked.feeling,
                      author: liked.author.fullName,
                      date: timeago.format(liked.createdAt),
                      upvotes: liked.likes,
                      comments: liked.comments,
                      tools: false,
                      onTap: () {
                        ventController.selectedVent.value = liked;
                        Get.toNamed('/post');
                      },
                    );
                  },
                )
              : const Center(
                  child: Text('No liked vents'),
                ),
        ),
      ),
    );
  }
}
