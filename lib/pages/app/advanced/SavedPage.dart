import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedPage extends StatelessWidget {
  SavedPage({super.key});

  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  UserApi userApi = UserApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: FutureBuilder(
        future: userApi.fetchSaved(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(
              () => ListView.builder(
                itemCount: homeController.userSaved.length,
                itemBuilder: (context, index) {
                  final saved = homeController.userSaved.value[index].vent!;
                  return EMPost(
                    id: saved.id,
                    title: saved.title,
                    content: saved.content,
                    feeling: saved.feeling,
                    author: saved.author.fullName,
                    date: timeago.format(saved.createdAt),
                    upvotes: saved.likes,
                    comments: saved.comments,
                    isLiked: saved.isLiked,
                    isDisliked: saved.isDisliked,
                    isSaved: saved.saved
                        .where((element) =>
                            element.userId == homeController.user.value!.id)
                        .isNotEmpty,
                    tools: false,
                    onTap: () {
                      print(saved.saved[0].toJson());
                      ventController.selectedVent.value = saved;
                      Get.toNamed('/post');
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
