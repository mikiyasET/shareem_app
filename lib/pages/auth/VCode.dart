import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/service/api/auth.api.dart';
import 'package:shareem_app/widgets/EMButton.dart';

class Vcode extends StatelessWidget {
  Vcode({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 20),
        width: double.infinity,
        child: Obx(
          () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Verification ${authController.isResetPassword.value}',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                Opacity(
                    opacity: .8,
                    child: Text(
                        'Enter the verification code sent to your email',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400))),
                SizedBox(height: 40),
                Pinput(
                  controller: authController.code.value,
                  validator: (value) {
                    if (authController.isCodeError.value) {
                      return authController.codeErrorText.value;
                    }
                    return null;
                  },
                  errorText: authController.codeErrorText.value,
                  defaultPinTheme: authController.isCodeError.value
                      ? PinTheme(
                          width: 55,
                          height: 55,
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                    authController.verifyCode();
                  },
                  onChanged: (value) {
                    authController.isCodeError.value = false;
                  },
                ),
                SizedBox(height: 30),
                EMButton(
                    label: 'Verify',
                    isLoading: authController.isLoading.value,
                    onPressed: () => authController.verifyCode()),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Opacity(
                    opacity: .8,
                    child: Text('Didn\'t receive the code? ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                  InkWell(
                    onTap: authController.resendLoading.value
                        ? null
                        : () {
                            authController.resendLoading.value = true;
                            AuthApi().forgotPassword(
                              authController.email.value.text,
                              replace: true,
                              resendCode: true,
                            );
                          },
                    child: authController.resendLoading.value
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
