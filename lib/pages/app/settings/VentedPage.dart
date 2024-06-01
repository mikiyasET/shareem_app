import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMLoading.dart';
import 'package:shareem_app/widgets/EMPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class VentedPage extends StatefulWidget {
  const VentedPage({super.key});

  @override
  State<VentedPage> createState() => _VentedPageState();
}

class _VentedPageState extends State<VentedPage> {
  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  UserApi userApi = UserApi();

  @override
  void initState() {
    if (homeController.myFetchedOnce.isFalse) {
      userApi.fetchVented();
    }
    super.initState();
  }

  void _onRefresh() async {
    final int result = await userApi.fetchVented();
    switch (result) {
      case 2:
        homeController.myRefreshController.value.refreshCompleted();
        homeController.myRefreshController.value.resetNoData();
        break;
      case 4:
        homeController.myRefreshController.value.refreshFailed();
        break;
    }
  }

  void _onLoading() async {
    final int result = await userApi.fetchVented(nextPage: true);
    switch (result) {
      case 0:
        homeController.myRefreshController.value.loadNoData();
        break;
      case 1:
        homeController.myRefreshController.value.loadComplete();
        break;
      case 3:
        homeController.myRefreshController.value.loadFailed();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vents'),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: homeController.myRefreshController.value,
          enablePullDown: true,
          enablePullUp: true,
          header: CustomHeader(
            builder: (BuildContext context, RefreshStatus? mode) {
              Widget body;
              if (mode == RefreshStatus.idle) {
                body = const Text("Pull down to refresh");
              } else if (mode == RefreshStatus.refreshing) {
                body = const EMLoading();
              } else if (mode == RefreshStatus.failed) {
                body = const Text("Refresh Failed!Click retry!");
              } else if (mode == RefreshStatus.canRefresh) {
                body = const Text("Release to refresh");
              } else {
                body = const EMLoading();
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
          child: homeController.myFetchedOnce.value == false
              ? EMLoading()
              : homeController.userVented.length > 0
                  ? ListView.builder(
                      itemCount: homeController.userVented.length,
                      itemBuilder: (context, index) {
                        final vented = homeController.userVented[index];
                        return EMPost(
                          id: vented.id,
                          title: vented.title,
                          content: vented.content,
                          feeling: vented.feeling,
                          author: vented.author,
                          identity: vented.identity,
                          date: timeago.format(vented.createdAt),
                          upvotes: vented.likes,
                          comments: vented.comments,
                          isLiked: vented.isLiked,
                          isDisliked: vented.isDisliked,
                          isSaved: vented.saved
                              .where((element) =>
                                  element.userId ==
                                  homeController.user.value!.id)
                              .isNotEmpty,
                          onTap: () {
                            ventController.selectedVent.value = vented;
                            Get.toNamed('/post');
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text('You haven\'t vented yet.'),
                    ),
        ),
      ),
    );
  }
}
