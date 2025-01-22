class OtpModelReponse {
  final String token;
  final bool flag;
  final String message;

  OtpModelReponse(
      {required this.flag, required this.message, required this.token});

  static OtpModelReponse fromJson(Map<String, dynamic> json) {
    return OtpModelReponse(
        token: json['token'] ?? "",
        flag: json["flag"] ?? false,
        message: json['message'] ?? "");
  }
}
