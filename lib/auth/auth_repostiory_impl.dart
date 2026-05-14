import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/auth_remote_datasource.dart';
import 'package:college_management_saas/auth/auth_repository.dart';
import 'package:college_management_saas/core/constants/storage_keys.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<Either<Failure, User>> login(
      String email, String password, String collegeDomain) async {
    try {
      final data = await _remote.login(email, password, collegeDomain);
      await _storage.write(
          key: StorageKeys.accessToken,  value: data['accessToken'] as String);
      await _storage.write(
          key: StorageKeys.refreshToken, value: data['refreshToken'] as String);
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
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
}