import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/model/Vent.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/widgets/EMComment.dart';
import 'package:shareem_app/widgets/EMPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {
  Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  final tempController = Get.find<TempController>();
  final themeController = Get.find<ThemeController>();
  ScrollController _commentScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ventController.scrollController.value.position.isScrollingNotifier
          .addListener(() {
        if (!ventController
            .scrollController.value.position.isScrollingNotifier.value) {
          ventController.isPostDetailScrolling.value = true;
          _commentScrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    });
    VentApi ventApi = VentApi();
    ventApi.fetchComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          final Vent? vent = ventController.selectedVent.value;
          if (vent == null) {
            return const Center(
              child: Text('No vent selected'),
            );
          } else {
            return SingleChildScrollView(
              controller: ventController.scrollController.value,
              child: Container(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    EMPost(
                      id: vent.id,
                      title: vent.title,
                      content: vent.content,
                      author: vent.identity
                          ? vent.author.fullName
                          : vent.author.hiddenName,
                      authorAvatar: vent.identity ? vent.author.image : null,
                      feeling: vent.feeling,
                      date: timeago.format(vent.createdAt),
                      upvotes: vent.likes,
                      comments: vent.comments,
                      tags: vent.tags,
                      isDetailed: true,
                      bottomBorder: false,
                      isLiked: vent.isLiked,
                      isDisliked: vent.isDisliked,
                      isSaved: vent.saved
                          .where((element) =>
                              element.userId == homeController.user.value!.id)
                          .isNotEmpty,
                    ),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.05),
                      ),
                    ),
                    vent.commentList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vent.commentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final comment = vent.commentList[index];
                                  return EMComment(
                                    content: comment.content,
                                    author: comment.identity
                                        ? comment.user!.fullName ?? ''
                                        : comment.user!.shortHiddenName ?? '',
                                    authorAvatar: comment.identity
                                        ? comment.user?.image
                                        : null,
                                    comments: comment.comments,
                                    upvotes: comment.likes,
                                    date: timeago.format(comment.createdAt,
                                        locale: 'en_short'),
                                  );
                                }),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text('Be the first to comment!'),
                            ),
                          ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomSheet: SafeArea(
        child: BottomSheet(
            enableDrag: false,
            onClosing: () {},
            backgroundColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(.01),
            builder: (BuildContext context) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 30),
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ventController.isPostDetailScrolling.value
                          ? const SizedBox()
                          : Text(
                              "Please follow the community guidelines when commenting.",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.6),
                                fontSize: 12,
                              )),
                      ventController.isPostDetailScrolling.value
                          ? const SizedBox()
                          : const SizedBox(height: 10),
                      TextField(
                        controller: tempController.commentContent.value,
                        scrollController: _commentScrollController,
                        onTap: () {
                          ventController.isPostDetailScrolling.value = false;
                        },
                        onChanged: (value) {
                          ventController.isPostDetailScrolling.value = false;
                        },
                        minLines: 1,
                        maxLines:
                            ventController.isPostDetailScrolling.value ? 1 : 10,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          hintText: 'Add a comment',
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                      ventController.isPostDetailScrolling.value
                          ? const SizedBox()
                          : const SizedBox(height: 20),
                      ventController.isPostDetailScrolling.value
                          ? const SizedBox()
                          : MaterialButton(
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () {
                                VentApi ventApi = VentApi();
                                ventApi.createComment();
                              },
                              elevation: 0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.06),
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.01),
                              highlightColor: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(.01),
                              highlightElevation: 0,
                              child: Text(
                                'Reply',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
