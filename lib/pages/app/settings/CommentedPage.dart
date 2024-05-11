import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMComment.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentedPage extends StatefulWidget {
  const CommentedPage({super.key});

  @override
  State<CommentedPage> createState() => _CommentedPageState();
}

class _CommentedPageState extends State<CommentedPage> {
  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  UserApi userApi = UserApi();

  @override
  void initState() {
    if (homeController.commentedFetchedOnce.isFalse) {
      userApi.fetchCommented();
    }
    super.initState();
  }

  void _onRefresh() async {
    final int result = await userApi.fetchCommented();
    switch (result) {
      case 2:
        homeController.commentedRefreshController.value.refreshCompleted();
        homeController.commentedRefreshController.value.resetNoData();
        break;
      case 4:
        homeController.commentedRefreshController.value.refreshFailed();
        break;
    }
  }

  void _onLoading() async {
    final int result = await userApi.fetchCommented(nextPage: true);
    switch (result) {
      case 0:
        homeController.commentedRefreshController.value.loadNoData();
        break;
      case 1:
        homeController.commentedRefreshController.value.loadComplete();
        break;
      case 3:
        homeController.commentedRefreshController.value.loadFailed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Comments'),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: homeController.commentedRefreshController.value,
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
                body = const Text("No more comments.");
              }
              return SizedBox(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: homeController.userCommented.length > 0
              ? ListView.builder(
                  itemCount: homeController.userCommented.length,
                  itemBuilder: (context, index) {
                    final comment = homeController.userCommented[index];
                    return EMComment(
                      author: comment.user!.fullName,
                      content: comment.content,
                      date: timeago.format(comment.createdAt),
                      upvotes: comment.likes,
                      comments: comment.comments,
                      onTap: () {
                        ventController.selectedVent.value = comment.vent;
                        Get.toNamed('/post');
                      },
                    );
                  },
                )
              : const Center(
                  child: Text('You haven\'t commented on any vent yet.'),
                ),
        ),
      ),
    );
  }
}
