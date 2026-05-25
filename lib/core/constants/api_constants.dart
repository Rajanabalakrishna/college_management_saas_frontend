class ApiConstants {
  ApiConstants._();

  // For Android emulator local backend:
  // static const String baseUrl = 'http://10.0.2.2:5000/api/v1';

  // For Windows / Flutter web local backend:
  // static const String baseUrl = 'http://localhost:5000/api/v1';

  // For real phone testing through ngrok:
  static const String baseUrl =
      'https://overrashly-vicissitudinous-ayla.ngrok-free.dev/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String register = '/auth/register';

  // Assignments
  static const String assignments = '/assignments';

  // Attendance
  static const String attendance = '/attendance';
  static const String attendanceStudents = '/attendance/students';

  static const String results = '/results';
  static const String myResults = '/results/me';

  static const String subscriptionPlans = '/payments/subscription/plans';
  static const String subscriptionMe = '/payments/subscription/me';
  static const String subscriptionCreateOrder =
      '/payments/subscription/create-order';

  static const String feeInvoices = '/payments/fees/me';
  static String payFeeInvoice(String invoiceId) =>
      '/payments/fees/$invoiceId/pay';
  static String feeReceipt(String receiptId) =>
      '/payments/fees/receipts/$receiptId';

  static const String saveFcmToken = '/notifications/device-token';
  static const String notifications = '/notifications/me';
  static String markNotificationRead(String id) =>
      '/notifications/$id/read';

  static String assignmentById(String id) => '/assignments/$id';
  static String assignmentSubmissions(String id) => '/assignments/$id/submissions';
  static String assignmentMySubmission(String id) => '/assignments/$id/my-submission';
  static String gradeSubmission(String assignmentId, String submissionId) =>
      '/assignments/$assignmentId/submissions/$submissionId/grade';
}

class CloudinaryConstants {
  CloudinaryConstants._();

  static const String cloudName = 'dtixqjrml';
  static const String apiKey = '215651613889572';
  static const String apiSecret = 'ji-4CLRIhDjWDbKW0hr04wuyGYg';
  static const String uploadPreset = 'college_saas';
  static const String folder = 'college-management/users';
}