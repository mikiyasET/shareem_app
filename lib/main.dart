import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/controller/route.controller.dart';
import 'package:shareem_app/controller/theme.controller.dart';
import 'package:shareem_app/middleware/navigation.middleware.dart';
import 'package:shareem_app/model/User.dart';
import 'package:shareem_app/pages/app/AddPost.dart';
import 'package:shareem_app/pages/app/Post.dart';
import 'package:shareem_app/pages/app/Tags.dart';
import 'package:shareem_app/pages/app/advanced/AdvanceSettings.dart';
import 'package:shareem_app/pages/app/Dashboard.dart';
import 'package:shareem_app/pages/app/UserDetails.dart';
import 'package:shareem_app/pages/app/Settings.dart';
import 'package:shareem_app/pages/app/advanced/EditAccount.dart';
import 'package:shareem_app/pages/app/feelings.dart';
import 'package:shareem_app/pages/auth/ResetPassword.dart';
import 'package:shareem_app/pages/auth/SignUp.dart';
import 'package:shareem_app/pages/auth/SignIn.dart';
import 'package:shareem_app/pages/auth/VCode.dart';
import 'package:shareem_app/pages/auth/changePassword.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/theme.dart';

import 'pages/app/advanced/Account.dart';
import 'package:shareem_app/utils/enums.dart';

void main() async {
  await GetStorage.init();
  runApp(Base());
}

class Base extends StatelessWidget {
  Base({super.key});

  final authController = Get.put(AuthController());
  final coreController = Get.put(CoreController());
  final themeController = Get.put(ThemeController());
  final routeController = Get.put(RouteController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'ShareEm',
        initialRoute: '/',
        theme: EMTheme().lightTheme(),
        themeMode: themeController.theme,
        darkTheme: EMTheme().darkTheme(),
        getPages: [
          GetPage(name: '/', page: () => PagePicker()),
          GetPage(name: '/signUp', page: () => SignUp()),
          GetPage(name: '/signIn', page: () => SignIn()),
          GetPage(name: '/resetPassword', page: () => ResetPassword()),
          GetPage(name: '/changePassword', page: () => ChangePassword()),
          GetPage(name: '/vCode', page: () => Vcode()),
          GetPage(name: '/userDetails', page: () => UserDetails()),
          GetPage(name: '/settings', page: () => Settings()),
          GetPage(name: '/advancedSettings', page: () => AdvancedSettings()),
          GetPage(name: '/account', page: () => Account()),
          GetPage(
            name: '/editAccount',
            page: () => EditAccount(),
            transition: Transition.downToUp,
            fullscreenDialog: true,
          ),
          GetPage(
            name: '/addPost',
            page: () => AddPost(),
            transition: Transition.downToUp,
            fullscreenDialog: true,
          ),
          GetPage(
            name: '/addTags',
            page: () => Tags(),
            transition: Transition.downToUp,
            fullscreenDialog: true,
          ),
          GetPage(
            name: '/addFeelings',
            page: () => Feelings(),
            transition: Transition.downToUp,
            fullscreenDialog: true,
          ),
          GetPage(
            name: '/post',
            page: () => Post(),
            transition: Transition.downToUp,
            fullscreenDialog: true,
          ),
        ],
        routingCallback: NavigationMiddleWare.observer);
  }
}

class PagePicker extends StatelessWidget {
  PagePicker({super.key});

  final coreController = Get.find<CoreController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("Page Refreshed");
      if (coreController.user.value != null) {
        final user = coreController.user.value!;
        if (user.status == Status.incomplete) {
          return UserDetails();
        } else if (user.status == Status.active) {
          return Dashboard();
        } else {
          return const Text("Issue with the account");
        }
      } else {
        final user = UserApi();
        return FutureBuilder(
          future: user.getMe(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (coreController.user.value != null &&
                  coreController.user.value?.status == Status.active) {
                return Dashboard();
              } else if (coreController.user.value != null &&
                  coreController.user.value?.status == Status.incomplete) {
                return UserDetails();
              } else {
                return SignIn();
              }
            } else {
              return Text("Something went wrong");
            }
          },
        );
      }
    });
  }
}
