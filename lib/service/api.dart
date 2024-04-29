import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shareem_app/service/interceptor.dart';
import 'package:shareem_app/utils/constants.dart';

class API {
  API() {
    // port 3100
    client = Dio();
    client.options.baseUrl = BASE_URL;
    client.options.connectTimeout = const Duration(seconds: 5);
    client.options.receiveTimeout = const Duration(seconds: 30);
    client.options.followRedirects = false;
    client.interceptors.add(DioInterceptor());
  }

  late Dio client;

  void setToken(String authToken) {
    if (authToken.isNotEmpty)
      client.options.headers['Authorization'] = 'Bearer $authToken';
  }

  Future<void> clientSetup() async {
    final box = GetStorage();
    final String token = box.read(accessToken_);
    if (token.isNotEmpty)
      client.options.headers['Authorization'] = 'Bearer $token';
  }
}
