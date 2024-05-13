import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/service/api/auth.api.dart';
import 'package:shareem_app/service/api/user.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';

class EmailCode extends StatelessWidget {
  EmailCode({super.key});

  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        padding:
            const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 20),
        width: double.infinity,
        child: Obx(
          () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Verification',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                const Opacity(
                    opacity: .8,
                    child: Text(
                        'Enter the verification code sent to your email',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400))),
                const SizedBox(height: 40),
                Pinput(
                  controller: tempController.emailCode.value,
                  validator: (value) {
                    if (tempController.isEmailCodeError.value) {
                      return tempController.emailCodeErrorText.value;
                    }
                    return null;
                  },
                  errorText: tempController.emailCodeErrorText.value,
                  defaultPinTheme: tempController.isEmailCodeError.value
                      ? PinTheme(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red, width: 1.5),
                          ),
                        )
                      : PinTheme(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          textStyle: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.transparent, width: 1.5),
                          ),
                        ),
                  isCursorAnimationEnabled: true,
                  length: 6,
                  onCompleted: (value) {
                    UserApi userApi = UserApi();
                    userApi.updateProfile('email');
                  },
                  onChanged: (value) {
                    tempController.isEmailCodeError.value = false;
                  },
                ),
                const SizedBox(height: 30),
                EMButton(
                    label: 'Verify',
                    isLoading: tempController.isUpdateButtonLoading.value,
                    onPressed: () {
                      UserApi userApi = UserApi();
                      userApi.updateProfile('email');
                    }),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Opacity(
                    opacity: .8,
                    child: Text('Didn\'t receive the code? ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                  InkWell(
                    onTap: tempController.isEmailResendLoading.value
                        ? null
                        : () {
                            tempController.isEmailResendLoading.value = true;
                            AuthApi().forgotPassword(
                              tempController.email.value.text,
                              replace: true,
                              resendCode: true,
                            );
                          },
                    child: tempController.isEmailResendLoading.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  strokeWidth: 2),
                            ),
                          )
                        : Text(
                            'Resend',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                  ),
                ]),
              ]),
        ),
      ),
    );
  }
}
