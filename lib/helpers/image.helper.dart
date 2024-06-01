import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shareem_app/controller/home.controller.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/handlers/camera_permission_handler.dart';
import 'package:shareem_app/handlers/photo_permission_handler.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/utils/constants.dart';
import 'package:shareem_app/widgets/EMButton.dart';

Future<void> editPhoto(BuildContext context) async {
  final tempController = Get.find<TempController>();
  final homeController = Get.find<HomeController>();
  // show bottomSheet
  await showModalBottomSheet(
    useSafeArea: true,
    context: context,
    elevation: 4,
    barrierColor: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.2,
                child: tempController.profileImage.value == ''
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // loading
                                Align(
                                  alignment: Alignment.center,
                                  child: PhysicalModel(
                                    clipBehavior: Clip.antiAlias,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.1),
                                    borderRadius: BorderRadius.circular(150),
                                    child:
                                        homeController.user.value?.image == null
                                            ? Icon(Icons.account_circle,
                                                size: 250,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(.2))
                                            : FadeInImage.assetNetwork(
                                                placeholder:
                                                    'images/loading/img_load.gif',
                                                image:
                                                    '$profileUrl/${homeController.user.value?.image}',
                                                fit: BoxFit.cover,
                                                height: 250,
                                                width: 250,
                                              ),
                                  ),
                                ),
                                tempController.isUploadLoading.value == true
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 250,
                                          height: 250,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            Column(
                              children: [
                                EMButton(
                                  label: 'Change from camera',
                                  backgroundColor: Colors.teal,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    pickImage(context, isCamera: true);
                                  },
                                ),
                                const SizedBox(height: 10),
                                EMButton(
                                  label: 'Change from Gallery',
                                  onPressed: () {
                                    pickImage(context, isCamera: false);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: PhysicalModel(
                                    clipBehavior: Clip.antiAlias,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(.1),
                                    borderRadius: BorderRadius.circular(150),
                                    child: Image.file(
                                      File(tempController.profileImage.value),
                                      fit: BoxFit.cover,
                                      height: 250,
                                      width: 250,
                                    ),
                                  ),
                                ),
                                tempController.isUploadLoading.value == true
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 250,
                                          height: 250,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            const SizedBox(height: 20),
                            EMButton(
                              label: 'Save',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              onPressed: () {
                                // Dear Ashenafi, we have commented this part because of the server we host in it's free and they don't allow us to upload images
                                // UserApi userApi = UserApi();
                                // userApi.uploadImage(context);
                                Get.back();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Dear Ashenafi the upload image feature is disabled because of the server we host in it's free and they don't allow us to upload images but you can uncomment it in the code we have completed the upload part we can show you if you want to see sir.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        )),
                                    backgroundColor: Color(0xff068181),
                                    duration: Duration(seconds: 6),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            EMButton(
                              label: 'Clear',
                              onPressed: () {
                                tempController.profileImage.value = '';
                              },
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> pickImage(BuildContext context, {bool isCamera = false}) async {
  try {
    final tempController = Get.find<TempController>();
    final ImagePicker picker = ImagePicker();
    final XFile? image;
    if (isCamera) {
      final cameraPermissionHandler = CameraPermissionsHandler();
      final cameraPermissionStatus = await cameraPermissionHandler.isGranted;
      if (!cameraPermissionStatus) {
        final status = await cameraPermissionHandler.request();
        if (status == CameraPermissionStatus.permanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.horizontal,
              backgroundColor: const Color(0xff068181),
              content:
                  const Text('Please enable camera permission from settings'),
              action: SnackBarAction(
                backgroundColor: const Color(0xff056767),
                label: 'Settings',
                onPressed: () {
                  openAppSettings();
                },
              ),
            ),
          );
          return;
        }
      }
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      final photoPermissionHandler = PhotoPermissionsHandler();
      final photoPermissionStatus = await photoPermissionHandler.isGranted;
      if (!photoPermissionStatus && !isCamera) {
        final status = await photoPermissionHandler.request();
        if (status == PhotoPermissionStatus.permanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.horizontal,
              backgroundColor: const Color(0xff068181),
              content:
                  const Text('Please enable photo permission from settings'),
              action: SnackBarAction(
                backgroundColor: const Color(0xff056767),
                textColor: Colors.white,
                label: 'Settings',
                onPressed: () {
                  openAppSettings();
                },
              ),
            ),
          );
          return;
        }
      }
      image = await picker.pickImage(source: ImageSource.gallery);
    }
    if (image != null) {
      final String path = image.path;
      tempController.profileImage.value = path;
    }
  } on DioException catch (e) {
    if (e.response != null) {
      final error = EMResponse.fromJson(e.response);
      print("Error Fetching Comment");
      print(error.toJson());
    } else {
      print("Error 2");
      print(e);
    }
  } catch (e) {
    print(e);
  }
}
