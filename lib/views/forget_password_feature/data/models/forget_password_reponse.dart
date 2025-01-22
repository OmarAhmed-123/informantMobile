class FpasswordModelReponse {
  final String token;
  final bool flag;
  final String message;

  FpasswordModelReponse(
      {required this.flag, required this.message, required this.token});

  static FpasswordModelReponse fromJson(Map<String, dynamic> json) {
    return FpasswordModelReponse(
        token: json['token'] ?? "",
        flag: json["flag"] ?? false,
        message: json['message'] ?? "");
  }
}
