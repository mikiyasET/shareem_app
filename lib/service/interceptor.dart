import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/controller/auth.controller.dart';
import 'package:shareem_app/model/Error.dart';
import 'package:shareem_app/utils/constants.dart';

class DioInterceptor extends Interceptor {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = GetStorage();
    final String? token = box.read(accessToken_);
    final headers = token != null
        ? {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }
        : {
            "Content-Type": "application/json",
          };
    options.headers.addAll(headers);
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError) {
      Fluttertoast.showToast(msg: "Connection Error");
    }
    if (err.response?.statusCode == 401) {
      await refreshTokenFunc();
      try {
        final box = GetStorage();
        final String? token = box.read(accessToken_);
        final headers = token != null
            ? {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token",
              }
            : {
                "Content-Type": "application/json",
              };
        err.requestOptions.headers.addAll(headers);
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        handler.next(e);
      }
      return;
    }
    return super.onError(err, handler);
  }

  Future<Response<dynamic>> refreshTokenFunc() async {
    try {
      final box = GetStorage();

      var response = await dio.post(
        refreshTokenRoute,
        data: {
          "Refresh-Token": box.read(refreshToken_),
        },
      );
      if (response.statusCode == 200) {
        EMResponse emResponse = EMResponse.fromJson(response);

        await box.write(accessToken_, emResponse.data['accessToken']);
        await box.write(refreshToken_, emResponse.data['refreshToken']);
        return response;
      }
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        final authController = Get.find<AuthController>();
        authController.logoutUser();
      }
      return e.response!;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final box = GetStorage();
    if (box.read(accessToken_) == null || box.read(refreshToken_) == null) {
      return dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );
    } else {
      final String? token = box.read(accessToken_);
      final options = Options(
        method: requestOptions.method,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      return dio.request<dynamic>(requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options);
    }
  }
}
