import 'dart:convert';

class LoginResponse {
  final String responseCode;
  final int statusCode;
  final String message;
  final Result result;

  LoginResponse({
    required this.responseCode,
    required this.statusCode,
    required this.message,
    required this.result,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      responseCode: json['responseCode'],
      statusCode: json['statusCode'],
      message: json['message'],
      result: Result.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'statusCode': statusCode,
      'message': message,
      'result': result.toJson(),
    };
  }
}

class Result {
  final User user;
  final String token;

  Result({required this.user, required this.token});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final String id;
  final String type;

  User({required this.id, required this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
    };
  }
}
