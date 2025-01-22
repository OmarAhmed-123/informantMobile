class EmailModelReponse {
  final String token;
  final bool flag;
  final String message;

  EmailModelReponse(
      {required this.flag, required this.message, required this.token});

  static EmailModelReponse fromJson(Map<String, dynamic> json) {
    return EmailModelReponse(
        token: json['token'] ?? "",
        flag: json["flag"] ?? false,
        message: json['message'] ?? "");
  }
}
