import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:college_management_saas/auth/User/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(
      String email, String password, String collegeDomain);
  Future<Either<Failure, User>> getMe();
  Future<Either<Failure, void>> logout();
}