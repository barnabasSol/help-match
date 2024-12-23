class LoginDto {
  final String username;
  final String password;

  LoginDto({required this.username, required this.password});

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
