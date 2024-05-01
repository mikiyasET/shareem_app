import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pinput/pinput.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/widgets/main/EMBottomNav.dart';
import 'package:shareem_app/widgets/main/EMPageStack.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final homeController = Get.put(HomeController());
  final tempController = Get.put(TempController());
  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) {
    homeController.user.value = coreController.user.value;
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
                    margin: EdgeInsets.only(right: 10),
                    child: MaterialButton(
                      elevation: 0,
                      splashColor: Colors.transparent,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      highlightColor:
                          Theme.of(context).colorScheme.surface.withOpacity(.2),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: tempController.postTitleText.value.length > 0 && tempController.postBodyText.value.length > 0  ? () {} : null,
                      color: Theme.of(context).colorScheme.onSurface,
                      disabledColor: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
                      disabledTextColor: Theme.of(context).colorScheme.onSurface.withOpacity(.4),
                      child: Text('Post'),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
      body: EMPageStack(),
      bottomNavigationBar: EMBottomNav(),
    );
  }
}
