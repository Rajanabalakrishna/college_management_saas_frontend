class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // iOS simulator

  static const String login   = '/auth/login';
  static const String logout  = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me      = '/auth/me';
}