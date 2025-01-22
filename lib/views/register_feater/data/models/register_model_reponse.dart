class RegisterModelReponse {
  final String token;
  final bool flag;
  final String message;

RegisterModelReponse(
      {required this.flag, required this.message, required this.token});

  static RegisterModelReponse fromJson(Map<String, dynamic> json) {
    return RegisterModelReponse(
        token: json['token'] ?? "",
        flag: json["flag"] ?? false,
        message: json['message'] ?? "");
  }
}
