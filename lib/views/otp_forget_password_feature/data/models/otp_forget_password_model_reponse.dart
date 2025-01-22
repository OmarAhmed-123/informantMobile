class OtpPasswordModelReponse {
  final String token;
  final bool flag;
  final String message;

  OtpPasswordModelReponse(
      {required this.flag, required this.message, required this.token});

  static OtpPasswordModelReponse fromJson(Map<String, dynamic> json) {
    return OtpPasswordModelReponse(
        token: json['token'] ?? "",
        flag: json["flag"] ?? false,
        message: json['message'] ?? "");
  }
}
