import 'dart:convert';

class EMResponse {
  bool success;
  dynamic data;
  String message;

  EMResponse({required this.success, this.data, required this.message});

  factory EMResponse.fromJson(dynamic json) {
    try {
      json = jsonDecode(json);
      if (json['success'] != null) {
        return EMResponse(
          success: json['success'],
          data: json['data'],
          message: json['message'],
        );
      } else {
        return EMResponse(
          success: false,
          data: 'Unknown',
          message: 'Unknown',
        );
      }
    } catch (e) {
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
