import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/service/api/vent.api.dart';
import 'package:shareem_app/utils/enums.dart';

class TempController extends GetxController {
  final RxInt postId = 0.obs;
  final Rx<TextEditingController> postTitle = TextEditingController().obs;
  final Rx<TextEditingController> postContent = TextEditingController().obs;
  final Rx<TextEditingController> commentContent = TextEditingController().obs;
  final RxString postTitleText = ''.obs;
  final RxString postContentText = ''.obs;
  final Rx<String> feeling = ''.obs;
  final RxString profileImage = ''.obs;
  final RxBool isUpdateButtonLoading = false.obs;

  final Rx<TextEditingController> username = TextEditingController().obs;
  final Rx<TextEditingController> fName = TextEditingController().obs;
  final Rx<TextEditingController> lName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> emailCode = TextEditingController().obs;
  final Rx<TextEditingController> currentPassword = TextEditingController().obs;
  final Rx<TextEditingController> newPassword = TextEditingController().obs;
  final Rx<TextEditingController> confirmPassword = TextEditingController().obs;
  final Rx<Gender> gender = Gender.none.obs;
  final RxBool isEmailResendLoading = false.obs;
  final RxBool userIdentity = false.obs;

  final RxBool isUsernameError = false.obs;
  final RxBool isfNameError = false.obs;
  final RxBool islNameError = false.obs;
  final RxBool isEmailError = false.obs;
  final RxBool isGenderError = false.obs;
  final RxBool isEmailCodeError = false.obs;
  final RxBool isCurrentPasswordError = false.obs;
  final RxBool isNewPasswordError = false.obs;
  final RxBool isConfirmPasswordError = false.obs;

  final RxString usernameErrorText = 'Username is required'.obs;
  final RxString fNameErrorText = 'First name is required'.obs;
  final RxString lNameErrorText = 'Last name is required'.obs;
  final RxString emailErrorText = 'Email is required'.obs;
  final RxString genderErrorText = 'Gender is required'.obs;
  final RxString emailCodeErrorText = 'Email code is required'.obs;
  final RxString currentPasswordErrorText = 'Current password is required'.obs;
  final RxString newPasswordErrorText = 'New password is required'.obs;
  final RxString confirmPasswordErrorText = 'Confirm password is required'.obs;

  @override
  void onInit() {
    final homeController = Get.find<HomeController>();
    userIdentity.value = homeController.user.value?.identity ?? false;
    super.onInit();
  }

  void clearVentValues() {
    postId.value = 0;
    postTitle.value.clear();
    postContent.value.clear();
    postTitleText.value = '';
    postContentText.value = '';
    feeling.value = '';
  }
}
