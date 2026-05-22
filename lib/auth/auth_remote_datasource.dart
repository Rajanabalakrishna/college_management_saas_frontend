import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dio/dio.dart';
import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/core/constants/api_constants.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(
      String email, String password, String collegeDomain);
  Future<User> getMe();
  Future<void> logout(String refreshToken);
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
    required String collegeDomain,
    required String role,
    String? imageUrl,
    String? rollNo,
    String? branch,
  });

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
    required String collegeDomain,
    required String role,
    String? imageUrl,
    String? rollNo,
    String? branch,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.register, data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'college_domain': collegeDomain,
        'role': role,
        'image_url': imageUrl,
        'roll_no': rollNo,
        'branch': branch,
      });

      return User.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerFailure(
        e.response?.data?['error'] as String? ??
            e.response?.data?['message'] as String? ??
            'Registration failed',
      );
    }
  }



  @override
  Future<Map<String, dynamic>> login(
      String email, String password, String collegeDomain) async {
    try {
      final res = await _dio.post(ApiConstants.login, data: {
        'email':          email,
        'password':       password,
        'college_domain': collegeDomain,
      });
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data?['message'] as String? ?? 'Login failed');
    }
  }

  @override
  Future<User> getMe() async {
    try {
      final res = await _dio.get(ApiConstants.me);
      return User.fromJson(res.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure('Session expired');
      }
      throw ServerFailure(
          e.response?.data?['message'] as String? ?? 'Server error');
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(ApiConstants.logout,
          data: {'refresh_token': refreshToken});
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data?['message'] as String? ?? 'Logout failed');
    }
  }
}