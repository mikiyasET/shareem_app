import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/helpers/format.helper.dart';
import 'package:shareem_app/service/api/tag.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';

class Tags extends StatelessWidget {
  Tags({super.key});

  final ventController = Get.find<VentController>();

  @override
  Widget build(BuildContext context) {
    TagApi tagApi = TagApi();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text('Tags'),
        ),
        body: FutureBuilder(
          future: tagApi.fetchTags(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (ventController.tags.isNotEmpty) {
                return Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(
                          "You can select multiple tags ${ventController.selectedTags.length}/4",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.8),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: ventController.tags.length,
                          itemBuilder: (context, index) {
                            final tag = ventController.tags[index];
                            return CheckboxListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 23),
                              title: Text(
                                  ucWords(ventController.tags[index].name)),
                              value: ventController.selectedTags
                                      .firstWhereOrNull((element) =>
                                          element ==
                                          ventController.tags[index].id) !=
                                  null,
                              onChanged: (_) {
                                if (ventController.selectedTags
                                        .firstWhereOrNull((element) =>
                                            element ==
                                            ventController.tags[index].id) !=
                                    null) {
                                  ventController.selectedTags
                                      .remove(ventController.tags[index].id);
                                } else {
                                  if (ventController.selectedTags.length < 4) {
                                    ventController.selectedTags
                                        .add(ventController.tags[index].id);
                                  } else {
                                    HapticFeedback.mediumImpact();
                                    Fluttertoast.showToast(
                                      msg: "You can only select 4 tags",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                  }
                                }
                              },
                              controlAffinity: ListTileControlAffinity.platform,
                              activeColor:
                                  Theme.of(context).colorScheme.onSurface,
                              checkColor: Theme.of(context).colorScheme.surface,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                    child: Text(
                  "No tags found ${ventController.tags.length}",
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(.7),
                  ),
                ));
              }
            } else {
              return const Text("Something went wrong");
            }
          }),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: EMButton(
                label: 'Save', onPressed: () => Navigator.pop(context)),
          ),
        ));
  }
}
