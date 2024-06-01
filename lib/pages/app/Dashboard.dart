import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/controller/chat.controller.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/controller/vent.controller.dart';
import 'package:shareem_app/helpers/vent.helper.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/widgets/EMLoading.dart';
import 'package:shareem_app/widgets/main/EMBottomNav.dart';
import 'package:shareem_app/widgets/main/EMPageStack.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final homeController = Get.put(HomeController());
  final ventController = Get.put(VentController());
  final tempController = Get.put(TempController());
  final chatController = Get.put(ChatController());

  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  final coreController = Get.find<CoreController>();

  final VentApi ventApi = VentApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(homeController.title.value)),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          Obx(
            () => homeController.pageIndex.value == 2
                ? Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: MaterialButton(
                      elevation: 0,
                      splashColor: Colors.transparent,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      highlightColor:
                          Theme.of(context).colorScheme.surface.withOpacity(.2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: tempController
                                  .postTitleText.value.isNotEmpty &&
                              tempController.postContentText.value.isNotEmpty &&
                              tempController.isPostLoading.value == false
                          ? () => postVent(context)
                          : null,
                      color: Theme.of(context).colorScheme.onSurface,
                      disabledColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.1),
                      disabledTextColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.4),
                      child: tempController.isPostLoading.value
                          ? EMLoading()
                          : const Text('Post'),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: EMPageStack(),
      bottomNavigationBar: EMBottomNav(),
    );
  }
}
