import 'dart:convert';

class CurrentUser {
  final String username;
  final String? orgId;
  final String role;
  final String iss;
  final String sub;
  final List<String> aud;
  final int exp;
  final int iat;

  CurrentUser({
    required this.username,
    required this.orgId,
    required this.role,
    required this.iss,
    required this.sub,
    required this.aud,
    required this.exp,
    required this.iat,
  });

  factory CurrentUser.fromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid token format');
    }

    String normalizedPayload = base64Url.normalize(parts[1]);
    final payloadBytes = base64Url.decode(normalizedPayload);
    final payloadMap =
        json.decode(utf8.decode(payloadBytes)) as Map<String, dynamic>;

    return CurrentUser(
      username: payloadMap['username'] as String,
      orgId: payloadMap['org_id'] as String? ?? '',
      role: payloadMap['role'] as String,
      iss: payloadMap['iss'] as String,
      sub: payloadMap['sub'] as String,
      aud: List<String>.from(payloadMap['aud'] as List),
      exp: payloadMap['exp'] as int,
      iat: payloadMap['iat'] as int,
    );
  }

  bool isExpired() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }

  DateTime expiryDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }
}
