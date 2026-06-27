// ═══════════════════════════════════════════════════════════
// TransitID — App Constants
// ═══════════════════════════════════════════════════════════

class AppConstants {
  AppConstants._();

  // API
  // Using the live cloud domain so the app works anywhere over the internet!
  // Fallback / Local emulator option: 'http://10.0.2.2:8004/api'
  static const String baseUrl = 'https://api-transitid.uzinc.uz/api';
  static const String prodUrl = 'https://api-transitid.uzinc.uz/api';

  // Colors (hex values for reference)
  static const int primaryCyan = 0xFF00F0FF;
  static const int secondaryPurple = 0xFFD400FF;
  static const int darkBg = 0xFF0F111A;
  static const int cardDark = 0xFF1E2130;
  static const int cardDarkAlt = 0xFF161829;

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userPhoneKey = 'user_phone';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';

  // OTP
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;
}
