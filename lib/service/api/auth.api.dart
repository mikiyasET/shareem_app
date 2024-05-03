import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/core.controller.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/model/User.dart';
import 'package:shareem_app/utils/constants.dart';
import '../../controller/auth.controller.dart';
import '../api.dart';

class AuthApi {
  static API api = API();
  Dio client = api.client;
  final authController = Get.find<AuthController>();
  final coreController = Get.find<CoreController>();

  Future<void> signIn(String email, String password) async {
    try {
      final response = await client.post(signInRoute, data: {
        'email': email,
        'password': password,
      });
      authController.isLoading.value = false;
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.message == 'LOGIN_SUCCESS') {
        final data = res.data;
        final box = GetStorage();
        box.write(accessToken_, data['accessToken']);
        box.write(refreshToken_, data['refreshToken']);
        final coreController = Get.find<CoreController>();
        coreController.user.value = User.fromJson(data['user']);
      }
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'REQUIRED_FIELDS_MISSING':
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          case 'INVALID_EMAIL':
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Invalid email';
            break;
          case 'PASSWORD_LENGTH_ERROR':
            authController.isPasswordError.value = true;
            authController.passwordErrorText.value =
                'Password must be at least 8 characters long';
            break;
          case 'LOGIN_FAILED':
            authController.isPasswordError.value = true;
            authController.passwordErrorText.value =
                'Invalid email or password';
            break;
          default:
            Fluttertoast.showToast(
              msg: 'An error occurred',
            );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }

  Future<void> signUp(String email, String password, String birthDate,
      String code, bool anonymous) async {
    try {
      final response = await client.post(signUpRoute, data: {
        'email': email,
        'password': password,
        'birthDate': birthDate,
        'code': code,
        'anonymous': anonymous
      });
      authController.isLoading.value = false;
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.message == 'REGISTRATION_SUCCESS') {
        final data = res.data;
        final box = GetStorage();
        box.write(accessToken_, data['accessToken']);
        box.write(refreshToken_, data['refreshToken']);
        final coreController = Get.find<CoreController>();
        User? uData = User.fromJson(data['user']);
        coreController.user.value = uData;
        Get.offAllNamed('/');
      }
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'EMAIL_CONFIRM_FAILED':
            authController.isCodeError.value = true;
            authController.codeErrorText.value = 'Invalid code';
            Fluttertoast.showToast(
              msg: "Invalid code",
            );
            break;
          case 'REQUIRED_FIELDS_MISSING':
            Get.offNamedUntil('/signUp', (route) => false);
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          case 'INVALID_EMAIL':
            Get.offNamedUntil('/signUp', (route) => false);
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Invalid email';
            break;
          case 'PASSWORD_LENGTH_ERROR':
            Get.offNamedUntil('/signUp', (route) => false);
            authController.isPasswordError.value = true;
            authController.passwordErrorText.value =
                'Password must be at least 8 characters long';
            authController.isConfirmPasswordError.value = true;
            authController.confirmPasswordErrorText.value =
                'Password must be at least 8 characters long';
            break;
          case 'INVALID_BIRTH_YEAR':
            Get.offNamedUntil('/signUp', (route) => false);
            authController.isDateOfBirthError.value = true;
            authController.dateOfBirthErrorText.value =
                'You must be at least 18 years old';
            break;
          case 'EMAIL_ALREADY_EXISTS':
            Get.offNamedUntil('/signUp', (route) => false);
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Email already exists';
            break;
          case 'REGISTRATION_FAILED':
            Get.offNamedUntil('/signUp', (route) => false);
            Fluttertoast.showToast(
              msg: 'There was an error during registration',
            );
            break;
          default:
            Get.offNamedUntil('/signUp', (route) => false);
            Fluttertoast.showToast(
              msg: 'An error occurred ${error.message}',
            );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }

  Future<void> confirmEmail(
      String email, String password, String birthDate) async {
    try {
      final response = await client.post(confirmEmailRoute, data: {
        'email': email,
        'password': password,
        'birthDate': birthDate,
      });
      authController.isLoading.value = false;
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.message == 'EMAIL_VERIFY_SUCCESS') {
        Get.toNamed('/vCode');
      }
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'REQUIRED_FIELDS_MISSING':
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          case 'INVALID_EMAIL':
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Invalid email';
            break;
          case 'PASSWORD_LENGTH_ERROR':
            authController.isPasswordError.value = true;
            authController.passwordErrorText.value =
                'Password must be at least 8 characters long';
            authController.isConfirmPasswordError.value = true;
            authController.confirmPasswordErrorText.value =
                'Password must be at least 8 characters long';
            break;
          case 'INVALID_BIRTH_YEAR':
            authController.isDateOfBirthError.value = true;
            authController.dateOfBirthErrorText.value =
                'You must be at least 18 years old';
            break;
          case 'EMAIL_ALREADY_EXISTS':
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Email already exists';
            break;
          case 'REGISTRATION_FAILED':
            Fluttertoast.showToast(
              msg: 'There was an error during registration',
            );
            break;
          case 'EMAIL_VERIFY_SUCCESS':
            Fluttertoast.showToast(
              msg: 'Email verification sent',
            );
            break;
          case 'EMAIL_VERIFY_FAILED':
            Fluttertoast.showToast(
              msg: 'Sorry, we couldn\'t send the email verification code',
            );
            break;
          default:
            Fluttertoast.showToast(
              msg: 'An error occurred ${error.message}',
            );
            break;
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }

  Future<void> completeProfile() async {
    try {
      final response = await client.put(completeProfileRoute, data: {
        'username': coreController.username.value.text,
        'fName': coreController.fName.value.text,
        'lName': coreController.lName.value.text,
        'gender': coreController.gender.value.toString().split('.').last[0],
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 &&
          res.message == 'REGISTRATION_COMPLETED') {
        coreController.user.value = User.fromJson(res.data);
      }
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'FIRST_NAME_LENGTH_ERROR':
            coreController.isfNameError.value = true;
            coreController.fNameErrorText.value =
                'First name must be at least 3 characters long';
            break;
          case 'LAST_NAME_LENGTH_ERROR':
            coreController.islNameError.value = true;
            coreController.lNameErrorText.value =
                'Last name must be at least 3 characters long';
            break;
          case 'USERNAME_ALREADY_EXISTS':
            coreController.isUsernameError.value = true;
            coreController.usernameErrorText.value = 'Username already exists';
            break;
          case 'USERNAME_LENGTH_ERROR':
            coreController.isUsernameError.value = true;
            coreController.usernameErrorText.value =
                'Username must be at least 4 characters long';
            break;
          case 'INVALID_GENDER':
            coreController.isGenderError.value = true;
            coreController.genderErrorText.value = 'Invalid gender value';
            break;
          case 'REGISTRATION_COMPLETION_FAILED':
            Fluttertoast.showToast(
              msg: 'There was an error during registration',
            );
            break;
          case 'REGISTRATION_ALREADY_COMPLETED':
            Fluttertoast.showToast(
              msg: 'Registration already completed',
            );
            Get.offAllNamed('/');
            break;
          case 'REQUIRED_FIELDS_MISSING':
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          default:
            Fluttertoast.showToast(
              msg: 'An error occurred ${error.message}',
            );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }

  Future<void> forgotPassword(String email, {replace = false, resendCode = false}) async {
    try {
      final response = await client.post(forgotPasswordRoute, data: {
        'email': email,
      });
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 && res.message == 'FORGOT_SUCCESS') {
        authController.isResetPassword.value = true;
        if (replace) {
          Get.offNamed('/vCode');
        } else {
          Get.toNamed('/vCode');
        }
        if (resendCode) {
          authController.resendLoading.value = false;
          Fluttertoast.showToast(
            msg: 'Verification code resent',
          );
        }
      }
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'INVALID_EMAIL':
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Invalid email address';
            break;
          case 'USER_NOT_FOUND':
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Please check the email and try again.';
            break;
          case 'FORGOT_FAILED':
            Fluttertoast.showToast(
              msg: 'There was an error during password reset',
            );
            break;
          case 'ACCOUNT_NOT_READY_FOR_FORGOT':
            Fluttertoast.showToast(
              msg:
                  'You can\'t reset your password of an account that is not yet activated',
            );
            break;
          case 'FORGOT_EMAILING_FAILED':
            Fluttertoast.showToast(
              msg: 'Sorry, we couldn\'t send the email verification code',
            );
            break;
          case 'REQUIRED_FIELDS_MISSING':
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          default:
            Fluttertoast.showToast(
              msg: 'An error occurred ${error.message}',
            );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }

  Future<void> resetPasswordVerify(String email, String code) async {
    try {
      final response = await client.post(forgotPasswordVerifyRoute,
          data: {'email': email, 'code': code});
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 &&
          res.message == 'FORGOT_VERIFY_SUCCESS') {
        authController.isResetPassword.value = false;
        authController.resetAccessToken.value = res.data['token'];
        authController.isCodeError.value = false;
        Get.offNamed('/changePassword');
      }
      authController.isLoading.value = false;
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'INVALID_EMAIL':
            authController.isEmailError.value = true;
            authController.emailErrorText.value = 'Invalid email address';
            break;
          case 'FORGOT_VERIFY_FAILED':
            authController.isCodeError.value = true;
            authController.codeErrorText.value = 'Invalid code';
            Fluttertoast.showToast(
              msg: 'Sorry, we couldn\'t verify the code',
            );
            break;
          case 'REQUIRED_FIELDS_MISSING':
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          default:
            Fluttertoast.showToast(
              msg: 'An error occurred ${error.message}',
            );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }

  Future<void> changePassword(String password, String confirmPassword) async {
    try {
      final response = await client.post(
        resetPasswordRoute,
        data: {'password': password, 'confirmPassword': confirmPassword},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authController.resetAccessToken.value}',
          },
        ),
      );
      EMResponse res = EMResponse.fromJson(response.toString());
      if (response.statusCode == 200 &&
          res.message == 'RESET_PASSWORD_SUCCESS') {
        authController.isResetPassword.value = false;
        authController.resetAccessToken.value = '';
        Fluttertoast.showToast(msg: 'Password changed successfully');
        Get.offAllNamed('/signIn');
      }
      authController.isLoading.value = false;
    } on DioException catch (e) {
      authController.isLoading.value = false;
      if (e.response != null) {
        EMResponse error = EMResponse.fromJson(e.response.toString());
        switch (error.message) {
          case 'PASSWORD_LENGTH_ERROR':
            authController.isPasswordError.value = true;
            authController.passwordErrorText.value = 'Password is too short';
            authController.isConfirmPasswordError.value = true;
            authController.confirmPasswordErrorText.value =
                'Confirm password is too short';
            break;
          case 'RESET_PASSWORD_MISMATCH':
            authController.isConfirmPasswordError.value = true;
            authController.confirmPasswordErrorText.value =
                'Passwords do not match';
            break;
          case 'RESET_PASSWORD_FAILED':
            Fluttertoast.showToast(
              msg: 'There was an error during password reset',
            );
            break;
          case 'REQUIRED_FIELDS_MISSING':
            Fluttertoast.showToast(
              msg: 'Please fill in all the required fields',
            );
            break;
          default:
            Fluttertoast.showToast(
              msg: 'An error occurred ${error.message}',
            );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later',
        );
      }
    }
  }
}
