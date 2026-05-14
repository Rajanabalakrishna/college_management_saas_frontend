import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:college_management_saas/core/constants/api_constants.dart';
import 'package:college_management_saas/core/constants/storage_keys.dart';
import 'package:college_management_saas/providers/secure_storage_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(secureStorageProvider);
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(_JwtInterceptor(dio, storage));
  return dio;
});

class _JwtInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  _JwtInterceptor(this._dio, this._storage);

  // Attach access token to every request
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  // Auto-refresh on 401
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refresh = await _storage.read(key: StorageKeys.refreshToken);
      if (refresh == null) return handler.next(err);

      try {
        final res = await _dio.post(ApiConstants.refresh,
            data: {'refreshToken': refresh});
        final newToken = res.data['accessToken'] as String;
        await _storage.write(key: StorageKeys.accessToken, value: newToken);
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        return handler.resolve(await _dio.fetch(err.requestOptions));
      } catch (_) {
        await _storage.deleteAll();
      }
    }
    return handler.next(err);
  }
}