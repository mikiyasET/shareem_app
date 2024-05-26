import 'dart:convert';

class EMResponse {
  bool success;
  dynamic data;
  String message;

  EMResponse({required this.success, this.data, required this.message});

  factory EMResponse.fromJson(dynamic js, {needDecode = true}) {
    try {
      if (needDecode) js = json.decode(js.toString());
      if (js['success'] != null) {
        return EMResponse(
          success: js['success'],
          data: js['data'],
          message: js['message'],
        );
      } else {
        return EMResponse(
          success: false,
          data: 'Unknown',
          message: 'Unknown',
        );
      }
    } catch (e) {
      print('Error parsing EMResponse');
      print(e);
      return EMResponse(
        success: false,
        data: 'Unknown',
        message: 'Unknown',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
    };
  }
}
