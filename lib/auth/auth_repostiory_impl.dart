import 'dart:convert';

import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/auth_remote_datasource.dart';
import 'package:college_management_saas/auth/auth_repository.dart';
import 'package:college_management_saas/core/constants/storage_keys.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<Either<Failure, User>> login(
      String email,
      String password,
      String collegeDomain,
      ) async {
    try {
      final data = await _remote.login(email, password, collegeDomain);

      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);

      final expiry = _readExpiryFromResponseOrToken(data, accessToken);

      await _storage.write(key: StorageKeys.accessToken, value: accessToken);
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
      await _storage.write(key: StorageKeys.user, value: jsonEncode(user.toJson()));
      await _storage.write(key: StorageKeys.loggedIn, value: 'true');
      await _storage.write(key: StorageKeys.collegeDomain, value: collegeDomain);

      if (expiry != null) {
        await _storage.write(
          key: StorageKeys.accessTokenExpiry,
          value: expiry.toIso8601String(),
        );
      }

      return Right(user);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final user = await _remote.getMe();

      await _storage.write(
        key: StorageKeys.user,
        value: jsonEncode(user.toJson()),
      );

      return Right(user);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _storage.read(key: StorageKeys.refreshToken);
      if (token != null) await _remote.logout(token);

      await _storage.deleteAll();
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
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
      final user = await _remote.register(
        email: email,
        password: password,
        fullName: fullName,
        collegeDomain: collegeDomain,
        role: role,
        imageUrl: imageUrl,
        rollNo: rollNo,
        branch: branch,
      );

      return Right(user);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  DateTime? _readExpiryFromResponseOrToken(
      Map<String, dynamic> data,
      String accessToken,
      ) {
    final responseExpiry =
        data['accessTokenExpiresAt'] ?? data['accessTokenExpiry'] ?? data['expiresAt'];

    if (responseExpiry is String) {
      return DateTime.tryParse(responseExpiry);
    }

    return _expiryFromJwt(accessToken);
  }

  DateTime? _expiryFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final exp = json['exp'];

      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (_) {}

    return null;
  }
}