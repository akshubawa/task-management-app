import 'dart:convert';

/// Decodes a JWT and returns the payload's `exp` (expiration) claim in seconds since epoch.
/// Returns null if the token is invalid or has no exp claim.
int? getExpirationFromToken(String? token) {
  if (token == null || token.isEmpty) return null;
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    String payload = parts[1];
    // Base64Url may need padding
    switch (payload.length % 4) {
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
    }
    final decoded = utf8.decode(base64Url.decode(payload));
    final map = jsonDecode(decoded) as Map<String, dynamic>;
    final exp = map['exp'];
    if (exp is int) return exp;
    if (exp is num) return exp.toInt();
    return null;
  } catch (_) {
    return null;
  }
}

/// Returns true if the token is expired or will expire within [bufferSeconds].
bool isTokenExpiredOrExpiring(String? token, {int bufferSeconds = 60}) {
  final exp = getExpirationFromToken(token);
  if (exp == null) return true;
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return now >= exp - bufferSeconds;
}
