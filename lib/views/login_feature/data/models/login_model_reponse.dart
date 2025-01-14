class LoginModelReponse {
  final String token;
  final bool flag;
  final String message;

  LoginModelReponse(
      {required this.flag, required this.message, required this.token});

  static LoginModelReponse fromJson(Map<String, dynamic> json) {
    return LoginModelReponse(
        token: json['token'] ?? "",
        flag: json["flag"] ?? false,
        message: json['message'] ?? "");
  }
}
