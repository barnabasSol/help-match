class Token {
  final String accessToken;
  final String refreshToken;
  final String otp;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.otp,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      otp: json['otp'],
    );
  }

  tojson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'otp': otp,
    };
  }
}
