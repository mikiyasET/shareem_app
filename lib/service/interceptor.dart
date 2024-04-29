import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/utils/constants.dart';

class DioInterceptor extends Interceptor {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  final box = GetStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = box.read(accessToken_);
    final headers = token != null
        ? {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token ?? ''}",
          }
        : {
            "Content-Type": "application/json",
          };
    options.headers.addAll(headers);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the user is unauthorized.
    if (err.response?.statusCode == 401) {
      await refreshTokenFunc();
      // Retry the request.
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    return super.onError(err, handler);
  }

  Future<Response<dynamic>> refreshTokenFunc() async {
    try {
      var response = await dio.post(refreshTokenRoute,
          options: Options(headers: {
            "Refresh-Token": box.read(refreshToken_),
          }));
      // on success response, deserialize the response
      if (response.statusCode == 200) {
        // LoginRequestResponse requestResponse =
        //    LoginRequestResponse.fromJson(response.data);
        // UPDATE the STORAGE with new access and refresh-tokens
        box.write(accessToken_, response.data['accessToken']);
        box.write(refreshToken_, response.data['refreshToken']);
        return response;
      }
      return response;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        // If the refresh token is expired, log the user out.
        box.remove(accessToken_);
        box.remove(refreshToken_);
      }
      return e.response!;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    if (box.read(accessToken_) == null || box.read(refreshToken_) == null) {
      return dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
      );
    } else {
      final String? token = box.read(accessToken_);
      // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
      final options = Options(
        method: requestOptions.method,
        headers: {
          "Authorization": "Bearer ${token}",
        },
      );

      // Retry the request with the new `RequestOptions` object.
      return dio.request<dynamic>(requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options);
    }
  }
}
