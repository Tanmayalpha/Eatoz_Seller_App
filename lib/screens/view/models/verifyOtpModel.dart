import 'dart:convert';

/// response_code : "1"
/// message : "user login success"
/// status : "success"
/// user_id : "6"
/// user_token : ""

VerifyOtpModel verifyOtpModelFromJson(String str) =>
    VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  VerifyOtpModel({
    String? responseCode,
    String? message,
    String? status,
    String? userId,
    String? userToken,
  }) {
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _userId = userId;
    _userToken = userToken;
  }

  VerifyOtpModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    _userId = json['user_id'];
    _userToken = json['user_token'];
  }

  String? _responseCode;
  String? _message;
  String? _status;
  String? _userId;
  String? _userToken;

  VerifyOtpModel copyWith({
    String? responseCode,
    String? message,
    String? status,
    String? userId,
    String? userToken,
  }) =>
      VerifyOtpModel(
        responseCode: responseCode ?? _responseCode,
        message: message ?? _message,
        status: status ?? _status,
        userId: userId ?? _userId,
        userToken: userToken ?? _userToken,
      );

  String? get responseCode => _responseCode;

  String? get message => _message;

  String? get status => _status;

  String? get userId => _userId;

  String? get userToken => _userToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['message'] = _message;
    map['status'] = _status;
    map['user_id'] = _userId;
    map['user_token'] = _userToken;
    return map;
  }
}
