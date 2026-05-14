import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/auth_repository.dart';

// ── Shared base ───────────────────────────────────────────
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class NoParams {}

// ── Params ────────────────────────────────────────────────
class LoginParams {
  final String email;
  final String password;
  final String collegeDomain;
  LoginParams({
    required this.email,
    required this.password,
    required this.collegeDomain,
  });
}

// ── UseCases ──────────────────────────────────────────────
class GetMeUseCase implements UseCase<User, NoParams> {
  final AuthRepository _repo;
  GetMeUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(NoParams params) => _repo.getMe();
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(LoginParams params) =>
      _repo.login(params.email, params.password, params.collegeDomain);
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repo;
  LogoutUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repo.logout();
}