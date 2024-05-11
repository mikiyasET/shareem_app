import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/utils/constants.dart';

class DraftPage extends StatefulWidget {
  DraftPage({super.key});

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  final homeController = Get.find<HomeController>();
  final ventController = Get.find<VentController>();
  final tempController = Get.find<TempController>();

  final box = GetStorage();

  @override
  void initState() {
    ventController.fetchDrafts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Drafts'),
      ),
      body: Obx(
        () => ventController.drafts.length > 0
            ? ListView.separated(
                itemCount: ventController.drafts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashFactory: InkRipple.splashFactory,
                    onTap: () {
                      tempController.postTitle.value
                          .setText(ventController.drafts[index].title);
                      tempController.postTitleText.value =
                          ventController.drafts[index].title;
                      tempController.postContent.value
                          .setText(ventController.drafts[index].content);
                      tempController.postContentText.value =
                          ventController.drafts[index].content;
                      tempController.feeling.value =
                          ventController.drafts[index].feeling.name;
                      ventController.selectedTags.value = ventController
                          .drafts[index].tags
                          .map((e) => e.id)
                          .toList();
                      homeController.changePage(2);
                      ventController
                          .removeDraft(ventController.drafts[index].id);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ventController.drafts[index].title,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Saved by you",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            color: Colors.redAccent,
                            selectedIcon: const Icon(Icons.delete,
                                size: 20, color: Colors.yellowAccent),
                            icon: const Icon(Icons.delete,
                                size: 20, color: Colors.red),
                            onPressed: () {
                              ventController
                                  .removeDraft(ventController.drafts[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 0.2,
                    height: 0.2,
                  );
                },
              )
            : Center(child: Text('No drafts')),
      ),
    );
  }
}
