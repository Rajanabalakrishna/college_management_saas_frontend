class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // iOS simulator

  static const String login   = '/auth/login';
  static const String logout  = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me      = '/auth/me';
  static const String register = '/auth/register';

}


class CloudinaryConstants {
  CloudinaryConstants._();

  static const String cloudName = 'dtixqjrml';
  static const String apiKey = '215651613889572';
  static const String apiSecret = 'ji-4CLRIhDjYDbKW0hr04wuyGYg';
  static const String uploadPreset = 'YOUR_UNSIGNED_UPLOAD_PRESET'; // Replace with your actual upload preset from Cloudinary settings
  static const String folder = 'college-management/users';
}
